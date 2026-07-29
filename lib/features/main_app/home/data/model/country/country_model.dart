import 'package:my_template/features/main_app/home/domain/entity/country/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.id,
    required super.nameUz,
    required super.nameRu,
    required super.nameEn,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameEn: json['name_en'] ?? '',
    );
  }
}
