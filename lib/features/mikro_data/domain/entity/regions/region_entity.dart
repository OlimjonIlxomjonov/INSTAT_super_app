/// `GET regions/` javobidagi tuman.
///
/// Backend'ga yuborilganda `code` ishlatiladi (id emas).
class DistrictEntity {
  final int id;
  final String name;
  final String nameUz;
  final String nameRu;
  final String regionId;
  final String code;

  const DistrictEntity({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.regionId,
    required this.code,
  });

  String localizedName(String localeCode) {
    final localized = localeCode == 'ru' ? nameRu : nameUz;
    return localized.isNotEmpty ? localized : name;
  }
}

class RegionEntity {
  final int id;
  final String name;
  final String nameUz;
  final String nameRu;
  final String code;
  final List<DistrictEntity> districts;

  const RegionEntity({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.code,
    this.districts = const [],
  });

  String localizedName(String localeCode) {
    final localized = localeCode == 'ru' ? nameRu : nameUz;
    return localized.isNotEmpty ? localized : name;
  }
}

/// Hudud tanlash natijasi. Uchala holatni ifodalaydi:
/// respublika bo'yicha (ikkalasi ham null), butun viloyat (faqat region),
/// aniq tuman (ikkalasi ham).
class SelectedArea {
  final RegionEntity? region;
  final DistrictEntity? district;

  const SelectedArea({this.region, this.district});

  bool get isWholeRepublic => region == null;

  String? get regionCode => region?.code;

  String? get districtCode => district?.code;
}
