import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:my_template/features/main_app/home/presentation/screens/confirm_acc_foreign_user.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/my_id_configs/my_id_conf.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/my_id_form_bottom_sheet.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../../../../../core/utils/logger/logger.dart';
import '../../../../../../education_app/features/statistics_edu/presentation_edu/widgets_edu/avatar_view_wg.dart';

class UserAvatarComponent extends StatefulWidget {
  const UserAvatarComponent({super.key});

  @override
  State<UserAvatarComponent> createState() => _UserAvatarComponentState();
}

class _UserAvatarComponentState extends State<UserAvatarComponent> {
  final GlobalKey<TooltipState> _verifiedToolTipKey = GlobalKey<TooltipState>();
  final ImagePicker _picker = ImagePicker();
  static const int _maxImageSizeBytes = 4 * 1024 * 1024; // 4MB

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null || !mounted) return;

    final fixedFile = await _fixImageRotation(pickedFile);

    final int fixedFileSize = await fixedFile.length();

    if (fixedFileSize > _maxImageSizeBytes) {
      errorFlushBar(context, 'Image size must be less than 4 MB');
      return;
    }

    context.read<AvatarBloc>().add(
      AvatarEvent(params: AvatarParams(imagePath: fixedFile.path)),
    );
  }

  /// fix image rotation
  Future<XFile> _fixImageRotation(XFile file) async {
    final Uint8List bytes = await file.readAsBytes();

    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return file;

    final img.Image orientedImage = img.bakeOrientation(decoded);

    final Uint8List fixed = img.encodeJpg(orientedImage, quality: 80);

    final dir = await getTemporaryDirectory();

    final fixedFile = File(
      '${dir.path}/fixed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await fixedFile.writeAsBytes(fixed);

    return XFile(fixedFile.path);
  }

  /// see full avatar iamge
  void _openAvatarViewer(String? thumbnail) {
    if (thumbnail == null) return; // no photo to view

    final ImageProvider image = NetworkImage(thumbnail);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: AvatarViewerPage(image: image, heroTag: 'profile_avatar'),
        ),
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final userMeState = context.watch<UserMeBloc>().state;
    // if (userMeState is UserMeLoaded && !userMeState.entity.isResident) {
    //   return const ConfirmAccForeignUser();
    // }

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const .only(left: 8.0),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(50),
                  side: BorderSide(color: AppColors.greyScale.grey200),
                ),
              ),
              onPressed: () {
                AppRoute.close();
              },
              icon: Icon(IconlyLight.arrow_left_2, size: 20),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .start,
              children: [
                /// User Avatar
                BlocListener<AvatarBloc, AvatarState>(
                  listener: (context, state) {
                    if (state is AvatarLoaded) {
                      context.read<UserMeBloc>().add(UserMeEvent());
                    } else if (state is AvatarError) {
                      errorFlushBar(context, 'Only JPG and PNG allowed!');
                    }
                  },
                  child: BlocBuilder<UserMeBloc, UserMeState>(
                    builder: (context, state) {
                      final bool isLoading = state is UserMeLoading;

                      final String displayName = state is UserMeLoaded
                          ? "${state.entity.firstName.capitalize()} ${state.entity.lastName.capitalize()}"
                          : "Loading...";
                      final String? thumbnail =
                          state is UserMeLoaded && state.entity.avatar != null
                          ? state.entity.avatar
                          : null;
                      final bool isVerified = state is UserMeLoaded
                          ? state.entity.isVerified
                          : false;
                      return Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Stack(
                              children: [
                                /// user avatar
                                BlocBuilder<AvatarBloc, AvatarState>(
                                  builder: (context, avatarState) {
                                    final bool isAvatarLoading =
                                        avatarState is AvatarLoading;
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              _openAvatarViewer(thumbnail),
                                          child: Hero(
                                            tag: 'profile_avatar',
                                            child: CircleAvatar(
                                              radius: 75,
                                              foregroundImage: thumbnail != null
                                                  ? NetworkImage(thumbnail)
                                                  : null,
                                              child: thumbnail == null
                                                  ? Icon(
                                                      Icons.person,
                                                      color: AppColors
                                                          .greyScale
                                                          .grey600,
                                                      size: 90,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        if (isAvatarLoading)
                                          Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: AppColors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),

                                /// add avatar button
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.white
                                          .withValues(alpha: 0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(50),
                                        side: BorderSide(
                                          color: AppColors.greyScale.grey400,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _pickAndUploadImage();
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 28,
                                      color: AppColors.greyScale.grey800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .center,
                              spacing: 5,
                              children: [
                                AutoSizeText(
                                  displayName,
                                  style: AppTextStyles.source.medium(
                                    fontSize: isMobile ? 22 : 32,
                                  ),
                                ),
                                if (isVerified) _buildVerifiedBadge(),
                              ],
                            ),
                            SizedBox(height: 8),
                            //! Confirm account
                            if (!isVerified)
                              GestureDetector(
                                onTap:
                                    userMeState is UserMeLoaded &&
                                        !userMeState.entity.isResident
                                    ? () {
                                        AppRoute.go(ConfirmAccForeignUser());
                                      }
                                    : () async {
                                        final success =
                                            await showModalBottomSheet<bool>(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  const MyIdFormBottomSheet(),
                                            );

                                        logger.f('MyID form result: $success');

                                        if (context.mounted) {
                                          context.read<FaceRecBloc>().add(
                                            ResetFaceRecEvent(),
                                          );
                                        }

                                        if (success == true) {
                                          if (context.mounted) {
                                            successFlushBar(
                                              context,
                                              'Siz muvaffaqiyatli shaxsingizni tasdiqladingiz!',
                                            );
                                            context.read<UserMeBloc>().add(
                                              UserMeEvent(),
                                            );
                                          }
                                        }
                                        return;
                                      },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.orange50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        IconlyBold.danger,
                                        color: AppColors.orange500,
                                      ),
                                      AutoSizeText(
                                        AppLocalizations.of(
                                          context,
                                        )!.accountConfirm,
                                        style: AppTextStyles.source.medium(
                                          fontSize: 13,
                                          color: AppColors.orange500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 15),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Tooltip(
      key: _verifiedToolTipKey,
      message: 'Siz shaxsingizni tasdiqlagansiz',
      preferBelow: true,
      triggerMode: TooltipTriggerMode.manual,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.source.medium(
        fontSize: 12,
        color: AppColors.white,
      ),
      child: GestureDetector(
        onTap: () {
          _verifiedToolTipKey.currentState?.ensureTooltipVisible();
        },
        child: SvgPicture.asset(AppVectors.verified, width: 23, height: 23),
      ),
    );
  }
}
