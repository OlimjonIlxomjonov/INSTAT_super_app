import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_category_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_detail_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_process_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_requests_response_model.dart';
import 'package:my_template/features/mikro_data/data/model/regions/region_model.dart';
import 'package:my_template/features/mikro_data/data/model/report_files/report_files_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_options_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_response_model.dart';

abstract class MicroRemoteDataSource {
  //! Reports
  Future<ReportsResponseModel> fetchReportsCard();

  Future<List<ReportsOptionsModel>> fetchReportOptions(int reportId);

  //! User data requests
  Future<DataRequestsResponseModel> fetchDataRequests({
    required String status,
    required String search,
    int page = 1,
  });

  //! Add request — dropdown ma'lumotlari
  Future<List<DataRequestCategoryModel>> fetchMicroDataCategories();

  Future<List<RegionModel>> fetchRegions();

  //! Add request — yozish amallari

  Future<DataRequestDetailModel> fetchDataRequest(int requestId);

  Future<DataRequestDetailModel> createDataRequest(DataRequestParams params);

  Future<DataRequestDetailModel> updateDataRequest(DataRequestParams params);

  Future<DataRequestDetailModel> uploadDataRequestFile(
    UploadDataRequestFileParams params,
  );

  Future<void> sendDataRequest(int requestId);

  Future<List<DataRequestProcessModel>> fetchDataRequestProcesses(
    int requestId,
  );

  Future<List<ReportFilesModel>> fetchReportFiles({
    required ReportFilesParams params,
  });
}
