import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';

class MicroDataEvent {
  const MicroDataEvent();
}

//! add request — wizard
class ResetAddDataRequestEvent extends MicroDataEvent {}

/// Mavjud qoralamani tahrirlash uchun ochish.
class LoadDataRequestForEditEvent extends MicroDataEvent {
  final int requestId;

  const LoadDataRequestForEditEvent({required this.requestId});
}

/// Kategoriya/hudud ro'yxatlari yuklangach, serverdan kelgan id va kodlarni
/// obyektlarga bog'lash uchun.
class ResolveDataRequestReferencesEvent extends MicroDataEvent {
  final List<DataRequestCategoryEntity> categories;
  final List<RegionEntity> regions;

  const ResolveDataRequestReferencesEvent({
    required this.categories,
    required this.regions,
  });
}

class UpdateDataRequestFieldEvent extends MicroDataEvent {
  final String? fullName;
  final String? companyName;
  final String? email;
  final String? phoneNumber;
  final DataRequestCategoryEntity? category;
  final SelectedArea? area;
  final String? description;
  final String? aim;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const UpdateDataRequestFieldEvent({
    this.fullName,
    this.companyName,
    this.email,
    this.phoneNumber,
    this.category,
    this.area,
    this.description,
    this.aim,
    this.dateFrom,
    this.dateTo,
  });
}

class SaveDataRequestDraftEvent extends MicroDataEvent {
  final VoidCallback? onSuccess;
  final void Function(Object error)? onError;

  const SaveDataRequestDraftEvent({this.onSuccess, this.onError});
}

class UploadDataRequestFileEvent extends MicroDataEvent {
  final File file;
  final String fileName;
  final int fileSize;
  final VoidCallback? onSuccess;
  final void Function(Object error)? onError;

  const UploadDataRequestFileEvent({
    required this.file,
    required this.fileName,
    required this.fileSize,
    this.onSuccess,
    this.onError,
  });
}

class SubmitDataRequestEvent extends MicroDataEvent {
  final VoidCallback? onSuccess;
  final void Function(Object error)? onError;

  const SubmitDataRequestEvent({this.onSuccess, this.onError});
}

//! reports
class ReportsEvent extends MicroDataEvent {}

//! add request — dropdown ma'lumotlari
class MicroDataCategoriesEvent extends MicroDataEvent {
  const MicroDataCategoriesEvent();
}

class RegionsEvent extends MicroDataEvent {
  const RegionsEvent();
}

//! so'rov jarayonlari
class DataRequestProcessesEvent extends MicroDataEvent {
  final int requestId;

  const DataRequestProcessesEvent({required this.requestId});
}

//! user data requests
class DataRequestsEvent extends MicroDataEvent {
  /// Bo'sh string => barcha statuslar.
  final String status;
  final String search;
  final int page;
  final bool isLoadMore;

  const DataRequestsEvent({
    required this.status,
    required this.search,
    this.page = 1,
    this.isLoadMore = false,
  });
}
