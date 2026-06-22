import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';

class ReportsOptionsModel extends ReportsOptionsEntity {
  ReportsOptionsModel({
    required super.id,
    required super.dateFrom,
    required super.dateTo,
    required super.fileExtension,
  });

  factory ReportsOptionsModel.fromJson(Map<String, dynamic> json) {
    return ReportsOptionsModel(
      id: json['id'],
      dateFrom: DateTime.parse(json['date_from']),
      dateTo: DateTime.parse(json['date_to']),
      fileExtension: json['file_extension'],
    );
  }
}
