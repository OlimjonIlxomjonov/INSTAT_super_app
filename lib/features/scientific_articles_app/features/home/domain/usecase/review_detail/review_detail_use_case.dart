import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ReviewDetailUseCase {
  final ArticlesHomeRepository repository;

  ReviewDetailUseCase({required this.repository});

  Future<ReviewDetailEntity> call(int reviewId) {
    return repository.getReviewDetail(reviewId);
  }
}
