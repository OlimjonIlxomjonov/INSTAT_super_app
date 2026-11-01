import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/test_answer/test_answer_entity.dart';

class TestAnswerModel extends TestAnswerEntity {
  const TestAnswerModel({
    required super.testId,
    required super.optionId,
    required super.isCorrect,
  });

  factory TestAnswerModel.fromJson(Map<String, dynamic> json) {
    return TestAnswerModel(
      testId: (json['lesson_test'] ?? json['course_test'] ?? 0) as int,
      optionId:
          (json['lesson_test_option'] ?? json['course_test_option'] ?? 0)
              as int,
      isCorrect: json['is_correct'] == true,
    );
  }
}
