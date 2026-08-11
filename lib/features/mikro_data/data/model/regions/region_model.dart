import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';

class DistrictModel extends DistrictEntity {
  const DistrictModel({
    required super.id,
    required super.name,
    required super.nameUz,
    required super.nameRu,
    required super.regionId,
    required super.code,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      regionId: json['region_id']?.toString() ?? '',
      // `code` va `district_code` bir xil qiymat — birinchisi yo'q bo'lsa
      // ikkinchisiga tushamiz.
      code: (json['code'] ?? json['district_code'])?.toString() ?? '',
    );
  }
}

class RegionModel extends RegionEntity {
  const RegionModel({
    required super.id,
    required super.name,
    required super.nameUz,
    required super.nameRu,
    required super.code,
    super.districts,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      code: (json['code'] ?? json['region_code'])?.toString() ?? '',
      districts: _parseDistricts(json['districts']),
    );
  }

  /// `districts` backend'dan ikki xil formatda kelishi mumkin:
  /// — `List<Map>` (to'liq district ob'ektlari)
  /// — `List<int>` (faqat id'lar, masalan reports options ichida)
  /// Ikkinchi holatda parsing'ni o'tkazib yuboramiz.
  static List<DistrictModel> _parseDistricts(dynamic raw) {
    if (raw is! List || raw.isEmpty) return const [];
    if (raw.first is Map<String, dynamic>) {
      return raw
          .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }

  static List<RegionModel> listFromJson(dynamic json) {
    if (json is! List) return const [];
    return json
        .map((e) => RegionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
