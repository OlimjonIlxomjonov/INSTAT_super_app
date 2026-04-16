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
}
