import 'package:my_template/features/mikro_data/data/model/data_requests/data_requests_response_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_response_model.dart';

abstract class MicroRemoteDataSource {
  //! Reports
  Future<ReportsResponseModel> fetchReportsCard();

  //! User data requests
  Future<DataRequestsResponseModel> fetchDataRequests({
    required String status,
    required String search,
    int page = 1,
  });
}
