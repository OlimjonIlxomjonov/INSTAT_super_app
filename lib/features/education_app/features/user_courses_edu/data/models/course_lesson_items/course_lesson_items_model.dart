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
    required super.isFaceIdEnabled,
  });

  factory CourseLessonItemsModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonItemsModel(
      id: json['id'] ?? 0,
      testsCount: json['tests_count'] ?? 0,
      filesCount: json['files_count'] ?? 0,
      userLessons: json['user_lessons'] ?? 0,
      viewedLessons: json['viewed_lessons'] ?? 0,
      title: json['title'] ?? '',
      titleUz: json['title_uz'],
      titleRu: json['title_ru'],
      titleEn: json['title_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      isActive: json['is_active'] ?? false,
      thumbnail: json['thumbnail'],
      hlsFolder: json['hls_folder'],
      status: json['status'] ?? '',
      duration: json['duration'] ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      courseBlock: json['course_block'] ?? 0,
      isFaceIdEnabled: json['is_face_id_enabled'] == true,
    );
  }
}
