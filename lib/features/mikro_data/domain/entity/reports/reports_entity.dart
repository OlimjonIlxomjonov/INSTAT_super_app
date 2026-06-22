import 'package:my_template/features/mikro_data/domain/entity/reports/reports_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';

class ReportsEntity {
  final int id;
  final String name;
  final String? description;
  final ReportsCategoryEntity category;
  final List<ReportsOptionsEntity> options;
  final bool isActive;
  final String? fileSize;
  final DateTime createdAt;

  const ReportsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.options,
    required this.isActive,
    required this.fileSize,
    required this.createdAt,
  });
}
