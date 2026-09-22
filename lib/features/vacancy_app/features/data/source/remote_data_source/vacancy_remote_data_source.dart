import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/features/vacancy_app/features/data/model/application/vacancy_application_list_response_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/application/vacancy_process_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/vacancy/vacancy_list_response_model.dart';

abstract class VacancyRemoteDataSource {
  Future<VacancyListResponseModel> fetchVacancies({
    required VacancyListParams params,
  });

  Future<VacancyApplicationListResponseModel> fetchApplications({
    required VacancyApplicationListParams params,
  });

  Future<List<VacancyProcessModel>> fetchProcesses({
    required int applicationId,
  });

  Future<void> applyToVacancy({required ApplyVacancyParams params});
}
