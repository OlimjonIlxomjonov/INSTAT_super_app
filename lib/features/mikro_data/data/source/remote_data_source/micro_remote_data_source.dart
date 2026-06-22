import 'package:my_template/features/mikro_data/data/model/reports/reports_response_model.dart';

abstract class MicroRemoteDataSource {
  //! Reports
  Future<ReportsResponseModel> fetchReportsCard();
}
