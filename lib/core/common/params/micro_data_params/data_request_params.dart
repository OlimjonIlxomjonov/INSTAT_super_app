import 'dart:io';

class DataRequestParams {
  final int? id;

  //! Shaxsiy ma'lumot
  final String? companyName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? teamMembers;

  //! Tadqiqot loyihasi
  final String? projectName;
  final String? projectAim;
  final String? benefit;
  final String? aimToUse;

  //! So'raladigan ma'lumot
  final int? dataReportId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? whyNotEnough;
  final String? notEnoughComment;

  //! Xavfsizlik, muhit va muddat
  final int? processingEnvironmentId;
  final DateTime? entryDateFrom;
  final DateTime? entryDateTo;

  //! Natijalar va yakun
  final String? expectation;
  final String? plan;

  const DataRequestParams({
    this.id,
    this.companyName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.teamMembers,
    this.projectName,
    this.projectAim,
    this.benefit,
    this.aimToUse,
    this.dataReportId,
    this.dateFrom,
    this.dateTo,
    this.whyNotEnough,
    this.notEnoughComment,
    this.processingEnvironmentId,
    this.entryDateFrom,
    this.entryDateTo,
    this.expectation,
    this.plan,
  });

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'team_members': teamMembers,
      'project_name': projectName,
      'project_aim': projectAim,
      'benefit': benefit,
      'aimtouse': aimToUse,
      'data_report': dataReportId,
      'date_from': _formatDate(dateFrom),
      'date_to': _formatDate(dateTo),
      'why_not_enough': whyNotEnough,
      'not_enough_comment': notEnoughComment,
      'processing_environment': processingEnvironmentId,
      'entry_date_from': _formatDate(entryDateFrom),
      'entry_date_to': _formatDate(entryDateTo),
      'expectation': expectation,
      'plan': plan,
    };
  }
}

class UploadDataRequestFileParams {
  final int requestId;
  final File file;

  /// `true` — OTM/tashkilot hujjati (`company_file`).
  final bool isCompanyFile;

  const UploadDataRequestFileParams({
    required this.requestId,
    required this.file,
    this.isCompanyFile = false,
  });
}

class DeleteDataRequestFileParams {
  final int requestId;
  final bool isCompanyFile;

  const DeleteDataRequestFileParams({
    required this.requestId,
    this.isCompanyFile = false,
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
