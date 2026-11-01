import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/test_answer/test_answer_entity.dart';

abstract class CourseFinalTestState {
  const CourseFinalTestState();
}

class CourseFinalTestLoading extends CourseFinalTestState {}

class CourseFinalTestError extends CourseFinalTestState {
  final String message;
  final LessonTestErrorKind kind;

  const CourseFinalTestError({
    required this.message,
    this.kind = LessonTestErrorKind.unknown,
  });
}

class CourseFinalTestLoaded extends CourseFinalTestState {
  final List<LessonTestEntity> tests;
  final int currentTestIndex;
  final List<LessonTestOptionEntity> currentOptions;
  final bool isOptionsLoading;
  final int? selectedOptionId;
  final bool isSubmitting;
  final Map<int, TestAnswerEntity> answers;
  final LessonTestErrorKind? errorKind;
  final String errorMessage;
  final String? errorDetails;

  const CourseFinalTestLoaded({
    required this.tests,
    required this.currentTestIndex,
    required this.currentOptions,
    required this.answers,
    this.isOptionsLoading = false,
    this.selectedOptionId,
    this.isSubmitting = false,
    this.errorKind,
    this.errorMessage = '',
    this.errorDetails,
  });

  TestAnswerEntity? get currentAnswer => answers[tests[currentTestIndex].id];

  TestAnswerEntity? answerAt(int index) => answers[tests[index].id];

  int get answeredCount => tests.where((t) => answers.containsKey(t.id)).length;

  bool get isAllAnswered => answeredCount == tests.length;

  int get correctCount =>
      tests.where((t) => answers[t.id]?.isCorrect == true).length;

  double get progress => tests.isEmpty ? 0 : answeredCount / tests.length;

  int? get nextUnansweredIndex {
    for (var step = 1; step <= tests.length; step++) {
      final index = (currentTestIndex + step) % tests.length;
      if (!answers.containsKey(tests[index].id)) return index;
    }
    return null;
  }

  CourseFinalTestLoaded copyWith({
    int? selectedOptionId,
    bool? isSubmitting,
    Map<int, TestAnswerEntity>? answers,
    LessonTestErrorKind? errorKind,
    String? errorMessage,
    String? errorDetails,
    bool clearError = false,
  }) {
    return CourseFinalTestLoaded(
      tests: tests,
      currentTestIndex: currentTestIndex,
      currentOptions: currentOptions,
      isOptionsLoading: isOptionsLoading,
      answers: answers ?? this.answers,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorKind: clearError ? null : (errorKind ?? this.errorKind),
      errorMessage: clearError ? '' : (errorMessage ?? this.errorMessage),
      errorDetails: clearError ? null : (errorDetails ?? this.errorDetails),
    );
  }
}

class CourseFinalTestFinished extends CourseFinalTestState {
  final int totalQuestions;
  final int correctAnswers;

  const CourseFinalTestFinished({
    required this.totalQuestions,
    required this.correctAnswers,
  });
}
