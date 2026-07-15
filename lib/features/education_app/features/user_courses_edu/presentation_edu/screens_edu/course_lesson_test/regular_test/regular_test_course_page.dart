import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/camera_service.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/finish_lesson_test_dialog/finish_lesson_test_dialog_screen.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_layout.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_option_list_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets/camera_preview_widget.dart';

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
  late CameraService _cameraService;

  @override
  void initState() {
    super.initState();
    logger.f('Regular test check out');
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _cameraService = CameraService();
    _cameraService.init();
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
    _cameraService.dispose();
    _bloc.close();
    super.dispose();
  }

  void _showFinishDialog(
    BuildContext context,
    CourseLessonTestFinished state,
  ) {
    final localization = AppLocalizations.of(context)!;
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
      title: localization.greatResultTitle,
      subTitle: localization.regularTestFinishSubtitle,
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
              titleDesc: localization.wrongAnswer,
              subTitleDesc: localization.completionPercentageLabel,
            ),
            _buildColumn(
              title: '${state.correctAnswers} ⭐',
              subTitle: '${state.correctAnswers} ta',
              titleDesc: localization.correctAnswersLabel,
              subTitleDesc: localization.pointsGivenLabel,
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
            child: Text(localization.continueButton),
          ),
        ),
      ],
      confettiController: _confettiController,
    );
  }

  Column _buildColumn({
    required String title,
    required String subTitle,
    required String titleDesc,
    required String subTitleDesc,
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
            _showFinishDialog(context, state);
          } else if (state is CourseLessonTestError) {
            errorFlushBar(context, state.message);
          }
        },
        builder: (context, state) {
          final localization = AppLocalizations.of(context)!;
          double progress = 0.0;
          String questionTitle = "";
          String questionText = "";
          bool isLoading = state is CourseLessonTestLoading;
          Widget optionList = const SizedBox.shrink();
          String buttonText = localization.confirm;
          VoidCallback? onButtonTap;
          Widget? banner;

          if (state is CourseLessonTestLoaded) {
            progress = state.tests.isNotEmpty
                ? ((state.currentTestIndex) / state.tests.length)
                : 0.0;
            final currentTest = state.tests[state.currentTestIndex];
            questionTitle = localization.questionNumberTemplate(
              state.currentTestIndex + 1,
            );
            questionText = currentTest.question;

            optionList = TestOptionListWg(
              options: state.currentOptions,
              selectedOptionId: state.selectedOptionId,
              onSelectOption: (id) =>
                  _bloc.add(SelectLessonTestOptionEvent(optionId: id)),
            );

            if (state.selectedOptionId != null && !state.isSubmitting) {
              onButtonTap = () async {
                final image = await _cameraService.captureBase64();
                if (image == null && mounted) {
                  errorFlushBar(context, localization.cameraCaptureFailedMessage);
                  return;
                }
                if (mounted) {
                  context.read<CourseLessonTestBloc>().add(
                    SubmitLessonTestAnswerEvent(proctorImage: image),
                  );
                }
              };
            }
          } else if (state is CourseLessonTestAnswerResult) {
            progress = state.tests.isNotEmpty
                ? ((state.currentTestIndex + 1) / state.tests.length)
                : 0.0;
            final currentTest = state.tests[state.currentTestIndex];
            questionTitle = localization.questionNumberTemplate(
              state.currentTestIndex + 1,
            );
            questionText = currentTest.question;

            optionList = TestOptionListWg(
              options: state.currentOptions,
              selectedOptionId: state.selectedOptionId,
              isAnswered: true,
              isCorrect: state.answerResponse.isCorrect,
            );

            buttonText = localization.nextQuestionButton;
            onButtonTap = () => context.read<CourseLessonTestBloc>().add(
              NextLessonTestQuestionEvent(),
            );

            banner = buildTestResultBanner(
              isCorrect: state.answerResponse.isCorrect,
              localization: localization,
            );
          } else if (isLoading) {
            questionTitle = localization.loadingEllipsis;
            questionText = '';
          }

          return ListenableBuilder(
            listenable: _cameraService,
            builder: (context, _) {
              return Stack(
                children: [
                  TestLayout(
                    progress: progress,
                    questionTitle: questionTitle,
                    questionText: questionText,
                    optionList: optionList,
                    isLoading: isLoading,
                    buttonText: buttonText,
                    onButtonTap: onButtonTap,
                    banner: banner,
                  ),
                  if (_cameraService.isReady && _cameraService.controller != null)
                    CameraPreviewWidget(
                      controller: _cameraService.controller!,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
