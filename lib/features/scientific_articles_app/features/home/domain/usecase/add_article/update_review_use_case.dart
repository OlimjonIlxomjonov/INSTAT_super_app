import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class UpdateReviewUseCase {
  final ArticlesHomeRepository repository;

  UpdateReviewUseCase({required this.repository});

  Future<ReviewDetailEntity> call(ReviewParams params) {
    return repository.updateReview(params);
  }
}
