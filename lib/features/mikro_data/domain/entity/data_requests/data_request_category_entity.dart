class DataRequestCategoryEntity {
  final int id;
  final String name;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? thumbnail;
  final String type;
  final DateTime? createdAt;

  const DataRequestCategoryEntity({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    this.thumbnail,
    required this.type,
    this.createdAt,
  });

  String localizedName(String localeCode) {
    final localized = switch (localeCode) {
      'ru' => nameRu,
      'en' => nameEn,
      _ => nameUz,
    };
    return localized.isNotEmpty ? localized : name;
  }

  String? localizedDescription(String localeCode) {
    final localized = switch (localeCode) {
      'ru' => descriptionRu,
      'en' => descriptionEn,
      _ => descriptionUz,
    };
    return (localized == null || localized.isEmpty) ? null : localized;
  }
}
