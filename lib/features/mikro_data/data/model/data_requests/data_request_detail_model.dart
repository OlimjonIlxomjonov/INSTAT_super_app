import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_detail_entity.dart';

class DataRequestDetailModel extends DataRequestDetailEntity {
  const DataRequestDetailModel({
    required super.id,
    required super.fullName,
    super.companyName,
    super.categoryId,
    super.description,
    super.aim,
    super.regionCode,
    super.districtCode,
    super.dateFrom,
    super.dateTo,
    super.phoneNumber,
    super.email,
    super.status,
    super.createdAt,
    super.fileUrl,
    super.fileName,
    super.fileSize,
    super.fileExtension,
  });

  factory DataRequestDetailModel.fromJson(Map<String, dynamic>? json) {
    return DataRequestDetailModel(
      id: json?['id'] ?? 0,
      fullName: json?['full_name'] ?? '',
      companyName: json?['company_name'],
      categoryId: json?['category'],
      description: json?['description'],
      aim: json?['aim'],
      regionCode: json?['region']?.toString(),
      districtCode: json?['district']?.toString(),
      dateFrom: DateTime.tryParse(json?['date_from']?.toString() ?? ''),
      dateTo: DateTime.tryParse(json?['date_to']?.toString() ?? ''),
      phoneNumber: json?['phone_number'],
      email: json?['email'],
      status: json?['status'] ?? 'draft',
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
      fileUrl: json?['file'],
      fileName: json?['file_name'] ?? '',
      fileSize: json?['file_size'],
      fileExtension: json?['file_extension'] ?? '',
    );
  }
}
