import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/data/source/remote_data_source/micro_remote_data_source.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_detail_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_files/report_files_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_variables/report_variables_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class MicroRepoImpl implements MicroRepository {
  final MicroRemoteDataSource _remoteDataSource;

  MicroRepoImpl({required MicroRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ReportsResponse> getReportsCard() {
    return _remoteDataSource.fetchReportsCard();
  }

  @override
  Future<List<ReportsOptionsEntity>> getReportOptions(int reportId) {
    return _remoteDataSource.fetchReportOptions(reportId);
  }

  @override
  Future<DataRequestsResponse> getDataRequests({
    required String status,
    required String search,
    int page = 1,
  }) {
    return _remoteDataSource.fetchDataRequests(
      status: status,
      search: search,
      page: page,
    );
  }

  @override
  Future<List<DataRequestCategoryEntity>> getMicroDataCategories() {
    return _remoteDataSource.fetchMicroDataCategories();
  }

  @override
  Future<List<RegionEntity>> getRegions() {
    return _remoteDataSource.fetchRegions();
  }

  @override
  Future<DataRequestDetailEntity> getDataRequest(int requestId) {
    return _remoteDataSource.fetchDataRequest(requestId);
  }

  @override
  Future<DataRequestDetailEntity> createDataRequest(DataRequestParams params) {
    return _remoteDataSource.createDataRequest(params);
  }

  @override
  Future<DataRequestDetailEntity> updateDataRequest(DataRequestParams params) {
    return _remoteDataSource.updateDataRequest(params);
  }

  @override
  Future<DataRequestDetailEntity> uploadDataRequestFile(
    UploadDataRequestFileParams params,
  ) {
    return _remoteDataSource.uploadDataRequestFile(params);
  }

  @override
  Future<void> sendDataRequest(int requestId) {
    return _remoteDataSource.sendDataRequest(requestId);
  }

  @override
  Future<List<DataRequestProcessEntity>> getDataRequestProcesses(
    int requestId,
  ) {
    return _remoteDataSource.fetchDataRequestProcesses(requestId);
  }

  @override
  Future<List<ReportFilesEntity>> getReportFiles({
    required ReportFilesParams params,
  }) {
    return _remoteDataSource.fetchReportFiles(params: params);
  }

  @override
  Future<List<ReportVariablesEntity>> getReportVariables({
    required ReportVariablesParams params,
  }) {
    return _remoteDataSource.fetchReportVariables(params: params);
  }
}
