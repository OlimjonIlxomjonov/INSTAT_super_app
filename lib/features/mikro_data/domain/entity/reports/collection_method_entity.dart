class CollectionMethodEntity {
  final int id;
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final DateTime createdAt;

  const CollectionMethodEntity({
    required this.id,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    required this.createdAt,
  });

  String localizedTitle(String localeCode) {
    if (localeCode == 'ru' && titleRu.isNotEmpty) return titleRu;
    if (localeCode == 'en' && titleEn.isNotEmpty) return titleEn;
    return titleUz;
  }
}
