import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_options_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/submit_final_course_answer_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_state.dart';

class CourseFinalTestBloc
    extends Bloc<CourseFinalTestEvent, CourseFinalTestState> {
  final GetCourseFinalTestUseCase getCourseFinalTestUseCase;
  final GetCourseFinalTestOptionsUseCase getCourseFinalTestOptionsUseCase;
  final SubmitFinalCourseAnswerUseCase submitFinalCourseAnswerUseCase;

  int _correctAnswers = 0;
  List<LessonTestEntity> _tests = [];
  int _currentCourseId = 0;
  int _currentBlockId = 0;
  int _currentLessonId = 0;

  CourseFinalTestBloc({
    required this.getCourseFinalTestUseCase,
    required this.getCourseFinalTestOptionsUseCase,
    required this.submitFinalCourseAnswerUseCase,
  }) : super(CourseFinalTestLoading()) {
    on<LoadCourseFinalTestsEvent>(_onLoadTests);
    on<SelectCourseFinalTestOptionEvent>(_onSelectOption);
    on<SubmitCourseFinalTestAnswerEvent>(_onSubmitAnswer);
    on<NextCourseFinalTestQuestionEvent>(_onNextQuestion);
  }

  Future<void> _onLoadTests(
    LoadCourseFinalTestsEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    emit(CourseFinalTestLoading());
    try {
      _currentCourseId = event.params.courseId;
      _currentBlockId = event.params.blockId;
      _currentLessonId = event.params.lessonId;
      _correctAnswers = 0;

      final tests = await getCourseFinalTestUseCase(params: event.params);
      _tests = tests;

      if (tests.isEmpty) {
        emit(const CourseFinalTestFinished(
          totalQuestions: 0,
          correctAnswers: 0,
        ));
        return;
      }

      await _loadOptionsForTest(0, emit);
    } catch (e) {
      emit(CourseFinalTestError(message: e.toString()));
    }
  }

  Future<void> _loadOptionsForTest(
    int testIndex,
    Emitter<CourseFinalTestState> emit,
  ) async {
    try {
      final currentTestId = _tests[testIndex].id;
      final optionsParams = CourseLessonTestOptionsParams(
        courseId: _currentCourseId,
        blockId: _currentBlockId,
        lessonId: _currentLessonId,
        testId: currentTestId,
      );

      final options =
          await getCourseFinalTestOptionsUseCase(params: optionsParams);

      emit(CourseFinalTestLoaded(
        tests: _tests,
        currentTestIndex: testIndex,
        currentOptions: options,
        selectedOptionId: null,
      ));
    } catch (e) {
      emit(CourseFinalTestError(message: e.toString()));
    }
  }

  void _onSelectOption(
    SelectCourseFinalTestOptionEvent event,
    Emitter<CourseFinalTestState> emit,
  ) {
    if (state is CourseFinalTestLoaded) {
      final currentState = state as CourseFinalTestLoaded;
      emit(currentState.copyWith(selectedOptionId: event.optionId));
    }
  }

  Future<void> _onSubmitAnswer(
    SubmitCourseFinalTestAnswerEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    if (state is CourseFinalTestLoaded) {
      final currentState = state as CourseFinalTestLoaded;
      if (currentState.selectedOptionId == null) return;

      emit(currentState.copyWith(isSubmitting: true));

      try {
        final currentTestId = _tests[currentState.currentTestIndex].id;
        final params = SubmitLessonTestAnswerParams(
          courseId: _currentCourseId,
          blockId: _currentBlockId,
          lessonId: _currentLessonId,
          testId: currentTestId,
          optionId: currentState.selectedOptionId!,
        );

        final response = await submitFinalCourseAnswerUseCase(params: params);

        if (response.isCorrect) {
          _correctAnswers++;
        }

        emit(CourseFinalTestAnswerResult(
          tests: _tests,
          currentTestIndex: currentState.currentTestIndex,
          currentOptions: currentState.currentOptions,
          selectedOptionId: currentState.selectedOptionId!,
          answerResponse: response,
        ));
      } catch (e) {
        emit(CourseFinalTestError(message: e.toString()));
      }
    }
  }

  Future<void> _onNextQuestion(
    NextCourseFinalTestQuestionEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    if (state is CourseFinalTestAnswerResult) {
      final currentState = state as CourseFinalTestAnswerResult;

      if (currentState.currentTestIndex + 1 >= _tests.length) {
        emit(CourseFinalTestFinished(
          totalQuestions: _tests.length,
          correctAnswers: _correctAnswers,
        ));
      } else {
        emit(CourseFinalTestLoading());
        await _loadOptionsForTest(currentState.currentTestIndex + 1, emit);
      }
    }
  }
}
