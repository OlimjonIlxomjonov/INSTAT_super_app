import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

abstract class MicroRepository {
  //! Reports cards
  Future<ReportsResponse> getReportsCard();

  //! User data requests
  Future<DataRequestsResponse> getDataRequests({
    required String status,
    required String search,
    int page = 1,
  });
}
