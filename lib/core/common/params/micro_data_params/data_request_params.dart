import 'dart:io';

import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';

class DataRequestParams {
  final int? id;
  final String fullName;
  final String? companyName;
  final DataRequestCategoryEntity? category;
  final String? description;
  final String? aim;
  final String? regionCode;
  final String? districtCode;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? phoneNumber;
  final String? email;
  final String status;

  const DataRequestParams({
    this.id,
    required this.fullName,
    this.companyName,
    this.category,
    this.description,
    this.aim,
    this.regionCode,
    this.districtCode,
    this.dateFrom,
    this.dateTo,
    this.phoneNumber,
    this.email,
    this.status = 'draft',
  });

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'company_name': companyName,
      'category': category?.id,
      'description': description,
      'aim': aim,
      'region': regionCode,
      'district': districtCode,
      'date_from': _formatDate(dateFrom),
      'date_to': _formatDate(dateTo),
      'phone_number': phoneNumber,
      'email': email,
      'status': status,
    };
  }
}

class UploadDataRequestFileParams {
  final int requestId;
  final File file;

  const UploadDataRequestFileParams({
    required this.requestId,
    required this.file,
  });
}

//! Report Data Params
class ReportFilesParams {
  final int reportId;

  ReportFilesParams({required this.reportId});
}

class ReportVariablesParams {
  final int reportId;

  ReportVariablesParams({required this.reportId});
}
