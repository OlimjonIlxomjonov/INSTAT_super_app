import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/features/vacancy_app/features/data/source/remote_data_source/vacancy_remote_data_source.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/repository/vacancy_repository.dart';

class VacancyRepoImpl implements VacancyRepository {
  final VacancyRemoteDataSource _remoteDataSource;

  VacancyRepoImpl(this._remoteDataSource);

  @override
  Future<VacancyListResponse> getVacancies({
    required VacancyListParams params,
  }) {
    return _remoteDataSource.fetchVacancies(params: params);
  }

  @override
  Future<VacancyApplicationListResponse> getApplications({
    required VacancyApplicationListParams params,
  }) {
    return _remoteDataSource.fetchApplications(params: params);
  }

  @override
  Future<List<VacancyProcessEntity>> getProcesses({
    required int applicationId,
  }) {
    return _remoteDataSource.fetchProcesses(applicationId: applicationId);
  }

  @override
  Future<void> applyToVacancy({required ApplyVacancyParams params}) {
    return _remoteDataSource.applyToVacancy(params: params);
  }
}
