import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserAvatarComponent extends StatefulWidget {
  const UserAvatarComponent({super.key});

  @override
  State<UserAvatarComponent> createState() => _UserAvatarComponentState();
}

class _UserAvatarComponentState extends State<UserAvatarComponent> {
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
                SizedBox(height: 15),
                CircleAvatar(
                  radius: 75,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyScale.grey600,
                    size: 90,
                  ),
                ),

                BlocBuilder<UserMeBloc, UserMeState>(
                  builder: (context, state) {
                    final bool isLoading = state is UserMeLoading;

                    final String displayName = state is UserMeLoaded
                        ? "${state.entity.firstName.capitalize()} ${state.entity.lastName.capitalize()}"
                        : "Firstname Lastname";

                    return Skeletonizer(
                      enabled: isLoading,
                      child: Column(
                        children: [
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
                                  AppLocalizations.of(context)!.accountConfirm,
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
