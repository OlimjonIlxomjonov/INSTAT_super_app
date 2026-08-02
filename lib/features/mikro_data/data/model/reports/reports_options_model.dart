import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';

class ReportsOptionsModel extends ReportsOptionsEntity {
  ReportsOptionsModel({
    required super.id,
    required super.dateFrom,
    required super.dateTo,
    required super.fileExtension,
  });

  factory ReportsOptionsModel.fromJson(Map<String, dynamic> json) {
    // Same defensiveness as the category model — "options" is empty in the
    // current API responses, so any null field here would only blow up
    // later, in production, the first time the backend returns one.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);

    return ReportsOptionsModel(
      id: json['id'] as int? ?? 0,
      dateFrom:
          DateTime.tryParse(json['date_from']?.toString() ?? '') ?? epoch,
      dateTo: DateTime.tryParse(json['date_to']?.toString() ?? '') ?? epoch,
      fileExtension: json['file_extension'] as String? ?? '',
    );
  }
}
