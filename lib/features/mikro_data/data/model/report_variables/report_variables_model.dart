import 'package:my_template/features/mikro_data/domain/entity/report_variables/report_variables_entity.dart';

class ReportVariablesModel extends ReportVariablesEntity {
  const ReportVariablesModel({
    required super.id,
    required super.dataReport,
    required super.label,
    required super.value,
    required super.createdAt,
  });

  factory ReportVariablesModel.fromJson(Map<String, dynamic> json) {
    return ReportVariablesModel(
      id: json['id'] as int? ?? 0,
      dataReport: json['data_report'] as int? ?? 0,
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
