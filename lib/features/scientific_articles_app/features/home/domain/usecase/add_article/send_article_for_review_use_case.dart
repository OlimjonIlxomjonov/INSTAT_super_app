import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class SendArticleForReviewUseCase {
  final ArticlesHomeRepository repository;

  SendArticleForReviewUseCase({required this.repository});

  Future<void> call(int reviewId) {
    return repository.sendArticleForReview(reviewId);
  }
}
