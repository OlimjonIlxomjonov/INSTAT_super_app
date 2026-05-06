import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_category_model.dart';

class OfflineCourseModel extends OfflineCourseEntity {
  OfflineCourseModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.isOnline,
    super.category,
    super.descriptionEn,
    super.nameEn,
    super.nameRu,
    super.nameUz,
    super.thumbnail,
  });

  factory OfflineCourseModel.fromJson(Map<String, dynamic> json) {
    return OfflineCourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      descriptionEn: json['description_en'] as String?,
      price: json['price'] as String,
      isActive: json['is_active'] as bool,
      thumbnail: json['thumbnail'] as String?,
      isOnline: json['is_online'] as bool,
      category: json['category'] != null
          ? BookCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}
