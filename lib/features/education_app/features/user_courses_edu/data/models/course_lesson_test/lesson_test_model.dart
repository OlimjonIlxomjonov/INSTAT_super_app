import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';

class LessonTestModel extends LessonTestEntity {
  LessonTestModel({
    required super.id,
    required super.question,
    required super.questionUz,
    required super.questionRu,
    required super.questionEn,
    required super.lesson,
    required super.thumbnail,
    required super.createdAt,
  });

  factory LessonTestModel.fromJson(Map<String, dynamic> json) {
    return LessonTestModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      questionUz: json['question_uz'] ?? '',
      questionRu: json['question_ru'] ?? '',
      questionEn: json['question_en'] ?? '',
      lesson: json['lesson'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
