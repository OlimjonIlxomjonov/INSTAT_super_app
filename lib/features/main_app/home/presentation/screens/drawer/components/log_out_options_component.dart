import 'package:flutter/material.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class LogOutOptionsComponent extends StatelessWidget {
  const LogOutOptionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          localization.leaveAccount,
          style: AppTextStyles.source.medium(
            fontSize: 24,
            color: AppColors.redFailedTaskCard,
          ),
        ),
        Text(
          localization.logoutConfirmMessage,
          style: CustomTextStyles.h4,
        ),
        SizedBox(height: 25),
        SafeArea(
          child: Container(
            padding: .symmetric(vertical: appH(20)),
            decoration: BoxDecoration(
              borderRadius: .only(
                topRight: .circular(24),
                topLeft: .circular(24),
              ),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -1),
                  color: AppColors.greyScale.grey200,
                  spreadRadius: 0,
                  blurRadius: 20,
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: .stretch,
                children: [
                  SizedBox(width: appW(12)),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.greyScale.grey400),
                          borderRadius: .circular(12),
                        ),
                      ),
                      onPressed: () {
                        AppRoute.close();
                      },
                      label: Text(
                        localization.cancel,
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: appW(12)),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await TokenStorageServiceImpl().deleteAccessToken();
                        // Clear per-account cached lesson access so the
                        // next logged-in user doesn't see stale data.
                        sl<CourseLessonItemsBloc>().add(
                          const ResetCourseLessonItemsEvent(),
                        );
                        AppRoute.open(LogInOptionsPage());
                      },
                      label: Text(
                        localization.confirm,
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: appW(12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
