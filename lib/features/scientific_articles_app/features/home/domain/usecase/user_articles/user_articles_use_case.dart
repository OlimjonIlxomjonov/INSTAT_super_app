import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class UserArticlesUseCase {
  final ArticlesHomeRepository repository;

  UserArticlesUseCase({required this.repository});

  Future<UserArticlesResponse> call({
    required String status,
    required String search,
    int page = 1,
  }) {
    return repository.getUserArticles(
      status: status,
      search: search,
      page: page,
    );
  }
}
