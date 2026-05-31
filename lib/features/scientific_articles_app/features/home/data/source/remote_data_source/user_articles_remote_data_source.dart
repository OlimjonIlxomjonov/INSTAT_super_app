import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_authors/review_author_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_detail/review_detail_model.dart';

abstract class UserArticlesRemoteDataSource {
  Future<UserArticlesResponseModel> fetchUserArticles();
  Future<List<ReviewAuthorModel>> fetchReviewAuthors(int reviewId);
  Future<ReviewDetailModel> fetchReviewDetail(int reviewId);
}
