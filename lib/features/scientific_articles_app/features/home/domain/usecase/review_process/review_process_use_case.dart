import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ReviewProcessUseCase {
  final ArticlesHomeRepository repository;

  ReviewProcessUseCase({required this.repository});

  Future<List<ArticleProcessEntity>> call() {
    return repository.getReviewProcess();
  }
}
