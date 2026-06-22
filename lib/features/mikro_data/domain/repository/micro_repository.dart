import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

abstract class MicroRepository {
  //! Reports cards
  Future<ReportsResponse> getReportsCard();
}
