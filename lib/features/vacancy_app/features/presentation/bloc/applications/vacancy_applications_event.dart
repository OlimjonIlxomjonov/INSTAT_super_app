import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';

abstract class VacancyApplicationsEvent {
  const VacancyApplicationsEvent();
}

class FetchVacancyApplicationsEvent extends VacancyApplicationsEvent {
  final VacancyApplicationListParams params;

  const FetchVacancyApplicationsEvent({
    this.params = const VacancyApplicationListParams(),
  });
}

class LoadMoreVacancyApplicationsEvent extends VacancyApplicationsEvent {
  const LoadMoreVacancyApplicationsEvent();
}
