import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class EditionArticlesUseCase {
  final ArticlesHomeRepository repository;

  EditionArticlesUseCase({required this.repository});

  Future<List<EditionArticleEntity>> call({required int editionId}) {
    return repository.getEditionArticles(editionId: editionId);
  }
}
