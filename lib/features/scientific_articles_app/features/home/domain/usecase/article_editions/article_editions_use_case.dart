import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ArticleEditionsUseCase {
  final ArticlesHomeRepository repository;

  ArticleEditionsUseCase({required this.repository});

  Future<ArticleEditionsResponse> call({
    required ArticleEditionsParams params,
  }) {
    return repository.getArticleEditions(params: params);
  }
}
