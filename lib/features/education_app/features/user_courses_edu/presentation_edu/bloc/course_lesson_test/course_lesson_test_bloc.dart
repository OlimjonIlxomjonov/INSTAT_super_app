import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/per_course/per_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/test_answer/test_answer_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_test_options_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_tests_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/submit_lesson_test_answer_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/test_answers/test_answers_use_cases.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_state.dart';

class CourseLessonTestBloc
    extends Bloc<CourseLessonTestEvent, CourseLessonTestState> {
  final GetLessonTestsUseCase getLessonTestsUseCase;
  final GetLessonTestOptionsUseCase getLessonTestOptionsUseCase;
  final SubmitLessonTestAnswerUseCase submitLessonTestAnswerUseCase;
  final LessonTestAnswersUseCase lessonTestAnswersUseCase;
  final PerCourseUseCase perCourseUseCase;

  List<LessonTestEntity> _tests = [];
  Map<int, TestAnswerEntity> _answers = {};
  final Map<int, List<LessonTestOptionEntity>> _optionsCache = {};
  Future<CourseEntity?>? _courseFuture;
  int _courseId = 0;
  int _blockId = 0;
  int _lessonId = 0;
  int _navigationId = 0;

  CourseLessonTestBloc({
    required this.getLessonTestsUseCase,
    required this.getLessonTestOptionsUseCase,
    required this.submitLessonTestAnswerUseCase,
    required this.lessonTestAnswersUseCase,
    required this.perCourseUseCase,
  }) : super(CourseLessonTestLoading()) {
    on<LoadCourseLessonTestsEvent>(_onLoadTests);
    on<SelectLessonTestOptionEvent>(_onSelectOption);
    on<SubmitLessonTestAnswerEvent>(_onSubmitAnswer);
    on<NextLessonTestQuestionEvent>(_onNextQuestion);
    on<GoToLessonTestQuestionEvent>(_onGoToQuestion);
  }

  Future<void> _onLoadTests(
    LoadCourseLessonTestsEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    emit(CourseLessonTestLoading());
    _courseId = event.params.courseId;
    _blockId = event.params.blockId;
    _lessonId = event.params.lessonId;
    _answers = {};
    _optionsCache.clear();
    _courseFuture = _fetchCourse();

    try {
      final testsFuture = getLessonTestsUseCase(event.params);
      final answersFuture = _fetchAnswers();
      _tests = await testsFuture;
      _answers = await answersFuture;

      if (_tests.isEmpty) {
        emit(
          const CourseLessonTestFinished(totalQuestions: 0, correctAnswers: 0),
        );
        return;
      }

      final firstUnanswered = _tests.indexWhere(
        (test) => !_answers.containsKey(test.id),
      );
      await _showQuestion(firstUnanswered < 0 ? 0 : firstUnanswered, emit);
    } catch (e) {
      emit(CourseLessonTestError(message: e.toString()));
    }
  }

  Future<Map<int, TestAnswerEntity>> _fetchAnswers() async {
    try {
      final answers = await lessonTestAnswersUseCase(_lessonId);
      return {for (final answer in answers) answer.testId: answer};
    } catch (_) {
      return _answers;
    }
  }

  Future<CourseEntity?> _fetchCourse() async {
    try {
      return await perCourseUseCase(
        params: PerCourseParams(courseId: _courseId),
      );
    } catch (_) {
      return null;
    }
  }

  Future<int> _passingScore() async {
    var course = await (_courseFuture ??= _fetchCourse());
    if (course == null) {
      _courseFuture = _fetchCourse();
      course = await _courseFuture;
    }
    return course?.score ?? 100;
  }

  Future<void> _showQuestion(
    int index,
    Emitter<CourseLessonTestState> emit,
  ) async {
    final navigation = ++_navigationId;
    final testId = _tests[index].id;
    final cached = _optionsCache[testId];

    if (cached != null) {
      emit(
        CourseLessonTestLoaded(
          tests: _tests,
          currentTestIndex: index,
          currentOptions: cached,
          answers: _answers,
        ),
      );
      return;
    }

    emit(
      CourseLessonTestLoaded(
        tests: _tests,
        currentTestIndex: index,
        currentOptions: const [],
        answers: _answers,
        isOptionsLoading: true,
      ),
    );

    try {
      final options = await getLessonTestOptionsUseCase(
        CourseLessonTestOptionsParams(
          courseId: _courseId,
          blockId: _blockId,
          lessonId: _lessonId,
          testId: testId,
        ),
      );
      _optionsCache[testId] = options;
      if (navigation != _navigationId) return;
      emit(
        CourseLessonTestLoaded(
          tests: _tests,
          currentTestIndex: index,
          currentOptions: options,
          answers: _answers,
        ),
      );
    } catch (e) {
      if (navigation != _navigationId) return;
      emit(
        CourseLessonTestLoaded(
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
    SelectLessonTestOptionEvent event,
    Emitter<CourseLessonTestState> emit,
  ) {
    final current = state;
    if (current is! CourseLessonTestLoaded ||
        current.isSubmitting ||
        current.currentAnswer != null) {
      return;
    }
    emit(current.copyWith(selectedOptionId: event.optionId, clearError: true));
  }

  Future<void> _onGoToQuestion(
    GoToLessonTestQuestionEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseLessonTestLoaded || current.isSubmitting) return;
    if (event.index < 0 || event.index >= _tests.length) return;
    if (event.index == current.currentTestIndex &&
        current.currentOptions.isNotEmpty) {
      return;
    }
    await _showQuestion(event.index, emit);
  }

  Future<void> _onNextQuestion(
    NextLessonTestQuestionEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseLessonTestLoaded || current.isSubmitting) return;

    final next = current.nextUnansweredIndex;
    if (next == null) {
      emit(current.copyWith(isSubmitting: true, clearError: true));
      final passingScore = await _passingScore();
      emit(
        CourseLessonTestFinished(
          totalQuestions: _tests.length,
          correctAnswers: current.correctCount,
          passingScore: passingScore,
        ),
      );
      return;
    }
    await _showQuestion(next, emit);
  }

  Future<void> _onSubmitAnswer(
    SubmitLessonTestAnswerEvent event,
    Emitter<CourseLessonTestState> emit,
  ) async {
    final current = state;
    if (current is! CourseLessonTestLoaded ||
        current.selectedOptionId == null ||
        current.isSubmitting ||
        current.currentAnswer != null) {
      return;
    }

    emit(current.copyWith(isSubmitting: true, clearError: true));
    final test = _tests[current.currentTestIndex];
    final optionId = current.selectedOptionId!;

    try {
      final response = await submitLessonTestAnswerUseCase(
        SubmitLessonTestAnswerParams(
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

  CourseLessonTestLoaded _withAnswers(CourseLessonTestLoaded current) {
    return CourseLessonTestLoaded(
      tests: _tests,
      currentTestIndex: current.currentTestIndex,
      currentOptions: current.currentOptions,
      answers: _answers,
      selectedOptionId: current.selectedOptionId,
    );
  }

  void _emitFailure(
    Emitter<CourseLessonTestState> emit,
    CourseLessonTestLoaded current, {
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
