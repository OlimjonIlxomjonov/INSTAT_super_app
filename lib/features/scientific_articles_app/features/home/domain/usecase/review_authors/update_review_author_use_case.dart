import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class UpdateReviewAuthorUseCase {
  final ArticlesHomeRepository repository;

  UpdateReviewAuthorUseCase({required this.repository});

  Future<ReviewAuthorEntity> call(ReviewAuthorParams params) {
    return repository.updateReviewAuthor(params);
  }
}
