import 'package:my_template/core/utils/localization/localized_text.dart';

class ModuleCategoryEntity {
  final int id;
  final String name,
      nameUz,
      nameRu,
      nameEn,
      descUz,
      descRu,
      descEn,
      thumbnail,
      type,
      createdAt;

  ModuleCategoryEntity({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.descUz,
    required this.descRu,
    required this.descEn,
    required this.thumbnail,
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
}
