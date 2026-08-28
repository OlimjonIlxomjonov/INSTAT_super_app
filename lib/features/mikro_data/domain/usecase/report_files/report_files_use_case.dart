import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_files/report_files_entity.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class ReportFilesUseCase {
  final MicroRepository repository;

  ReportFilesUseCase({required this.repository});

  Future<List<ReportFilesEntity>> call({required ReportFilesParams params}) {
    return repository.getReportFiles(params: params);
  }
}
