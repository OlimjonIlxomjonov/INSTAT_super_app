import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class AddDataRequestBloc extends Bloc<MicroDataEvent, AddDataRequestState> {
  final CreateDataRequestUseCase createUseCase;
  final UpdateDataRequestUseCase updateUseCase;
  final UploadDataRequestFileUseCase uploadFileUseCase;
  final SendDataRequestUseCase sendUseCase;
  final GetDataRequestUseCase getUseCase;

  AddDataRequestBloc({
    required this.createUseCase,
    required this.updateUseCase,
    required this.uploadFileUseCase,
    required this.sendUseCase,
    required this.getUseCase,
  }) : super(const AddDataRequestState()) {
    on<ResetAddDataRequestEvent>((event, emit) {
      emit(const AddDataRequestState());
    });

    on<UpdateDataRequestFieldEvent>((event, emit) {
      emit(
        state.copyWith(
          fullName: event.fullName,
          companyName: event.companyName,
          email: event.email,
          phoneNumber: event.phoneNumber,
          category: event.category,
          area: event.area,
          description: event.description,
          aim: event.aim,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        ),
      );
    });

    on<LoadDataRequestForEditEvent>(_onLoadForEdit);
    on<ResolveDataRequestReferencesEvent>(_onResolveReferences);
    on<SaveDataRequestDraftEvent>(_onSaveDraft);
    on<UploadDataRequestFileEvent>(_onUploadFile);
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
          fullName: detail.fullName,
          companyName: detail.companyName ?? '',
          email: detail.email ?? '',
          phoneNumber: detail.phoneNumber ?? '',
          description: detail.description ?? '',
          aim: detail.aim ?? '',
          dateFrom: detail.dateFrom,
          dateTo: detail.dateTo,
          fileUrl: detail.fileUrl,
          fileName: detail.fileName,
          fileSize: detail.fileSize,
          isEditMode: true,
          // Kategoriya va hudud id/kod ko'rinishida keladi — ro'yxatlar
          // yuklangach obyektlarga bog'lanadi.
          pendingCategoryId: detail.categoryId,
          pendingRegionCode: detail.regionCode,
          pendingDistrictCode: detail.districtCode,
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

  void _onResolveReferences(
    ResolveDataRequestReferencesEvent event,
    Emitter<AddDataRequestState> emit,
  ) {
    if (!state.hasPendingReferences) return;

    DataRequestCategoryEntity? category = state.category;
    final pendingCategoryId = state.pendingCategoryId;
    if (pendingCategoryId != null) {
      for (final item in event.categories) {
        if (item.id == pendingCategoryId) {
          category = item;
          break;
        }
      }
    }

    SelectedArea? area = state.area;
    final pendingRegionCode = state.pendingRegionCode;
    if (pendingRegionCode != null) {
      for (final region in event.regions) {
        if (region.code != pendingRegionCode) continue;
        DistrictEntity? district;
        for (final item in region.districts) {
          if (item.code == state.pendingDistrictCode) {
            district = item;
            break;
          }
        }
        area = SelectedArea(region: region, district: district);
        break;
      }
    } else if (state.isEditMode && state.pendingDistrictCode == null) {
      // Serverda hudud bo'sh bo'lsa "Respublika bo'yicha" deb qabul qilamiz.
      area = const SelectedArea();
    }

    emit(
      state.copyWith(
        category: category,
        area: area,
        clearPendingReferences: true,
      ),
    );
  }

  /// So'rovni serverga yozadi va id'sini qaytaradi.
  /// Hali yaratilmagan bo'lsa POST, aks holda PUT — article'dagi
  /// create/update mantig'i bilan bir xil.
  Future<int> _persist(AddDataRequestState current) async {
    final params = DataRequestParams(
      id: current.requestId,
      fullName: current.fullName.trim(),
      companyName: _orNull(current.companyName),
      category: current.category,
      description: _orNull(current.description),
      aim: _orNull(current.aim),
      regionCode: current.area?.regionCode,
      districtCode: current.area?.districtCode,
      dateFrom: current.dateFrom,
      dateTo: current.dateTo,
      phoneNumber: _orNull(current.phoneNumber),
      email: _orNull(current.email),
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
    emit(state.copyWith(isUploadingFile: true, clearError: true));
    try {
      // Fayl yuklash endpointi id talab qiladi, lekin foydalanuvchi hali
      // hech narsa saqlamagan bo'lishi mumkin — avval qoralamani yaratamiz.
      final id = await _persist(state);

      final detail = await uploadFileUseCase(
        UploadDataRequestFileParams(requestId: id, file: event.file),
      );

      emit(
        state.copyWith(
          requestId: id,
          isUploadingFile: false,
          fileUrl: detail.fileUrl,
          // Backend fayl nomini bo'sh qaytarsa, tanlangan nomga tushamiz.
          fileName: detail.fileName.isNotEmpty
              ? detail.fileName
              : event.fileName,
          fileSize: detail.fileSize ?? event.fileSize,
        ),
      );
      event.onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isUploadingFile: false, errorMessage: e.toString()));
      event.onError?.call(e);
    }
  }

  Future<void> _onSubmit(
    SubmitDataRequestEvent event,
    Emitter<AddDataRequestState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      // Yuborishdan oldin oxirgi o'zgarishlarni saqlab olamiz, aks holda
      // foydalanuvchi 3-bosqichda ko'rgan narsa serverga yetib bormaydi.
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
