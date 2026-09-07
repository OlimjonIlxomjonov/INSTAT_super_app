import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_report_ref_entity.dart';

class AddDataRequestState extends Equatable {
  /// Server'dagi so'rov id'si. null bo'lsa hali yaratilmagan (POST kerak).
  final int? requestId;

  //! 1-bosqich — Shaxsiy ma'lumot
  final String companyName;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String teamMembers;

  //! 1-bosqich — Tadqiqot loyihasi
  final String projectName;
  final String projectAim;
  final String benefit;
  final String aimToUse;

  //! 1-bosqich — So'raladigan ma'lumot
  final DataReportRefEntity? dataReport;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String whyNotEnough;
  final String notEnoughComment;

  //! 3-bosqich — Xavfsizlik, muhit va muddat
  final int? processingEnvironmentId;
  final String processingEnvironmentName;
  final DateTime? entryDateFrom;
  final DateTime? entryDateTo;

  //! 3-bosqich — Natijalar va yakun
  final String expectation;
  final String plan;

  //! 2-bosqich — Tadqiqotni tasdiqlangan hujjati
  final String? fileUrl;
  final String fileName;
  final int? fileSize;

  //! 2-bosqich — OTM / tashkilot hujjati
  final String? companyFileUrl;
  final String companyFileName;
  final int? companyFileSize;

  final bool isSaving;
  final bool isUploadingFile;
  final bool isUploadingCompanyFile;
  final String? errorMessage;

  //! Tahrirlash rejimi
  final bool isEditMode;
  final bool isLoadingInitialData;
  final String? initialLoadError;

  const AddDataRequestState({
    this.requestId,
    this.companyName = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.teamMembers = '',
    this.projectName = '',
    this.projectAim = '',
    this.benefit = '',
    this.aimToUse = '',
    this.dataReport,
    this.dateFrom,
    this.dateTo,
    this.whyNotEnough = '',
    this.notEnoughComment = '',
    this.processingEnvironmentId,
    this.processingEnvironmentName = '',
    this.entryDateFrom,
    this.entryDateTo,
    this.expectation = '',
    this.plan = '',
    this.fileUrl,
    this.fileName = '',
    this.fileSize,
    this.companyFileUrl,
    this.companyFileName = '',
    this.companyFileSize,
    this.isSaving = false,
    this.isUploadingFile = false,
    this.isUploadingCompanyFile = false,
    this.errorMessage,
    this.isEditMode = false,
    this.isLoadingInitialData = false,
    this.initialLoadError,
  });

  bool get hasFile => fileName.isNotEmpty || (fileUrl?.isNotEmpty ?? false);

  bool get hasCompanyFile =>
      companyFileName.isNotEmpty || (companyFileUrl?.isNotEmpty ?? false);

  /// Backend POST'da shu maydonlarning barchasini majburiy qiladi —
  /// qoralama ham shusiz saqlanmaydi.
  bool get isStepOneValid =>
      companyName.trim().isNotEmpty &&
      fullName.trim().isNotEmpty &&
      phoneNumber.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      projectName.trim().isNotEmpty &&
      projectAim.trim().isNotEmpty &&
      benefit.trim().isNotEmpty &&
      aimToUse.trim().isNotEmpty &&
      dataReport != null &&
      dateFrom != null &&
      dateTo != null &&
      whyNotEnough.trim().isNotEmpty &&
      notEnoughComment.trim().isNotEmpty;

  bool get canSaveDraft => isStepOneValid;

  /// Majburiy maydonlar faqat 1-bosqichda — qolganlari ixtiyoriy.
  bool get canSubmit => isStepOneValid;

  AddDataRequestState copyWith({
    int? requestId,
    String? companyName,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? teamMembers,
    String? projectName,
    String? projectAim,
    String? benefit,
    String? aimToUse,
    DataReportRefEntity? dataReport,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? whyNotEnough,
    String? notEnoughComment,
    int? processingEnvironmentId,
    String? processingEnvironmentName,
    DateTime? entryDateFrom,
    DateTime? entryDateTo,
    String? expectation,
    String? plan,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    bool clearFile = false,
    String? companyFileUrl,
    String? companyFileName,
    int? companyFileSize,
    bool clearCompanyFile = false,
    bool? isSaving,
    bool? isUploadingFile,
    bool? isUploadingCompanyFile,
    String? errorMessage,
    bool clearError = false,
    bool? isEditMode,
    bool? isLoadingInitialData,
    String? initialLoadError,
    bool clearInitialLoadError = false,
  }) {
    return AddDataRequestState(
      requestId: requestId ?? this.requestId,
      companyName: companyName ?? this.companyName,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      teamMembers: teamMembers ?? this.teamMembers,
      projectName: projectName ?? this.projectName,
      projectAim: projectAim ?? this.projectAim,
      benefit: benefit ?? this.benefit,
      aimToUse: aimToUse ?? this.aimToUse,
      dataReport: dataReport ?? this.dataReport,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      whyNotEnough: whyNotEnough ?? this.whyNotEnough,
      notEnoughComment: notEnoughComment ?? this.notEnoughComment,
      processingEnvironmentId:
          processingEnvironmentId ?? this.processingEnvironmentId,
      processingEnvironmentName:
          processingEnvironmentName ?? this.processingEnvironmentName,
      entryDateFrom: entryDateFrom ?? this.entryDateFrom,
      entryDateTo: entryDateTo ?? this.entryDateTo,
      expectation: expectation ?? this.expectation,
      plan: plan ?? this.plan,
      fileUrl: clearFile ? null : (fileUrl ?? this.fileUrl),
      fileName: clearFile ? '' : (fileName ?? this.fileName),
      fileSize: clearFile ? null : (fileSize ?? this.fileSize),
      companyFileUrl: clearCompanyFile
          ? null
          : (companyFileUrl ?? this.companyFileUrl),
      companyFileName: clearCompanyFile
          ? ''
          : (companyFileName ?? this.companyFileName),
      companyFileSize: clearCompanyFile
          ? null
          : (companyFileSize ?? this.companyFileSize),
      isSaving: isSaving ?? this.isSaving,
      isUploadingFile: isUploadingFile ?? this.isUploadingFile,
      isUploadingCompanyFile:
          isUploadingCompanyFile ?? this.isUploadingCompanyFile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isEditMode: isEditMode ?? this.isEditMode,
      isLoadingInitialData: isLoadingInitialData ?? this.isLoadingInitialData,
      initialLoadError: clearInitialLoadError
          ? null
          : (initialLoadError ?? this.initialLoadError),
    );
  }

  @override
  List<Object?> get props => [
    requestId,
    companyName,
    fullName,
    phoneNumber,
    email,
    teamMembers,
    projectName,
    projectAim,
    benefit,
    aimToUse,
    dataReport,
    dateFrom,
    dateTo,
    whyNotEnough,
    notEnoughComment,
    processingEnvironmentId,
    processingEnvironmentName,
    entryDateFrom,
    entryDateTo,
    expectation,
    plan,
    fileUrl,
    fileName,
    fileSize,
    companyFileUrl,
    companyFileName,
    companyFileSize,
    isSaving,
    isUploadingFile,
    isUploadingCompanyFile,
    errorMessage,
    isEditMode,
    isLoadingInitialData,
    initialLoadError,
  ];
}
