import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_certificate_category_entity.dart';

class UserCertificateCourseEntity {
  final int? id;
  final String? name;
  final String? nameUz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionEn;
  final String? price;
  final bool? isActive;
  final String? thumbnail;
  final bool? isOnline;
  final UserCertificateCategoryEntity? category;

  const UserCertificateCourseEntity({
    this.id,
    this.name,
    this.nameUz,
    this.nameRu,
    this.nameEn,
    this.descriptionEn,
    this.price,
    this.isActive,
    this.thumbnail,
    this.isOnline,
    this.category,
  });
}
