class ReportsCategoryEntity {
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
  final DateTime createdAt;

  const ReportsCategoryEntity({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.thumbnail,
    required this.type,
    required this.createdAt,
  });
}
