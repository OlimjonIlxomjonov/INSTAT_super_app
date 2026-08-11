import 'package:my_template/features/mikro_data/data/model/regions/region_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';

class ReportsOptionsModel extends ReportsOptionsEntity {
  ReportsOptionsModel({
    required super.id,
    required super.dateFrom,
    required super.dateTo,
    required super.fileExtension,
    super.region,
    super.district,
    super.dataReport,
    super.file,
    super.fileSize,
    super.fileName,
    super.price,
    super.createdAt,
  });

  factory ReportsOptionsModel.fromJson(Map<String, dynamic> json) {
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);

    final regionJson = json['region'] as Map<String, dynamic>?;
    final districtJson = json['district'] as Map<String, dynamic>?;

    final fileNameStr = json['file_name']?.toString() ?? '';
    final fileStr = json['file']?.toString() ?? '';
    var ext = json['file_extension'] as String? ?? '';
    if (ext.isEmpty && fileNameStr.isNotEmpty && fileNameStr.contains('.')) {
      ext = '.${fileNameStr.split('.').last}';
    } else if (ext.isEmpty && fileStr.isNotEmpty && fileStr.contains('.')) {
      final cleanPath = fileStr.split('?').first;
      if (cleanPath.contains('.')) {
        ext = '.${cleanPath.split('.').last}';
      }
    }

    return ReportsOptionsModel(
      id: json['id'] as int? ?? 0,
      dateFrom: DateTime.tryParse(json['date_from']?.toString() ?? '') ?? epoch,
      dateTo: DateTime.tryParse(json['date_to']?.toString() ?? '') ?? epoch,
      fileExtension: ext,
      region: regionJson != null ? RegionModel.fromJson(regionJson) : null,
      district:
          districtJson != null ? DistrictModel.fromJson(districtJson) : null,
      dataReport: json['data_report'] as int?,
      file: json['file'] as String?,
      fileSize: json['file_size'],
      fileName: json['file_name'] as String?,
      price: json['price']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  static List<ReportsOptionsModel> listFromJson(dynamic json) {
    if (json is! List) return const [];
    return json
        .map((e) => ReportsOptionsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

