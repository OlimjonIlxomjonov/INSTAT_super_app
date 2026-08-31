import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_variables/report_variables_entity.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class ReportVariablesUseCase {
  final MicroRepository repository;

  ReportVariablesUseCase({required this.repository});

  Future<List<ReportVariablesEntity>> call({
    required ReportVariablesParams params,
  }) {
    return repository.getReportVariables(params: params);
  }
}
