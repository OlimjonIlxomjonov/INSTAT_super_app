import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';

class AddDataRequestState extends Equatable {
  /// Server'dagi so'rov id'si. null bo'lsa hali yaratilmagan (POST kerak).
  final int? requestId;

  //! 1-bosqich
  final String fullName;
  final String companyName;
  final String email;
  final String phoneNumber;

  //! 2-bosqich
  /// Backend to'liq nested obyekt kutgani uchun faqat id emas, butun
  /// kategoriya saqlanadi.
  final DataRequestCategoryEntity? category;
  final SelectedArea? area;
  final String description;
  final String aim;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  /// Serverdagi mavjud fayl (yuklab bo'lingandan keyin).
  final String? fileUrl;
  final String fileName;
  final int? fileSize;

  final bool isSaving;
  final bool isUploadingFile;
  final String? errorMessage;

  //! Tahrirlash rejimi
  final bool isEditMode;
  final bool isLoadingInitialData;
  final String? initialLoadError;

  /// Serverdan kelgan xom qiymatlar. Kategoriya/hudud ro'yxatlari yuklangach
  /// obyektlarga bog'lanadi va tozalanadi — GET faqat id va kod qaytaradi.
  final int? pendingCategoryId;
  final String? pendingRegionCode;
  final String? pendingDistrictCode;

  const AddDataRequestState({
    this.requestId,
    this.fullName = '',
    this.companyName = '',
    this.email = '',
    this.phoneNumber = '',
    this.category,
    this.area,
    this.description = '',
    this.aim = '',
    this.dateFrom,
    this.dateTo,
    this.fileUrl,
    this.fileName = '',
    this.fileSize,
    this.isSaving = false,
    this.isUploadingFile = false,
    this.errorMessage,
    this.isEditMode = false,
    this.isLoadingInitialData = false,
    this.initialLoadError,
    this.pendingCategoryId,
    this.pendingRegionCode,
    this.pendingDistrictCode,
  });

  bool get hasPendingReferences =>
      pendingCategoryId != null ||
      pendingRegionCode != null ||
      pendingDistrictCode != null;

  int? get categoryId => category?.id;

  bool get hasFile => fileName.isNotEmpty || (fileUrl?.isNotEmpty ?? false);

  /// Dizaynda yulduzcha bilan belgilangan maydonlar.
  bool get isStepOneValid => fullName.trim().isNotEmpty;

  bool get isStepTwoValid =>
      category != null && area != null && dateFrom != null;

  bool get canSubmit => isStepOneValid && isStepTwoValid;

  AddDataRequestState copyWith({
    int? requestId,
    String? fullName,
    String? companyName,
    String? email,
    String? phoneNumber,
    DataRequestCategoryEntity? category,
    SelectedArea? area,
    String? description,
    String? aim,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    bool? isSaving,
    bool? isUploadingFile,
    String? errorMessage,
    bool clearError = false,
    bool? isEditMode,
    bool? isLoadingInitialData,
    String? initialLoadError,
    int? pendingCategoryId,
    String? pendingRegionCode,
    String? pendingDistrictCode,
    bool clearPendingReferences = false,
    bool clearInitialLoadError = false,
  }) {
    return AddDataRequestState(
      requestId: requestId ?? this.requestId,
      fullName: fullName ?? this.fullName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      category: category ?? this.category,
      area: area ?? this.area,
      description: description ?? this.description,
      aim: aim ?? this.aim,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      isSaving: isSaving ?? this.isSaving,
      isUploadingFile: isUploadingFile ?? this.isUploadingFile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isEditMode: isEditMode ?? this.isEditMode,
      isLoadingInitialData: isLoadingInitialData ?? this.isLoadingInitialData,
      initialLoadError: clearInitialLoadError
          ? null
          : (initialLoadError ?? this.initialLoadError),
      pendingCategoryId: clearPendingReferences
          ? null
          : (pendingCategoryId ?? this.pendingCategoryId),
      pendingRegionCode: clearPendingReferences
          ? null
          : (pendingRegionCode ?? this.pendingRegionCode),
      pendingDistrictCode: clearPendingReferences
          ? null
          : (pendingDistrictCode ?? this.pendingDistrictCode),
    );
  }

  @override
  List<Object?> get props => [
    requestId,
    fullName,
    companyName,
    email,
    phoneNumber,
    category,
    area,
    description,
    aim,
    dateFrom,
    dateTo,
    fileUrl,
    fileName,
    fileSize,
    isSaving,
    isUploadingFile,
    errorMessage,
    isEditMode,
    isLoadingInitialData,
    initialLoadError,
    pendingCategoryId,
    pendingRegionCode,
    pendingDistrictCode,
  ];
}
