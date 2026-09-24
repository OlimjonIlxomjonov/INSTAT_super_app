class VacancyTestDirectionEntity {
  final int id;
  final String title;
  final int minScore;
  final int maxScore;

  const VacancyTestDirectionEntity({
    required this.id,
    this.title = '',
    this.minScore = 0,
    this.maxScore = 0,
  });
}
