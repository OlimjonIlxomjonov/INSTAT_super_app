import '../entity/user_articles/user_articles_response.dart';
import '../entity/review_authors/review_author_entity.dart';
import '../entity/review_detail/review_detail_entity.dart';

abstract class ArticlesHomeRepository {
  Future<UserArticlesResponse> getUserArticles();
  Future<List<ReviewAuthorEntity>> getReviewAuthors(int reviewId);
  Future<ReviewDetailEntity> getReviewDetail(int reviewId);
}
