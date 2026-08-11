import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class GetReportOptionsUseCase {
  final MicroRepository repository;

  GetReportOptionsUseCase({required this.repository});

  Future<List<ReportsOptionsEntity>> call(int reportId) {
    return repository.getReportOptions(reportId);
  }
}
