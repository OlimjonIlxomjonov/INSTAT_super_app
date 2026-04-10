import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/finish_lesson_test_dialog/finish_lesson_test_dialog_screen.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_layout.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_option_list_wg.dart';

class RegularTestCoursePage extends StatefulWidget {
  final int courseId;
  final int blockId;
  final int lessonId;

  const RegularTestCoursePage({
    super.key,
    required this.courseId,
    required this.blockId,
    required this.lessonId,
  });

  @override
  State<RegularTestCoursePage> createState() => _RegularTestCoursePageState();
}

class _RegularTestCoursePageState extends State<RegularTestCoursePage> {
  late ConfettiController _confettiController;
  late CourseLessonTestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _bloc = sl<CourseLessonTestBloc>();
    _bloc.add(
      LoadCourseLessonTestsEvent(
        params: CourseLessonTestParams(
          courseId: widget.courseId,
          blockId: widget.blockId,
          lessonId: widget.lessonId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _showFinishDialog(CourseLessonTestFinished state) {
    _confettiController.play();

    final percentage = state.totalQuestions > 0
        ? ((state.correctAnswers / state.totalQuestions) * 100).toInt()
        : 0;

    finishLessonTestDialogScreen(
      context,
      header: Stack(
        children: [
          SvgPicture.asset(AppVectors.trophyBackground),
          SizedBox(
            width: 230,
            height: 174,
            child: Lottie.asset(
              AppAnimations.trophyAnimation,
              repeat: false,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      title: 'Ajoyib natija',
      subTitle:
          "Keyingi safar ko'proq o'rganing va barcha to'g'ri javoblarni oling.",
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey50,
          border: Border.all(color: AppColors.greyScale.grey200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildColumn(
              title: '$percentage%',
              subTitle: '${state.totalQuestions - state.correctAnswers} ta',
            ),
            _buildColumn(
              title: '${state.correctAnswers} ⭐',
              subTitle: '${state.correctAnswers} ta',
              titleDesc: 'To’g’ri javoblar',
              subTitleDesc: 'Berilgan ball',
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              AppRoute.close();
              AppRoute.close(); // Close the test page context as well
            },
            child: const Text('Davom etish'),
          ),
        ),
      ],
      confettiController: _confettiController,
    );
  }

  Column _buildColumn({
    required String title,
    required String subTitle,
    String titleDesc = 'Noto’g’ri javob',
    String subTitleDesc = 'Tugatish foizi',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTextStyles.source.medium(fontSize: 20)),
        Text(
          subTitleDesc,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey600,
          ),
        ),
        SizedBox(height: appH(12)),
        Text(subTitle, style: AppTextStyles.source.medium(fontSize: 20)),
        Text(
          titleDesc,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<CourseLessonTestBloc, CourseLessonTestState>(
        listener: (context, state) {
          if (state is CourseLessonTestFinished) {
            _showFinishDialog(state);
          } else if (state is CourseLessonTestError) {
            errorFlushBar(context, state.message);
          }
        },
        builder: (context, state) {
          double progress = 0.0;
          String questionTitle = "";
          String questionText = "";
          bool isLoading = state is CourseLessonTestLoading;
          Widget optionList = const SizedBox.shrink();
          String buttonText = "Tasdiqlash";
          VoidCallback? onButtonTap;
          Widget? banner;

          if (state is CourseLessonTestLoaded) {
            progress = state.tests.isNotEmpty
                ? ((state.currentTestIndex) / state.tests.length)
                : 0.0;
            final currentTest = state.tests[state.currentTestIndex];
            questionTitle = '${state.currentTestIndex + 1}-Savol';
            questionText = currentTest.question;

            optionList = TestOptionListWg(
              options: state.currentOptions,
              selectedOptionId: state.selectedOptionId,
              onSelectOption: (id) =>
                  _bloc.add(SelectLessonTestOptionEvent(optionId: id)),
            );

            if (state.selectedOptionId != null && !state.isSubmitting) {
              onButtonTap = () => context.read<CourseLessonTestBloc>().add(
                SubmitLessonTestAnswerEvent(),
              );
            }
          } else if (state is CourseLessonTestAnswerResult) {
            progress = state.tests.isNotEmpty
                ? ((state.currentTestIndex + 1) / state.tests.length)
                : 0.0;
            final currentTest = state.tests[state.currentTestIndex];
            questionTitle = '${state.currentTestIndex + 1}-Savol';
            questionText = currentTest.question;

            optionList = TestOptionListWg(
              options: state.currentOptions,
              selectedOptionId: state.selectedOptionId,
              isAnswered: true,
              isCorrect: state.answerResponse.isCorrect,
            );

            buttonText = "Keyingi savol";
            onButtonTap = () => context.read<CourseLessonTestBloc>().add(
              NextLessonTestQuestionEvent(),
            );

            banner = buildTestResultBanner(
              isCorrect: state.answerResponse.isCorrect,
            );
          } else if (isLoading) {
            questionTitle = 'Yuklanmoqda...';
            questionText = '';
          }

          return TestLayout(
            progress: progress,
            questionTitle: questionTitle,
            questionText: questionText,
            optionList: optionList,
            isLoading: isLoading,
            buttonText: buttonText,
            onButtonTap: onButtonTap,
            banner: banner,
          );
        },
      ),
    );
  }
}
