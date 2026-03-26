import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_entity.dart';

class CourseLessonTopicsModel extends CourseLessonTopicsEntity {
  CourseLessonTopicsModel({
    required super.id,
    required super.text,
    required super.course,
    required super.isActive,
    required super.totalDuration,
    required super.lessonFilesCount,
    required super.lessonsCount,
    required super.lessonsTestsCount,
    required super.createdAt,
    super.textEn,
    super.textRu,
    super.textUz,
  });

  factory CourseLessonTopicsModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonTopicsModel(
      id: json['id'],
      text: json['text'],
      textUz: json['text_uz'],
      textRu: json['text_ru'],
      textEn: json['text_en'],
      course: json['course'],
      isActive: json['is_active'],
      totalDuration: json['total_duration'],
      lessonFilesCount: json['lesson_files_count'],
      lessonsCount: json['lessons_count'],
      lessonsTestsCount: json['lessons_tests_count'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
