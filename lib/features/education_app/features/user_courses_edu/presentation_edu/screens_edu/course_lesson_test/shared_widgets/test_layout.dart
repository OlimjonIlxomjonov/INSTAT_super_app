import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_header_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_option_list_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_question_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TestLayout extends StatelessWidget {
  final double progress;
  final String questionTitle;
  final String questionText;
  final Widget optionList;
  final bool isLoading;
  final String buttonText;
  final VoidCallback? onButtonTap;
  final Widget? banner;

  const TestLayout({
    super.key,
    required this.progress,
    required this.questionTitle,
    required this.questionText,
    required this.optionList,
    this.isLoading = false,
    this.buttonText = "Tasdiqlash",
    this.onButtonTap,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TestHeaderWg(progress: progress),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestQuestionWg(
                      questionTitle: questionTitle,
                      questionText: questionText,
                    ),
                    SizedBox(height: appH(20)),
                    optionList,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (banner != null) banner!,
          CustomBottomNavContainerWg(
            buttonText: buttonText,
            onTap: onButtonTap ?? () {},
          ),
        ],
      ),
    );
  }
}

/// Helper to build the result banner
Widget buildTestResultBanner({required bool isCorrect}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: isCorrect ? AppColors.green : AppColors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          isCorrect ? "To'g'ri javob" : "Noto'g'ri javob",
          style: AppTextStyles.source.medium(fontSize: 16, color: Colors.white),
        ),
      ],
    ),
  );
}
