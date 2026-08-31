import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_entity.dart';

class ModuleCategoryModel extends ModuleCategoryEntity {
  ModuleCategoryModel({
    required super.id,
    required super.name,
    required super.nameUz,
    required super.nameRu,
    required super.nameEn,
    required super.descUz,
    required super.descRu,
    required super.descEn,
    required super.thumbnail,
    required super.type,
    required super.createdAt,
  });

  factory ModuleCategoryModel.fromJson(Map<String, dynamic> json) {
    return ModuleCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      nameUz: json['name_uz'] ?? 'Unknown',
      nameRu: json['name_ru'] ?? 'Unknown',
      nameEn: json['name_en'] ?? 'Unknown',
      descUz: json['description_uz'] ?? 'Unknown',
      descRu: json['description_ru'] ?? 'Unknown',
      descEn: json['description_en'] ?? 'Unknown',
      thumbnail: json['thumbnail'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
