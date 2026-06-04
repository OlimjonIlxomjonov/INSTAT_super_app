import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/add_article/drop_down/drop_down_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/add_article/udk/udk_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_editions/article_editions_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_process/article_process_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_files/review_files_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_authors/review_author_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_detail/review_detail_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';

abstract class UserArticlesRemoteDataSource {
  Future<UserArticlesResponseModel> fetchUserArticles({required String status});

  Future<List<ReviewAuthorModel>> fetchReviewAuthors(int reviewId);

  Future<ReviewDetailModel> fetchReviewDetail(int reviewId);

  Future<List<ArticleProcessModel>> fetchArticleProcess({
    required ArticleProcessParams params,
  });

  Future<List<ReviewFilesModel>> fetchReviewFiles({
    required ArticleProcessParams params,
  });

  Future<ArticleEditionsResponseModel> fetchArticleEditions({
    required ArticleEditionsParams params,
  });

  Future<UdkModel> fetchUdk({required UdkParams params});

  Future<ReviewDetailModel> createReview(ReviewParams params);

  Future<ReviewDetailModel> updateReview(ReviewParams params);

  Future<ReviewAuthorModel> createReviewAuthor(ReviewAuthorParams params);

  Future<ReviewAuthorModel> updateReviewAuthor(ReviewAuthorParams params);

  //! drop downs
  Future<List<DropDownModel>> fetchArticleType();

  Future<List<DropDownModel>> fetchJournalSection();

  Future<List<DropDownModel>> fetchDegree();
}
