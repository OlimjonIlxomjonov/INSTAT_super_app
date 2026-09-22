class VacancyListParams {
  final String search;
  final String? employmentType;
  final int page;

  const VacancyListParams({
    this.search = '',
    this.employmentType,
    this.page = 1,
  });
}
