import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_certificate_category_entity.dart';

class UserCertificateCategoryModel extends UserCertificateCategoryEntity {
  UserCertificateCategoryModel({
    super.createdAt,
    super.descriptionEn,
    super.descriptionRu,
    super.descriptionUz,
    super.id,
    super.name,
    super.nameEn,
    super.nameRu,
    super.nameUz,
    super.thumbnail,
    super.type,
  });

  factory UserCertificateCategoryModel.fromJson(Map<String, dynamic> json) {
    return UserCertificateCategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameUz: json['name_uz'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      descriptionUz: json['description_uz'] as String?,
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      thumbnail: json['thumbnail'] as String?,
      type: json['type'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
