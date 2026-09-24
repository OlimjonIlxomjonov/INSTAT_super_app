import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_test_direction_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/repository/vacancy_repository.dart';

class GetVacanciesUseCase {
  final VacancyRepository repository;

  GetVacanciesUseCase({required this.repository});

  Future<VacancyListResponse> call({required VacancyListParams params}) {
    return repository.getVacancies(params: params);
  }
}

class GetVacancyApplicationsUseCase {
  final VacancyRepository repository;

  GetVacancyApplicationsUseCase({required this.repository});

  Future<VacancyApplicationListResponse> call({
    required VacancyApplicationListParams params,
  }) {
    return repository.getApplications(params: params);
  }
}

class GetVacancyProcessesUseCase {
  final VacancyRepository repository;

  GetVacancyProcessesUseCase({required this.repository});

  Future<List<VacancyProcessEntity>> call({required int applicationId}) {
    return repository.getProcesses(applicationId: applicationId);
  }
}

class ApplyVacancyUseCase {
  final VacancyRepository repository;

  ApplyVacancyUseCase({required this.repository});

  Future<void> call({required ApplyVacancyParams params}) {
    return repository.applyToVacancy(params: params);
  }
}

class GetVacancyTestDirectionsUseCase {
  final VacancyRepository repository;

  GetVacancyTestDirectionsUseCase({required this.repository});

  Future<List<VacancyTestDirectionEntity>> call({required int vacancyId}) {
    return repository.getTestDirections(vacancyId: vacancyId);
  }
}
