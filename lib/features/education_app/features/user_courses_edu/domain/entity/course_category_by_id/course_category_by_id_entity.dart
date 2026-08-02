import 'package:my_template/core/utils/localization/localized_text.dart';

class CourseCategoryByIdEntity {
  final int id;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? thumbnail;
  final String createdAt;

  CourseCategoryByIdEntity({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    this.nameEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    this.thumbnail,
    required this.createdAt,
  });

  /// The category name in [localeCode], falling back to [name] (always
  /// Uzbek) when the requested translation is missing.
  String displayName(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: name,
    uz: nameUz,
    ru: nameRu,
    en: nameEn,
  );
}
