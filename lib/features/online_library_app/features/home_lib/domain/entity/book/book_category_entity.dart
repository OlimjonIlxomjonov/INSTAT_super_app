import 'package:my_template/core/utils/localization/localized_text.dart';

class BookCategoryEntity {
  final int id;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? thumbnail;
  final String type;
  final String createdAt;

  BookCategoryEntity({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    this.nameEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    this.thumbnail,
    required this.type,
    required this.createdAt,
  });

  // Localized name
  String displayName(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: name,
    uz: nameUz,
    ru: nameRu,
    en: nameEn,
  );

  // Localized description
  String? localizedDescription(String localeCode) => localizedTextOrNull(
    localeCode: localeCode,
    uz: descriptionUz,
    ru: descriptionRu,
    en: descriptionEn,
  );
}
