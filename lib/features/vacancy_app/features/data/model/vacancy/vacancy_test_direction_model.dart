import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_test_direction_entity.dart';

class VacancyTestDirectionModel extends VacancyTestDirectionEntity {
  const VacancyTestDirectionModel({
    required super.id,
    super.title,
    super.minScore,
    super.maxScore,
  });

  factory VacancyTestDirectionModel.fromJson(Map<String, dynamic> json) {
    final direction = json['test_direction'];
    final source = direction is Map<String, dynamic> ? direction : json;
    return VacancyTestDirectionModel(
      id: source['id'] ?? 0,
      title: source['title'] ?? '',
      minScore: (source['min_score'] as num?)?.toInt() ?? 0,
      maxScore: (source['max_score'] as num?)?.toInt() ?? 0,
    );
  }
}
