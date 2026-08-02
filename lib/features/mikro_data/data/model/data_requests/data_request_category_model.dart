import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';

class DataRequestCategoryModel extends DataRequestCategoryEntity {
  const DataRequestCategoryModel({
    required super.id,
    required super.name,
    required super.nameUz,
    required super.nameRu,
    required super.nameEn,
    super.descriptionUz,
    super.descriptionRu,
    super.descriptionEn,
    super.thumbnail,
    required super.type,
    super.createdAt,
  });

  /// `category` draft so'rovlarda null bo'lib keladi — shuning uchun nullable.
  static DataRequestCategoryModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return DataRequestCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      thumbnail: json['thumbnail'],
      type: json['type'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
