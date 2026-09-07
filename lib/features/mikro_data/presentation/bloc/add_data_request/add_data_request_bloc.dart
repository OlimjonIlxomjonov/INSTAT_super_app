import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class AddDataRequestBloc extends Bloc<MicroDataEvent, AddDataRequestState> {
  final CreateDataRequestUseCase createUseCase;
  final UpdateDataRequestUseCase updateUseCase;
  final UploadDataRequestFileUseCase uploadFileUseCase;
  final DeleteDataRequestFileUseCase deleteFileUseCase;
  final SendDataRequestUseCase sendUseCase;
  final GetDataRequestUseCase getUseCase;

  AddDataRequestBloc({
    required this.createUseCase,
    required this.updateUseCase,
    required this.uploadFileUseCase,
    required this.deleteFileUseCase,
    required this.sendUseCase,
    required this.getUseCase,
  }) : super(const AddDataRequestState()) {
    on<ResetAddDataRequestEvent>((event, emit) {
      emit(const AddDataRequestState());
    });

    on<UpdateDataRequestFieldEvent>((event, emit) {
      emit(
        state.copyWith(
          companyName: event.companyName,
          fullName: event.fullName,
          email: event.email,
          phoneNumber: event.phoneNumber,
          teamMembers: event.teamMembers,
          projectName: event.projectName,
          projectAim: event.projectAim,
          benefit: event.benefit,
          aimToUse: event.aimToUse,
          dataReport: event.dataReport,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
          whyNotEnough: event.whyNotEnough,
          notEnoughComment: event.notEnoughComment,
          processingEnvironmentId: event.processingEnvironmentId,
          processingEnvironmentName: event.processingEnvironmentName,
          entryDateFrom: event.entryDateFrom,
          entryDateTo: event.entryDateTo,
          expectation: event.expectation,
          plan: event.plan,
        ),
      );
    });

    on<LoadDataRequestForEditEvent>(_onLoadForEdit);
    on<SaveDataRequestDraftEvent>(_onSaveDraft);
    on<UploadDataRequestFileEvent>(_onUploadFile);
    on<DeleteDataRequestFileEvent>(_onDeleteFile);
    on<SubmitDataRequestEvent>(_onSubmit);
  }

  Future<void> _onLoadForEdit(
    LoadDataRequestForEditEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        isEditMode: true,
        isLoadingInitialData: true,
        clearInitialLoadError: true,
      ),
    );
    try {
      final detail = await getUseCase(event.requestId);
      emit(
        AddDataRequestState(
          requestId: detail.id,
          companyName: detail.companyName ?? '',
          fullName: detail.fullName,
          email: detail.email ?? '',
          phoneNumber: detail.phoneNumber ?? '',
          teamMembers: detail.teamMembers ?? '',
          projectName: detail.projectName ?? '',
          projectAim: detail.projectAim ?? '',
          benefit: detail.benefit ?? '',
          aimToUse: detail.aimToUse ?? '',
          dataReport: detail.dataReport,
          dateFrom: detail.dateFrom,
          dateTo: detail.dateTo,
          whyNotEnough: detail.whyNotEnough ?? '',
          notEnoughComment: detail.notEnoughComment ?? '',
          processingEnvironmentId: detail.processingEnvironmentId,
          processingEnvironmentName: detail.processingEnvironmentName ?? '',
          entryDateFrom: detail.entryDateFrom,
          entryDateTo: detail.entryDateTo,
          expectation: detail.expectation ?? '',
          plan: detail.plan ?? '',
          fileUrl: detail.fileUrl,
          fileName: detail.fileName,
          fileSize: detail.fileSize,
          companyFileUrl: detail.companyFileUrl,
          companyFileName: detail.companyFileName,
          companyFileSize: detail.companyFileSize,
          isEditMode: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingInitialData: false,
          initialLoadError: e.toString(),
        ),
      );
    }
  }

  /// So'rovni serverga yozadi va id'sini qaytaradi.
  /// Hali yaratilmagan bo'lsa POST, aks holda PUT.
  Future<int> _persist(AddDataRequestState current) async {
    final params = DataRequestParams(
      id: current.requestId,
      companyName: _orNull(current.companyName),
      fullName: _orNull(current.fullName),
      email: _orNull(current.email),
      phoneNumber: _orNull(current.phoneNumber),
      teamMembers: _orNull(current.teamMembers),
      projectName: _orNull(current.projectName),
      projectAim: _orNull(current.projectAim),
      benefit: _orNull(current.benefit),
      aimToUse: _orNull(current.aimToUse),
      dataReportId: current.dataReport?.id,
      dateFrom: current.dateFrom,
      dateTo: current.dateTo,
      whyNotEnough: _orNull(current.whyNotEnough),
      notEnoughComment: _orNull(current.notEnoughComment),
      processingEnvironmentId: current.processingEnvironmentId,
      entryDateFrom: current.entryDateFrom,
      entryDateTo: current.entryDateTo,
      expectation: _orNull(current.expectation),
      plan: _orNull(current.plan),
    );

    if (current.requestId == null || current.requestId == 0) {
      final created = await createUseCase(params);
      return created.id;
    }
    await updateUseCase(params);
    return current.requestId!;
  }

  static String? _orNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _onSaveDraft(
    SaveDataRequestDraftEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      final id = await _persist(state);
      emit(state.copyWith(requestId: id, isSaving: false));
      event.onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
      event.onError?.call(e);
    }
  }

  Future<void> _onUploadFile(
    UploadDataRequestFileEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    final isCompany = event.isCompanyFile;
    emit(
      state.copyWith(
        isUploadingFile: isCompany ? null : true,
        isUploadingCompanyFile: isCompany ? true : null,
        clearError: true,
      ),
    );
    try {
      // Oxirgi tahrirlarni saqlab olamiz, so'ng faylni yuklaymiz.
      final id = await _persist(state);

      var detail = await uploadFileUseCase(
        UploadDataRequestFileParams(
          requestId: id,
          file: event.file,
          isCompanyFile: isCompany,
        ),
      );

      // Yuklash javobi fayl manzilini qaytarmasligi mumkin — usiz kartani
      // bosganda ochib bo'lmaydi, shuning uchun to'liq obyektni olamiz.
      final uploadedUrl = isCompany ? detail.companyFileUrl : detail.fileUrl;
      if (uploadedUrl == null || uploadedUrl.isEmpty) {
        detail = await getUseCase(id);
      }

      emit(
        state.copyWith(
          requestId: id,
          isUploadingFile: isCompany ? null : false,
          isUploadingCompanyFile: isCompany ? false : null,
          fileUrl: isCompany ? null : detail.fileUrl,
          fileName: isCompany
              ? null
              : (detail.fileName.isNotEmpty ? detail.fileName : event.fileName),
          fileSize: isCompany ? null : (detail.fileSize ?? event.fileSize),
          companyFileUrl: isCompany ? detail.companyFileUrl : null,
          companyFileName: isCompany
              ? (detail.companyFileName.isNotEmpty
                    ? detail.companyFileName
                    : event.fileName)
              : null,
          companyFileSize: isCompany
              ? (detail.companyFileSize ?? event.fileSize)
              : null,
        ),
      );
      event.onSuccess?.call();
    } catch (e) {
      emit(
        state.copyWith(
          isUploadingFile: isCompany ? null : false,
          isUploadingCompanyFile: isCompany ? false : null,
          errorMessage: e.toString(),
        ),
      );
      event.onError?.call(e);
    }
  }

  Future<void> _onDeleteFile(
    DeleteDataRequestFileEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    final id = state.requestId;
    if (id == null || id == 0) return;

    final isCompany = event.isCompanyFile;
    emit(
      state.copyWith(
        isUploadingFile: isCompany ? null : true,
        isUploadingCompanyFile: isCompany ? true : null,
        clearError: true,
      ),
    );
    try {
      await deleteFileUseCase(
        DeleteDataRequestFileParams(requestId: id, isCompanyFile: isCompany),
      );
      emit(
        state.copyWith(
          isUploadingFile: isCompany ? null : false,
          isUploadingCompanyFile: isCompany ? false : null,
          clearFile: !isCompany,
          clearCompanyFile: isCompany,
        ),
      );
      event.onSuccess?.call();
    } catch (e) {
      emit(
        state.copyWith(
          isUploadingFile: isCompany ? null : false,
          isUploadingCompanyFile: isCompany ? false : null,
          errorMessage: e.toString(),
        ),
      );
      event.onError?.call(e);
    }
  }

  Future<void> _onSubmit(
    SubmitDataRequestEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      // Yuborishdan oldin oxirgi o'zgarishlarni saqlab olamiz.
      final id = await _persist(state);
      await sendUseCase(id);
      emit(state.copyWith(requestId: id, isSaving: false));
      event.onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
      event.onError?.call(e);
    }
  }
}
