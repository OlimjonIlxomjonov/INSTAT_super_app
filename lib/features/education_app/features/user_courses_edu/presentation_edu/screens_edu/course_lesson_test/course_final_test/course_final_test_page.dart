import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_options_placeholder_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_question_navigator_wg.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/lesson_test_error_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/camera_service.dart';
import 'package:my_template/core/utils/general_widgets/camera_access_denied/camera_access_denied_overlay_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/course_review_dialog/course_review_dialog.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets/camera_preview_widget.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/finish_lesson_test_dialog/finish_lesson_test_dialog_screen.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_layout.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_option_list_wg.dart';

class CourseFinalTestPage extends StatefulWidget {
  final int courseId;
  final bool isFaceIdEnabled;

  const CourseFinalTestPage({
    super.key,
    required this.courseId,
    required this.isFaceIdEnabled,
  });

  @override
  State<CourseFinalTestPage> createState() => _CourseFinalTestPageState();
}

class _CourseFinalTestPageState extends State<CourseFinalTestPage>
    with WidgetsBindingObserver {
  late ConfettiController _confettiController;
  late CameraService _cameraService;

  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _cameraService = CameraService();
    if (widget.isFaceIdEnabled) _cameraService.init();

    context.read<CourseFinalTestBloc>().add(
      LoadCourseFinalTestsEvent(
        params: CourseLessonTestParams(
          courseId: widget.courseId,
          blockId: 0,
          lessonId: 0,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (widget.isFaceIdEnabled &&
        state == AppLifecycleState.resumed &&
        _cameraService.isPermissionDenied) {
      _cameraService.init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _confettiController.dispose();
    _cameraService.dispose();
    super.dispose();
  }

  void _showFinishDialog(BuildContext context, CourseFinalTestFinished state) {
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
      subTitle: localization.finalTestFinishSubtitle,
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey50,
          border: Border.all(color: AppColors.greyScale.grey200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(
              title: Text(
                "$percentage%",
                style: AppTextStyles.source.medium(fontSize: 20),
              ),
              subTitle: '${state.totalQuestions - state.correctAnswers} ta',
              titleDesc: localization.wrongAnswer,
              subTitleDesc: localization.completionPercentageLabel,
              textColor: AppColors.redFailedTaskCard,
            ),
            _buildColumn(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.correctAnswers.toString(),
                    style: AppTextStyles.source.medium(fontSize: 20),
                  ),
                  const SizedBox(width: 4),
                  Icon(IconlyBold.star, color: AppColors.yellow500),
                ],
              ),
              subTitle: '${state.correctAnswers} ta',
              titleDesc: localization.correctAnswersLabel,
              subTitleDesc: localization.pointsGivenLabel,
              textColor: AppColors.greenDoneTaskCard,
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _openReviewDialog(context),
            child: Text(localization.continueButton),
          ),
        ),
      ],
      confettiController: _confettiController,
    );
  }

  Future<void> _openReviewDialog(BuildContext context) async {
    //! Natija oynasi
    AppRoute.close();

    try {
      await showCourseReviewDialog(context, courseId: widget.courseId);
    } finally {
      //! Test sahifasi
      AppRoute.close();
    }
  }

  Widget _buildColumn({
    required Widget title,
    required String subTitle,
    required String titleDesc,
    required String subTitleDesc,
    Color? textColor,
  }) {
    final descStyle = AppTextStyles.source.regular(
      fontSize: 12,
      color: AppColors.greyScale.grey600,
    );

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title,
          Text(
            subTitleDesc,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: descStyle,
          ),
          SizedBox(height: appH(12)),
          Text(
            subTitle,
            style: AppTextStyles.source.medium(fontSize: 20, color: textColor),
          ),
          Text(
            titleDesc,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: descStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseFinalTestBloc, CourseFinalTestState>(
      listener: (context, state) {
        if (state is CourseFinalTestLoaded && state.errorKind != null) {
          errorFlushBar(
            context,
            lessonTestErrorText(
              AppLocalizations.of(context)!,
              state.errorKind!,
              state.errorMessage,
            ),
            details: state.errorDetails,
          );
        } else if (state is CourseFinalTestFinished &&
            state.totalQuestions == 0) {
          errorFlushBar(
            context,
            AppLocalizations.of(context)!.finalTestNotAddedHint,
          );
          AppRoute.close();
        } else if (state is CourseFinalTestFinished) {
          _showFinishDialog(context, state);
        } else if (state is CourseFinalTestError) {
          errorFlushBar(
            context,
            lessonTestErrorText(
              AppLocalizations.of(context)!,
              state.kind,
              state.message,
            ),
          );
        }
      },
      builder: (context, state) {
        final localization = AppLocalizations.of(context)!;
        double progress = 0.0;
        String questionTitle = "";
        String questionText = "";
        bool isLoading = state is CourseFinalTestLoading;
        Widget optionList = const SizedBox.shrink();
        String buttonText = localization.confirm;
        VoidCallback? onButtonTap;
        Widget? banner;
        Widget? navigator;

        if (state is CourseFinalTestLoaded) {
          progress = state.progress;
          final currentTest = state.tests[state.currentTestIndex];
          questionTitle = localization.questionNumberTemplate(
            state.currentTestIndex + 1,
          );
          questionText = currentTest.displayQuestion(
            Localizations.localeOf(context).languageCode,
          );

          final bloc = context.read<CourseFinalTestBloc>();
          final isBusy =
              _isCapturing || state.isSubmitting || state.isOptionsLoading;
          navigator = TestQuestionNavigatorWg(
            count: state.tests.length,
            currentIndex: state.currentTestIndex,
            statusOf: (index) {
              final answer = state.answerAt(index);
              if (answer == null) return TestQuestionStatus.unanswered;
              return answer.isCorrect
                  ? TestQuestionStatus.correct
                  : TestQuestionStatus.wrong;
            },
            onSelect: isBusy
                ? null
                : (index) => bloc.add(GoToCourseFinalTestQuestionEvent(index)),
          );

          final answer = state.currentAnswer;
          if (state.isOptionsLoading) {
            isLoading = true;
            optionList = const TestOptionsPlaceholderWg();
            onButtonTap = null;
          } else if (answer != null) {
            optionList = TestOptionListWg(
              key: ValueKey(currentTest.id),
              options: state.currentOptions,
              selectedOptionId: answer.optionId,
              isAnswered: true,
              isCorrect: answer.isCorrect,
            );
            banner = buildTestResultBanner(
              isCorrect: answer.isCorrect,
              localization: localization,
            );
            buttonText = state.isAllAnswered
                ? localization.finishTestButton
                : localization.nextQuestionButton;
            onButtonTap = () => bloc.add(NextCourseFinalTestQuestionEvent());
          } else {
            optionList = TestOptionListWg(
              key: ValueKey(currentTest.id),
              options: state.currentOptions,
              selectedOptionId: state.selectedOptionId,
              onSelectOption: (id) =>
                  bloc.add(SelectCourseFinalTestOptionEvent(optionId: id)),
            );

            if (state.selectedOptionId != null && !isBusy) {
              onButtonTap = () async {
                if (!widget.isFaceIdEnabled) {
                  bloc.add(const SubmitCourseFinalTestAnswerEvent());
                  return;
                }

                setState(() => _isCapturing = true);
                try {
                  final image = await _cameraService.captureBase64();
                  if (image == null && mounted) {
                    errorFlushBar(
                      this.context,
                      localization.cameraCaptureFailedMessage,
                    );
                    return;
                  }
                  if (mounted) {
                    bloc.add(
                      SubmitCourseFinalTestAnswerEvent(proctorImage: image),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isCapturing = false);
                }
              };
            }
          }
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
                  navigator: navigator,
                  isSubmitting:
                      _isCapturing ||
                      (state is CourseFinalTestLoaded && state.isSubmitting),
                ),
                if (widget.isFaceIdEnabled &&
                    _cameraService.isReady &&
                    _cameraService.controller != null)
                  CameraPreviewWidget(controller: _cameraService.controller!),
                if (widget.isFaceIdEnabled && _cameraService.isPermissionDenied)
                  const CameraAccessDeniedOverlayWg(),
              ],
            );
          },
        );
      },
    );
  }
}
