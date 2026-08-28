import 'package:my_template/features/mikro_data/domain/entity/reports/collection_method_entity.dart';

class CollectionMethodModel extends CollectionMethodEntity {
  CollectionMethodModel({
    required super.id,
    required super.titleUz,
    required super.titleRu,
    required super.titleEn,
    super.descriptionUz,
    super.descriptionRu,
    super.descriptionEn,
    required super.createdAt,
  });

  factory CollectionMethodModel.fromJson(Map<String, dynamic> json) {
    return CollectionMethodModel(
      id: json['id'] as int? ?? 0,
      titleUz: json['title_uz'] as String? ?? '',
      titleRu: json['title_ru'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      descriptionUz: json['description_uz'] as String?,
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
