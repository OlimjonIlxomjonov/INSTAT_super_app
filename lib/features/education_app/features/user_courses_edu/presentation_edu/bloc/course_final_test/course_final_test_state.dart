import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';

abstract class CourseFinalTestState {
  const CourseFinalTestState();
}

class CourseFinalTestLoading extends CourseFinalTestState {}

class CourseFinalTestError extends CourseFinalTestState {
  final String message;

  const CourseFinalTestError({required this.message});
}

class CourseFinalTestLoaded extends CourseFinalTestState {
  final List<LessonTestEntity> tests;
  final int currentTestIndex;
  final List<LessonTestOptionEntity> currentOptions;
  final int? selectedOptionId;
  final bool isSubmitting;

  const CourseFinalTestLoaded({
    required this.tests,
    required this.currentTestIndex,
    required this.currentOptions,
    this.selectedOptionId,
    this.isSubmitting = false,
  });

  CourseFinalTestLoaded copyWith({
    List<LessonTestEntity>? tests,
    int? currentTestIndex,
    List<LessonTestOptionEntity>? currentOptions,
    int? selectedOptionId,
    bool? isSubmitting,
  }) {
    return CourseFinalTestLoaded(
      tests: tests ?? this.tests,
      currentTestIndex: currentTestIndex ?? this.currentTestIndex,
      currentOptions: currentOptions ?? this.currentOptions,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CourseFinalTestAnswerResult extends CourseFinalTestState {
  final List<LessonTestEntity> tests;
  final int currentTestIndex;
  final List<LessonTestOptionEntity> currentOptions;
  final int selectedOptionId;
  final LessonTestAnswerResponseEntity answerResponse;

  const CourseFinalTestAnswerResult({
    required this.tests,
    required this.currentTestIndex,
    required this.currentOptions,
    required this.selectedOptionId,
    required this.answerResponse,
  });
}

class CourseFinalTestFinished extends CourseFinalTestState {
  final int totalQuestions;
  final int correctAnswers;

  const CourseFinalTestFinished({
    required this.totalQuestions,
    required this.correctAnswers,
  });
}
