import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_entity.dart';

class CourseLessonItemsModel extends CourseLessonItemsEntity {
  const CourseLessonItemsModel({
    required super.id,
    required super.testsCount,
    required super.filesCount,
    required super.userLessons,
    required super.viewedLessons,
    required super.title,
    super.titleUz,
    super.titleRu,
    super.titleEn,
    super.descriptionUz,
    super.descriptionRu,
    super.descriptionEn,
    required super.isActive,
    super.thumbnail,
    super.hlsFolder,
    required super.status,
    required super.duration,
    required super.createdAt,
    required super.progress,
    required super.courseBlock,
  });

  factory CourseLessonItemsModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonItemsModel(
      id: json['id'],
      testsCount: json['tests_count'],
      filesCount: json['files_count'],
      userLessons: json['user_lessons'],
      viewedLessons: json['viewed_lessons'],
      title: json['title'],
      titleUz: json['title_uz'],
      titleRu: json['title_ru'],
      titleEn: json['title_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      isActive: json['is_active'],
      thumbnail: json['thumbnail'],
      hlsFolder: json['hls_folder'],
      status: json['status'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['created_at']),
      progress: (json['progress'] as num).toDouble(),
      courseBlock: json['course_block'],
    );
  }
}
