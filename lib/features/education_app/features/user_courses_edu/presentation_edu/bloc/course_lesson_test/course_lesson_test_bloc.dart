import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_test_options_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_tests_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/submit_lesson_test_answer_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_state.dart';

class CourseLessonTestBloc
    extends Bloc<CourseLessonTestEvent, CourseLessonTestState> {
  final GetLessonTestsUseCase getLessonTestsUseCase;
  final GetLessonTestOptionsUseCase getLessonTestOptionsUseCase;
  final SubmitLessonTestAnswerUseCase submitLessonTestAnswerUseCase;

  int _correctAnswers = 0;
  List<LessonTestEntity> _tests = [];
  int _currentCourseId = 0;
  int _currentBlockId = 0;
  int _currentLessonId = 0;

  CourseLessonTestBloc({
    required this.getLessonTestsUseCase,
    required this.getLessonTestOptionsUseCase,
    required this.submitLessonTestAnswerUseCase,
  }) : super(CourseLessonTestLoading()) {
    on<LoadCourseLessonTestsEvent>(_onLoadTests);
    on<SelectLessonTestOptionEvent>(_onSelectOption);
    on<SubmitLessonTestAnswerEvent>(_onSubmitAnswer);
    on<NextLessonTestQuestionEvent>(_onNextQuestion);
  }

  Future<void> _onLoadTests(
    LoadCourseLessonTestsEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    emit(CourseLessonTestLoading());
    try {
      _currentCourseId = event.params.courseId;
      _currentBlockId = event.params.blockId;
      _currentLessonId = event.params.lessonId;
      _correctAnswers = 0;

      final tests = await getLessonTestsUseCase(event.params);
      _tests = tests;

      if (tests.isEmpty) {
        emit(const CourseLessonTestFinished(
          totalQuestions: 0,
          correctAnswers: 0,
        ));
        return;
      }

      await _loadOptionsForTest(0, emit);
    } catch (e) {
      emit(CourseLessonTestError(message: e.toString()));
    }
  }

  Future<void> _loadOptionsForTest(
    int testIndex,
    Emitter<CourseLessonTestState> emit,
  ) async {
    try {
      final currentTestId = _tests[testIndex].id;
      final optionsParams = CourseLessonTestOptionsParams(
        courseId: _currentCourseId,
        blockId: _currentBlockId,
        lessonId: _currentLessonId,
        testId: currentTestId,
      );

      final options = await getLessonTestOptionsUseCase(optionsParams);

      emit(CourseLessonTestLoaded(
        tests: _tests,
        currentTestIndex: testIndex,
        currentOptions: options,
        selectedOptionId: null,
      ));
    } catch (e) {
      emit(CourseLessonTestError(message: e.toString()));
    }
  }

  void _onSelectOption(
    SelectLessonTestOptionEvent event,
    Emitter<CourseLessonTestState> emit,
  ) {
    if (state is CourseLessonTestLoaded) {
      final currentState = state as CourseLessonTestLoaded;
      emit(currentState.copyWith(selectedOptionId: event.optionId));
    }
  }

  Future<void> _onSubmitAnswer(
    SubmitLessonTestAnswerEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    if (state is CourseLessonTestLoaded) {
      final currentState = state as CourseLessonTestLoaded;
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

        final response = await submitLessonTestAnswerUseCase(params);

        if (response.isCorrect) {
          _correctAnswers++;
        }

        emit(CourseLessonTestAnswerResult(
          tests: _tests,
          currentTestIndex: currentState.currentTestIndex,
          currentOptions: currentState.currentOptions,
          selectedOptionId: currentState.selectedOptionId!,
          answerResponse: response,
        ));
      } catch (e) {
        emit(CourseLessonTestError(message: e.toString()));
      }
    }
  }

  Future<void> _onNextQuestion(
    NextLessonTestQuestionEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    if (state is CourseLessonTestAnswerResult) {
      final currentState = state as CourseLessonTestAnswerResult;

      if (currentState.currentTestIndex + 1 >= _tests.length) {
        emit(CourseLessonTestFinished(
          totalQuestions: _tests.length,
          correctAnswers: _correctAnswers,
        ));
      } else {
        emit(CourseLessonTestLoading());
        await _loadOptionsForTest(currentState.currentTestIndex + 1, emit);
      }
    }
  }
}
