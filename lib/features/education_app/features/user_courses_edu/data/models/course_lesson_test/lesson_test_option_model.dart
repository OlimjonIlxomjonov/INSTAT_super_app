import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';

class LessonTestOptionModel extends LessonTestOptionEntity {
  LessonTestOptionModel({
    required super.id,
    required super.text,
    required super.textUz,
    required super.textRu,
    required super.textEn,
    required super.lessonTest,
    required super.createdAt,
  });

  factory LessonTestOptionModel.fromJson(Map<String, dynamic> json) {
    return LessonTestOptionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      textUz: json['text_uz'] ?? '',
      textRu: json['text_ru'] ?? '',
      textEn: json['text_en'] ?? '',
      lessonTest: json['lesson_test'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
