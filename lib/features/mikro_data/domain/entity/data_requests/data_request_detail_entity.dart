import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_report_ref_entity.dart';

/// `POST data-requests/`, `PUT data-requests/{id}/` va fayl yuklash
/// javoblaridagi to'liq obyekt.
class DataRequestDetailEntity {
  final int id;

  //! Shaxsiy ma'lumot
  final String? companyName;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? teamMembers;

  //! Tadqiqot loyihasi
  final String? projectName;
  final String? projectAim;
  final String? benefit;
  final String? aimToUse;

  //! So'raladigan ma'lumot
  final DataReportRefEntity? dataReport;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? whyNotEnough;
  final String? notEnoughComment;

  //! Xavfsizlik, muhit va muddat
  final int? processingEnvironmentId;
  final String? processingEnvironmentName;
  final DateTime? entryDateFrom;
  final DateTime? entryDateTo;

  //! Natijalar va yakun
  final String? expectation;
  final String? plan;

  final String status;
  final DateTime? createdAt;

  //! Tadqiqotni tasdiqlangan hujjati
  final String? fileUrl;
  final String fileName;
  final int? fileSize;
  final String fileExtension;

  //! OTM / tashkilot hujjati
  final String? companyFileUrl;
  final String companyFileName;
  final int? companyFileSize;
  final String companyFileExtension;

  const DataRequestDetailEntity({
    required this.id,
    required this.fullName,
    this.companyName,
    this.email,
    this.phoneNumber,
    this.teamMembers,
    this.projectName,
    this.projectAim,
    this.benefit,
    this.aimToUse,
    this.dataReport,
    this.dateFrom,
    this.dateTo,
    this.whyNotEnough,
    this.notEnoughComment,
    this.processingEnvironmentId,
    this.processingEnvironmentName,
    this.entryDateFrom,
    this.entryDateTo,
    this.expectation,
    this.plan,
    this.status = 'draft',
    this.createdAt,
    this.fileUrl,
    this.fileName = '',
    this.fileSize,
    this.fileExtension = '',
    this.companyFileUrl,
    this.companyFileName = '',
    this.companyFileSize,
    this.companyFileExtension = '',
  });

  bool get hasFile => fileName.isNotEmpty || (fileUrl?.isNotEmpty ?? false);

  bool get hasCompanyFile =>
      companyFileName.isNotEmpty || (companyFileUrl?.isNotEmpty ?? false);
}
