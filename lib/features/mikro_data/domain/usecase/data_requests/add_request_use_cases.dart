import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_detail_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class MicroDataCategoriesUseCase {
  final MicroRepository repository;

  MicroDataCategoriesUseCase({required this.repository});

  Future<List<DataRequestCategoryEntity>> call() {
    return repository.getMicroDataCategories();
  }
}

class RegionsUseCase {
  final MicroRepository repository;

  RegionsUseCase({required this.repository});

  Future<List<RegionEntity>> call() => repository.getRegions();
}

class CreateDataRequestUseCase {
  final MicroRepository repository;

  CreateDataRequestUseCase({required this.repository});

  Future<DataRequestDetailEntity> call(DataRequestParams params) {
    return repository.createDataRequest(params);
  }
}

class UpdateDataRequestUseCase {
  final MicroRepository repository;

  UpdateDataRequestUseCase({required this.repository});

  Future<DataRequestDetailEntity> call(DataRequestParams params) {
    return repository.updateDataRequest(params);
  }
}

class UploadDataRequestFileUseCase {
  final MicroRepository repository;

  UploadDataRequestFileUseCase({required this.repository});

  Future<DataRequestDetailEntity> call(UploadDataRequestFileParams params) {
    return repository.uploadDataRequestFile(params);
  }
}

class SendDataRequestUseCase {
  final MicroRepository repository;

  SendDataRequestUseCase({required this.repository});

  Future<void> call(int requestId) => repository.sendDataRequest(requestId);
}

class GetDataRequestUseCase {
  final MicroRepository repository;

  GetDataRequestUseCase({required this.repository});

  Future<DataRequestDetailEntity> call(int requestId) {
    return repository.getDataRequest(requestId);
  }
}

class DataRequestProcessesUseCase {
  final MicroRepository repository;

  DataRequestProcessesUseCase({required this.repository});

  Future<List<DataRequestProcessEntity>> call(int requestId) {
    return repository.getDataRequestProcesses(requestId);
  }
}
