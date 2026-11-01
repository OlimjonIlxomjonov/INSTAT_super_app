import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/test_answer/test_answer_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_options_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/submit_final_course_answer_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/test_answers/test_answers_use_cases.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_state.dart';

class CourseFinalTestBloc
    extends Bloc<CourseFinalTestEvent, CourseFinalTestState> {
  final GetCourseFinalTestUseCase getCourseFinalTestUseCase;
  final GetCourseFinalTestOptionsUseCase getCourseFinalTestOptionsUseCase;
  final SubmitFinalCourseAnswerUseCase submitFinalCourseAnswerUseCase;
  final CourseTestAnswersUseCase courseTestAnswersUseCase;

  List<LessonTestEntity> _tests = [];
  Map<int, TestAnswerEntity> _answers = {};
  final Map<int, List<LessonTestOptionEntity>> _optionsCache = {};
  int _courseId = 0;
  int _blockId = 0;
  int _lessonId = 0;
  int _navigationId = 0;

  CourseFinalTestBloc({
    required this.getCourseFinalTestUseCase,
    required this.getCourseFinalTestOptionsUseCase,
    required this.submitFinalCourseAnswerUseCase,
    required this.courseTestAnswersUseCase,
  }) : super(CourseFinalTestLoading()) {
    on<LoadCourseFinalTestsEvent>(_onLoadTests);
    on<SelectCourseFinalTestOptionEvent>(_onSelectOption);
    on<SubmitCourseFinalTestAnswerEvent>(_onSubmitAnswer);
    on<NextCourseFinalTestQuestionEvent>(_onNextQuestion);
    on<GoToCourseFinalTestQuestionEvent>(_onGoToQuestion);
  }

  Future<void> _onLoadTests(
    LoadCourseFinalTestsEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    emit(CourseFinalTestLoading());
    _courseId = event.params.courseId;
    _blockId = event.params.blockId;
    _lessonId = event.params.lessonId;
    _answers = {};
    _optionsCache.clear();

    try {
      final testsFuture = getCourseFinalTestUseCase(params: event.params);
      final answersFuture = _fetchAnswers();
      _tests = await testsFuture;
      _answers = await answersFuture;

      if (_tests.isEmpty) {
        emit(
          const CourseFinalTestFinished(totalQuestions: 0, correctAnswers: 0),
        );
        return;
      }

      final firstUnanswered = _tests.indexWhere(
        (test) => !_answers.containsKey(test.id),
      );
      await _showQuestion(firstUnanswered < 0 ? 0 : firstUnanswered, emit);
    } catch (e) {
      emit(CourseFinalTestError(message: e.toString()));
    }
  }

  Future<Map<int, TestAnswerEntity>> _fetchAnswers() async {
    try {
      final answers = await courseTestAnswersUseCase(_courseId);
      return {for (final answer in answers) answer.testId: answer};
    } catch (_) {
      return _answers;
    }
  }

  Future<void> _showQuestion(
    int index,
    Emitter<CourseFinalTestState> emit,
  ) async {
    final navigation = ++_navigationId;
    final testId = _tests[index].id;
    final cached = _optionsCache[testId];

    if (cached != null) {
      emit(
        CourseFinalTestLoaded(
          tests: _tests,
          currentTestIndex: index,
          currentOptions: cached,
          answers: _answers,
        ),
      );
      return;
    }

    emit(
      CourseFinalTestLoaded(
        tests: _tests,
        currentTestIndex: index,
        currentOptions: const [],
        answers: _answers,
        isOptionsLoading: true,
      ),
    );

    try {
      final options = await getCourseFinalTestOptionsUseCase(
        params: CourseLessonTestOptionsParams(
          courseId: _courseId,
          blockId: _blockId,
          lessonId: _lessonId,
          testId: testId,
        ),
      );
      _optionsCache[testId] = options;
      if (navigation != _navigationId) return;
      emit(
        CourseFinalTestLoaded(
          tests: _tests,
          currentTestIndex: index,
          currentOptions: options,
          answers: _answers,
        ),
      );
    } catch (e) {
      if (navigation != _navigationId) return;
      emit(
        CourseFinalTestLoaded(
          tests: _tests,
          currentTestIndex: index,
          currentOptions: const [],
          answers: _answers,
          errorKind: LessonTestErrorKind.server,
          errorMessage: apiErrorMessage(e) ?? '',
          errorDetails: apiErrorDetails(e),
        ),
      );
    }
  }

  void _onSelectOption(
    SelectCourseFinalTestOptionEvent event,
    Emitter<CourseFinalTestState> emit,
  ) {
    final current = state;
    if (current is! CourseFinalTestLoaded ||
        current.isSubmitting ||
        current.currentAnswer != null) {
      return;
    }
    emit(current.copyWith(selectedOptionId: event.optionId, clearError: true));
  }

  Future<void> _onGoToQuestion(
    GoToCourseFinalTestQuestionEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseFinalTestLoaded || current.isSubmitting) return;
    if (event.index < 0 || event.index >= _tests.length) return;
    if (event.index == current.currentTestIndex &&
        current.currentOptions.isNotEmpty) {
      return;
    }
    await _showQuestion(event.index, emit);
  }

  Future<void> _onNextQuestion(
    NextCourseFinalTestQuestionEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseFinalTestLoaded) return;

    final next = current.nextUnansweredIndex;
    if (next == null) {
      emit(
        CourseFinalTestFinished(
          totalQuestions: _tests.length,
          correctAnswers: current.correctCount,
        ),
      );
      return;
    }
    await _showQuestion(next, emit);
  }

  Future<void> _onSubmitAnswer(
    SubmitCourseFinalTestAnswerEvent event,
    Emitter<CourseFinalTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseFinalTestLoaded ||
        current.selectedOptionId == null ||
        current.isSubmitting ||
        current.currentAnswer != null) {
      return;
    }

    emit(current.copyWith(isSubmitting: true, clearError: true));
    final test = _tests[current.currentTestIndex];
    final optionId = current.selectedOptionId!;

    try {
      final response = await submitFinalCourseAnswerUseCase(
        params: SubmitLessonTestAnswerParams(
          courseId: _courseId,
          blockId: _blockId,
          lessonId: _lessonId,
          testId: test.id,
          optionId: optionId,
          image: event.proctorImage,
        ),
      );

      if (!response.isRecorded) {
        _emitFailure(emit, current, kind: LessonTestErrorKind.faceNotVerified);
        return;
      }

      _answers = {
        ..._answers,
        test.id: TestAnswerEntity(
          testId: test.id,
          optionId: optionId,
          isCorrect: response.isCorrect,
        ),
      };
      emit(_withAnswers(current));
    } catch (e) {
      if (apiErrorHasCode(e, 'already_answered')) {
        _answers = await _fetchAnswers();
        emit(
          _withAnswers(
            current,
          ).copyWith(errorKind: LessonTestErrorKind.alreadyAnswered),
        );
        return;
      }

      final isFaceError = e.toString().contains('no_face_found');
      if (!isFaceError) {
        final synced = await _fetchAnswers();
        if (synced.containsKey(test.id)) {
          _answers = synced;
          emit(_withAnswers(current));
          return;
        }
      }

      final statusCode = e is DioException ? e.response?.statusCode : null;
      _emitFailure(
        emit,
        current,
        kind: isFaceError
            ? LessonTestErrorKind.faceNotFound
            : statusCode != null
            ? LessonTestErrorKind.server
            : LessonTestErrorKind.unknown,
        message: apiErrorMessage(e) ?? statusCode?.toString() ?? '',
        details: apiErrorDetails(e),
      );
    }
  }

  CourseFinalTestLoaded _withAnswers(CourseFinalTestLoaded current) {
    return CourseFinalTestLoaded(
      tests: _tests,
      currentTestIndex: current.currentTestIndex,
      currentOptions: current.currentOptions,
      answers: _answers,
      selectedOptionId: current.selectedOptionId,
    );
  }

  void _emitFailure(
    Emitter<CourseFinalTestState> emit,
    CourseFinalTestLoaded current, {
    required LessonTestErrorKind kind,
    String message = '',
    String? details,
  }) {
    emit(
      current.copyWith(
        isSubmitting: false,
        errorKind: kind,
        errorMessage: message,
        errorDetails: details,
      ),
    );
  }
}
