import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';

class LessonTestAnswerResponseModel extends LessonTestAnswerResponseEntity {
  LessonTestAnswerResponseModel({
    required super.data,
    required super.isFinished,
    required super.isCorrect,
  });

  factory LessonTestAnswerResponseModel.fromJson(Map<String, dynamic> json) {
    return LessonTestAnswerResponseModel(
      data: LessonTestAnswerDataModel.fromJson(json['data'] ?? {}),
      isFinished: json['is_finished'] ?? false,
      isCorrect: json['is_correct'] ?? false,
    );
  }
}

class LessonTestAnswerDataModel extends LessonTestAnswerDataEntity {
  LessonTestAnswerDataModel({
    required super.id,
    required super.lessonTest,
    required super.user,
    required super.isCorrect,
    required super.lessonTestOption,
  });

  factory LessonTestAnswerDataModel.fromJson(Map<String, dynamic> json) {
    return LessonTestAnswerDataModel(
      id: json['id'] ?? 0,
      lessonTest: json['lesson_test'] ?? 0,
      user: json['user'] ?? 0,
      isCorrect: json['is_correct'] ?? false,
      lessonTestOption: json['lesson_test_option'] ?? 0,
    );
  }
}
