import 'package:my_template/features/mikro_data/domain/entity/report_files/report_files_entity.dart';

class ReportFilesModel extends ReportFilesEntity {
  ReportFilesModel({
    required super.id,
    required super.dataReports,
    required super.file,
    required super.fileName,
    required super.fileExtension,
    required super.createdAt,
    required super.fileSize,
  });

  factory ReportFilesModel.fromJson(Map<String, dynamic> json) {
    return ReportFilesModel(
      id: json['id'] ?? 0,
      dataReports: json['data_report'] ?? 0,
      file: json['file'] ?? '',
      fileName: json['file_name'] ?? '',
      fileExtension: json['file_extension'] ?? '',
      createdAt: json['created_at'] ?? DateTime.now(),
      fileSize: json['file_size'] ?? 0.0,
    );
  }
}
