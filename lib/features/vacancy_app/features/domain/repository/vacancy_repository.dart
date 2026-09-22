import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';

abstract class VacancyRepository {
  Future<VacancyListResponse> getVacancies({required VacancyListParams params});

  Future<VacancyApplicationListResponse> getApplications({
    required VacancyApplicationListParams params,
  });

  Future<List<VacancyProcessEntity>> getProcesses({required int applicationId});

  Future<void> applyToVacancy({required ApplyVacancyParams params});
}
