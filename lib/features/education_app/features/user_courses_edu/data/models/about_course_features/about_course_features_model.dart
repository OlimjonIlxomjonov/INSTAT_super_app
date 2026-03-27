import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_course_features.dart';

class AboutCourseFeaturesModel extends AboutCourseFeaturesEntity {
  AboutCourseFeaturesModel({
    required super.id,
    required super.text,
    required super.course,
    required super.createdAt,
    super.textEn,
    super.textRu,
    super.textUz,
  });

  factory AboutCourseFeaturesModel.fromJson(Map<String, dynamic> json) {
    return AboutCourseFeaturesModel(
      id: json['id'] as int,
      text: json['text'] as String,
      textUz: json['text_uz'] as String?,
      textRu: json['text_ru'] as String?,
      textEn: json['text_en'] as String?,
      course: json['course'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
