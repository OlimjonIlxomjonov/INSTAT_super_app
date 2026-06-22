import 'package:my_template/features/mikro_data/domain/entity/reports/reports_category_entity.dart';

class ReportsCategoryModel extends ReportsCategoryEntity {
  ReportsCategoryModel({
    required super.id,
    required super.name,
    required super.nameUz,
    required super.nameRu,
    required super.nameEn,
    required super.descriptionUz,
    required super.descriptionRu,
    required super.descriptionEn,
    required super.thumbnail,
    required super.type,
    required super.createdAt,
  });

  factory ReportsCategoryModel.fromJson(Map<String, dynamic> json) {
    return ReportsCategoryModel(
      id: json['id'],
      name: json['name'],
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      thumbnail: json['thumbnail'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
