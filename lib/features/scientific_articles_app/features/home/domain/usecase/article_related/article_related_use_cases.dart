import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_page_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_quote/article_quote_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ArticlesByAuthorUseCase {
  final ArticlesHomeRepository repository;

  ArticlesByAuthorUseCase({required this.repository});

  Future<List<ArticleBriefEntity>> call(int reviewId) =>
      repository.getArticlesByAuthor(reviewId);
}

class ArticlesBySectionUseCase {
  final ArticlesHomeRepository repository;

  ArticlesBySectionUseCase({required this.repository});

  Future<List<ArticleBriefEntity>> call(int reviewId) =>
      repository.getArticlesBySection(reviewId);
}

class ArticlesByKeywordUseCase {
  final ArticlesHomeRepository repository;

  ArticlesByKeywordUseCase({required this.repository});

  Future<ArticleBriefPageEntity> call({
    required String keyword,
    int page = 1,
  }) => repository.getArticlesByKeyword(keyword: keyword, page: page);
}

class ArticleQuoteUseCase {
  final ArticlesHomeRepository repository;

  ArticleQuoteUseCase({required this.repository});

  Future<ArticleQuoteEntity> call(int reviewId) =>
      repository.createArticleQuote(reviewId);
}
