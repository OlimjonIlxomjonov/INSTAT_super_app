import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class ReportsUseCase {
  final MicroRepository repository;

  ReportsUseCase({required this.repository});

  Future<ReportsResponse> call() {
    return repository.getReportsCard();
  }
}
