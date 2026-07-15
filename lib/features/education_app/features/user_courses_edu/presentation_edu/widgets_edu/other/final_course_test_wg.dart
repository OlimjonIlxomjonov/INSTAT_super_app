import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/course_final_test/course_final_test_page.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';

class FinalCourseTestWg extends StatelessWidget {
  final int courseId;

  const FinalCourseTestWg({super.key, required this.courseId});

  void _checkFinalTestAccess(BuildContext context) {
    if (context.read<CheckFinalTestAccessBloc>().state
        is CheckFinalTestAccessLoading) {
      return; // prevent rapid double tap from firing twice
    }

    final userState = context.read<UserMeBloc>().state;
    final isVerified = userState is UserMeLoaded && userState.entity.isVerified;

    if (!isVerified) {
      errorFlushBar(
        context,
        AppLocalizations.of(context)!.verificationRequiredMessage,
      );
      return;
    }

    logger.f(courseId);
    context.read<CheckFinalTestAccessBloc>().add(
      CheckFinalTestAccessEvent(
        params: CheckFinalTestAccessParams(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckFinalTestAccessBloc>(
      create: (_) => sl<CheckFinalTestAccessBloc>(),
      child: BlocConsumer<CheckFinalTestAccessBloc, CheckFinalTestAccessState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => _checkFinalTestAccess(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyScale.grey200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.overallTestQuestions,
                    style: CustomTextStyles.h3,
                  ),

                  Icon(
                    IconlyLight.arrow_right_2,
                    color: AppColors.greyScale.grey400,
                  ),
                ],
              ),
            ),
          );
        },
        listenWhen: (previous, current) =>
            current is CheckFinalTestAccessLoaded &&
            previous is! CheckFinalTestAccessLoaded,
        listener: (context, state) {
          if (state is CheckFinalTestAccessLoaded && state.entity.ok == true) {
            Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CourseFinalTestPage(courseId: courseId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeOutCubic;

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                transitionDuration: const Duration(milliseconds: 350),
              ),
            );
          } else if (state is CheckFinalTestAccessLoaded &&
              state.entity.ok == false) {
            errorFlushBar(
              context,
              AppLocalizations.of(context)!.noAccessToFinalTestYet,
            );
          }
        },
      ),
    );
  }
}
