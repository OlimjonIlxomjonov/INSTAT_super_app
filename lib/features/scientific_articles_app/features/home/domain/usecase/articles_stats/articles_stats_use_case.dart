import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/articles_stats/articles_stats_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ArticlesStatsUseCase {
  final ArticlesHomeRepository repository;

  ArticlesStatsUseCase({required this.repository});

  Future<ArticlesStatsEntity> call({required String countType}) {
    return repository.getArticlesStats(countType: countType);
  }
}
