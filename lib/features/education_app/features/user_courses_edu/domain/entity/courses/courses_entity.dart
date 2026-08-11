import 'package:my_template/core/utils/localization/localized_text.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/sertificate_object_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/user_order_entity.dart';

class CourseEntity {
  final int id;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String price;
  final String? certificateImage;
  final bool isActive;
  final String thumbnail;
  final bool isOnline;
  final int category;
  final int lessonsCount;
  final int totalDuration;
  final int? testsCount;
  final int? ratingsCount;
  final int? ratingSum;
  final int? score;
  final UserOrder? userOrder;
  final List<CertificateObject> certificateObjects;

  CourseEntity({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    this.nameEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    required this.price,
    this.certificateImage,
    required this.isActive,
    required this.thumbnail,
    required this.isOnline,
    required this.category,
    required this.lessonsCount,
    required this.totalDuration,
    this.testsCount,
    this.ratingsCount,
    this.ratingSum,
    this.score,
    this.userOrder,
    this.certificateObjects = const [],
  });

  String displayName(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: name,
    uz: nameUz,
    ru: nameRu,
    en: nameEn,
  );

  String? localizedDescription(String localeCode) => localizedTextOrNull(
    localeCode: localeCode,
    uz: descriptionUz,
    ru: descriptionRu,
    en: descriptionEn,
  );
}
