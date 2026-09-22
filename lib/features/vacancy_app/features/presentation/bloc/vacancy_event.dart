import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';

abstract class VacancyEvent {
  const VacancyEvent();
}

class FetchVacanciesEvent extends VacancyEvent {
  final VacancyListParams params;

  const FetchVacanciesEvent({this.params = const VacancyListParams()});
}

class LoadMoreVacanciesEvent extends VacancyEvent {
  const LoadMoreVacanciesEvent();
}
