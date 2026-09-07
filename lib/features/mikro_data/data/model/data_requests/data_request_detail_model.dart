import 'package:my_template/features/mikro_data/data/model/data_requests/data_report_ref_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_detail_entity.dart';

class DataRequestDetailModel extends DataRequestDetailEntity {
  const DataRequestDetailModel({
    required super.id,
    required super.fullName,
    super.companyName,
    super.email,
    super.phoneNumber,
    super.teamMembers,
    super.projectName,
    super.projectAim,
    super.benefit,
    super.aimToUse,
    super.dataReport,
    super.dateFrom,
    super.dateTo,
    super.whyNotEnough,
    super.notEnoughComment,
    super.processingEnvironmentId,
    super.processingEnvironmentName,
    super.entryDateFrom,
    super.entryDateTo,
    super.expectation,
    super.plan,
    super.status,
    super.createdAt,
    super.fileUrl,
    super.fileName,
    super.fileSize,
    super.fileExtension,
    super.companyFileUrl,
    super.companyFileName,
    super.companyFileSize,
    super.companyFileExtension,
  });

  // Muhit endpointi kelgach shakli aniqlashadi
  static int? _environmentId(dynamic value) {
    if (value is int) return value;
    if (value is Map) return value['id'] as int?;
    return null;
  }

  static String? _environmentName(dynamic value) {
    if (value is Map) {
      return (value['title_uz'] ?? value['name'] ?? value['title'])?.toString();
    }
    return null;
  }

  factory DataRequestDetailModel.fromJson(Map<String, dynamic>? json) {
    return DataRequestDetailModel(
      id: json?['id'] ?? 0,
      fullName: json?['full_name'] ?? '',
      companyName: json?['company_name'],
      email: json?['email'],
      phoneNumber: json?['phone_number'],
      teamMembers: json?['team_members'],
      projectName: json?['project_name'],
      projectAim: json?['project_aim'],
      benefit: json?['benefit'],
      aimToUse: json?['aimtouse'],
      dataReport: DataReportRefModel.tryFromJson(json?['data_report']),
      dateFrom: DateTime.tryParse(json?['date_from']?.toString() ?? ''),
      dateTo: DateTime.tryParse(json?['date_to']?.toString() ?? ''),
      whyNotEnough: json?['why_not_enough'],
      notEnoughComment: json?['not_enough_comment'],
      processingEnvironmentId: _environmentId(json?['processing_environment']),
      processingEnvironmentName: _environmentName(
        json?['processing_environment'],
      ),
      entryDateFrom: DateTime.tryParse(
        json?['entry_date_from']?.toString() ?? '',
      ),
      entryDateTo: DateTime.tryParse(json?['entry_date_to']?.toString() ?? ''),
      expectation: json?['expectation'],
      plan: json?['plan'],
      status: json?['status'] ?? 'draft',
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
      fileUrl: json?['file'],
      fileName: json?['file_name'] ?? '',
      fileSize: json?['file_size'],
      fileExtension: json?['file_extension'] ?? '',
      companyFileUrl: json?['company_file'],
      companyFileName: json?['company_file_name'] ?? '',
      companyFileSize: json?['company_file_size'],
      companyFileExtension: json?['company_file_extension'] ?? '',
    );
  }
}
