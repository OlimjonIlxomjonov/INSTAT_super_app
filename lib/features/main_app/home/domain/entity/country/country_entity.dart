class CountryEntity {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;

  CountryEntity({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
  });

  String displayName(String localeCode) {
    switch (localeCode) {
      case 'ru':
        return nameRu;
      case 'en':
        return nameEn;
      default:
        return nameUz;
    }
  }
}
