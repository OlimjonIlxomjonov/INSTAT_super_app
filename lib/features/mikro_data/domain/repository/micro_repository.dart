import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_detail_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_files/report_files_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_variables/report_variables_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

abstract class MicroRepository {
  //! Reports cards
  Future<ReportsResponse> getReportsCard();

  Future<List<ReportsOptionsEntity>> getReportOptions(int reportId);

  //! User data requests
  Future<DataRequestsResponse> getDataRequests({
    required String status,
    required String search,
    int page = 1,
  });

  //! Add request — dropdown ma'lumotlari
  Future<List<DataRequestCategoryEntity>> getMicroDataCategories();

  Future<List<RegionEntity>> getRegions();

  //! Add request — yozish amallari
  Future<DataRequestDetailEntity> getDataRequest(int requestId);

  Future<DataRequestDetailEntity> createDataRequest(DataRequestParams params);

  Future<DataRequestDetailEntity> updateDataRequest(DataRequestParams params);

  Future<DataRequestDetailEntity> uploadDataRequestFile(
    UploadDataRequestFileParams params,
  );

  Future<void> sendDataRequest(int requestId);

  Future<List<DataRequestProcessEntity>> getDataRequestProcesses(int requestId);

  //! Report files
  Future<List<ReportFilesEntity>> getReportFiles({
    required ReportFilesParams params,
  });

  //! Report variables
  Future<List<ReportVariablesEntity>> getReportVariables({
    required ReportVariablesParams params,
  });
}
