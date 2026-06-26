import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_offline_lessons_entity/course_offline_lessons_entity.dart';

class CourseOfflineLessonsModel extends CourseOfflineLessonsEntity {
  CourseOfflineLessonsModel({
    required super.id,
    required super.title,
    required super.isActive,
    required super.thumbnail,
    required super.status,
    required super.duration,
    required super.createdAt,
    required super.progress,
    required super.courseBlock,
    super.descriptionEn,
    super.descriptionRu,
    super.descriptionUz,
    super.hlsFolder,
    super.titleEn,
    super.titleRu,
    super.titleUz,
  });

  factory CourseOfflineLessonsModel.fromJson(Map<String, dynamic> json) {
    return CourseOfflineLessonsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      titleUz: json['title_uz'] as String?,
      titleRu: json['title_ru'] as String?,
      titleEn: json['title_en'] as String?,
      descriptionUz: json['description_uz'] as String?,
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      isActive: json['is_active'] as bool,
      thumbnail: json['thumbnail'] as String,
      hlsFolder: json['hls_folder'] as String?,
      status: json['status'] as String,
      duration: json['duration'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      progress: (json['progress'] as num).toDouble(),
      courseBlock: json['course_block'] as int,
    );
  }
}
