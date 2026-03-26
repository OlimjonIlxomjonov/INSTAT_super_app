import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';

class CourseCategoryByIdModel extends CourseCategoryByIdEntity {
  CourseCategoryByIdModel({
    required super.id,
    required super.name,
    required super.createdAt,
    super.descriptionEn,
    super.descriptionRu,
    super.nameEn,
    super.nameRu,
    super.descriptionUz,
    super.nameUz,
    super.thumbnail,
  });

  factory CourseCategoryByIdModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryByIdModel(
      id: json['id'],
      name: json['name'],
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      thumbnail: json['thumbnail'],
      createdAt: json['created_at'],
    );
  }
}
