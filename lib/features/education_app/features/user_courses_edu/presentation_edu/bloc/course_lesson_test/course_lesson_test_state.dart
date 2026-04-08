import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';

abstract class CourseLessonTestState {
  const CourseLessonTestState();
}

class CourseLessonTestLoading extends CourseLessonTestState {}

class CourseLessonTestError extends CourseLessonTestState {
  final String message;

  const CourseLessonTestError({required this.message});
}

class CourseLessonTestLoaded extends CourseLessonTestState {
  final List<LessonTestEntity> tests;
  final int currentTestIndex;
  final List<LessonTestOptionEntity> currentOptions;
  final int? selectedOptionId;
  final bool isSubmitting;

  const CourseLessonTestLoaded({
    required this.tests,
    required this.currentTestIndex,
    required this.currentOptions,
    this.selectedOptionId,
    this.isSubmitting = false,
  });

  CourseLessonTestLoaded copyWith({
    List<LessonTestEntity>? tests,
    int? currentTestIndex,
    List<LessonTestOptionEntity>? currentOptions,
    int? selectedOptionId,
    bool? isSubmitting,
  }) {
    return CourseLessonTestLoaded(
      tests: tests ?? this.tests,
      currentTestIndex: currentTestIndex ?? this.currentTestIndex,
      currentOptions: currentOptions ?? this.currentOptions,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CourseLessonTestAnswerResult extends CourseLessonTestState {
  final List<LessonTestEntity> tests;
  final int currentTestIndex;
  final List<LessonTestOptionEntity> currentOptions;
  final int selectedOptionId;
  final LessonTestAnswerResponseEntity answerResponse;

  const CourseLessonTestAnswerResult({
    required this.tests,
    required this.currentTestIndex,
    required this.currentOptions,
    required this.selectedOptionId,
    required this.answerResponse,
  });
}

class CourseLessonTestFinished extends CourseLessonTestState {
  final int totalQuestions;
  final int correctAnswers;

  const CourseLessonTestFinished({
    required this.totalQuestions,
    required this.correctAnswers,
  });
}
