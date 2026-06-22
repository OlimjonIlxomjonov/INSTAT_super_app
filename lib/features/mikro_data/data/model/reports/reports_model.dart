import 'package:my_template/features/mikro_data/data/model/reports/reports_category_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_options_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';

class ReportsModel extends ReportsEntity {
  ReportsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.options,
    required super.isActive,
    required super.fileSize,
    required super.createdAt,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) {
    return ReportsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: ReportsCategoryModel.fromJson(
        json['category'] as Map<String, dynamic>? ?? {},
      ),
      options: (json['options'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                ReportsOptionsModel.fromJson(e as Map<String, dynamic>? ?? {}),
          )
          .toList(),
      isActive: json['is_active'] as bool? ?? false,
      fileSize: json['file_size'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
