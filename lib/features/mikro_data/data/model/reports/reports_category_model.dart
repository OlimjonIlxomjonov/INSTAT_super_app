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
    // Two real shapes have to survive here:
    //  * an empty map, because a report can legitimately have
    //    "category": null and ReportsModel.fromJson substitutes {}
    //  * a populated category whose untranslated locales are null
    //    (e.g. "name_ru": null), which would otherwise fail the
    //    non-nullable String fields.
    final name = json['name'] as String? ?? '';

    return ReportsCategoryModel(
      id: json['id'] as int? ?? 0,
      name: name,
      // Fall back to the base name so an untranslated locale still shows
      // something readable rather than an empty label.
      nameUz: json['name_uz'] as String? ?? name,
      nameRu: json['name_ru'] as String? ?? name,
      nameEn: json['name_en'] as String? ?? name,
      descriptionUz: json['description_uz'] as String?,
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      thumbnail: json['thumbnail'] as String?,
      type: json['type'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
