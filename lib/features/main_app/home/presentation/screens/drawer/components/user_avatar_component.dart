import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserAvatarComponent extends StatefulWidget {
  const UserAvatarComponent({super.key});

  @override
  State<UserAvatarComponent> createState() => _UserAvatarComponentState();
}

class _UserAvatarComponentState extends State<UserAvatarComponent> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    // Show bottom sheet with options
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.close, color: AppColors.greyScale.grey600),
              title: Text('Cancel'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null && mounted) {
      context.read<AvatarBloc>().add(
        AvatarEvent(params: AvatarParams(imagePath: pickedFile.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
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
                          : "Firstname Lastname";
                      final String? thumbnail =
                          state is UserMeLoaded && state.entity.avatar != null
                          ? state.entity.avatar
                          : null;
                      return Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Stack(
                              children: [
                                /// user avatar
                                CircleAvatar(
                                  radius: 75,
                                  foregroundImage: thumbnail != null
                                      ? NetworkImage(thumbnail)
                                      : null,
                                  child: thumbnail == null
                                      ? Icon(
                                          Icons.person,
                                          color: AppColors.greyScale.grey600,
                                          size: 90,
                                        )
                                      : null,
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
                            AutoSizeText(
                              displayName,
                              style: AppTextStyles.source.medium(
                                fontSize: isMobile ? 22 : 32,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.orange50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 5,
                                children: [
                                  Icon(
                                    IconlyLight.danger,
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
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
