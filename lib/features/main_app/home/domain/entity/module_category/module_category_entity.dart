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
}
