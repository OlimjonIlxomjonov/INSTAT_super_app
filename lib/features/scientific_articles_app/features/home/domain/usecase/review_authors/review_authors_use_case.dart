import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ReviewAuthorsUseCase {
  final ArticlesHomeRepository repository;

  ReviewAuthorsUseCase({required this.repository});

  Future<List<ReviewAuthorEntity>> call(int reviewId) {
    return repository.getReviewAuthors(reviewId);
  }
}
