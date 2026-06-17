import 'package:my_template/features/education_app/features/home_edu/data/model/user_certificate/user_certificate_category_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_certificate_course_entity.dart';

class UserCertificateCourseModel extends UserCertificateCourseEntity {
  UserCertificateCourseModel({
    super.name,
    super.id,
    super.category,
    super.descriptionEn,
    super.isActive,
    super.isOnline,
    super.nameEn,
    super.nameRu,
    super.nameUz,
    super.price,
    super.thumbnail,
  });

  factory UserCertificateCourseModel.fromJson(Map<String, dynamic> json) {
    return UserCertificateCourseModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      descriptionEn: json['description_en'] as String?,
      price: json['price']?.toString(),
      isActive: json['is_active'] as bool?,
      thumbnail: json['thumbnail'] as String?,
      isOnline: json['is_online'] as bool?,
      category: json['category'] != null
          ? UserCertificateCategoryModel.fromJson(json['category'])
          : null,
    );
  }
}
