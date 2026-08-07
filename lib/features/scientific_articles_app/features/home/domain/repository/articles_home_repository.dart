import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_order_payment/article_order_payment_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/udk/udk_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';

import '../entity/user_articles/user_articles_response.dart';
import '../entity/review_authors/review_author_entity.dart';
import '../entity/review_detail/review_detail_entity.dart';

abstract class ArticlesHomeRepository {
  Future<UserArticlesResponse> getUserArticles({
    required String status,
    required String search,
    int page = 1,
  });

  Future<List<ReviewAuthorEntity>> getReviewAuthors(int reviewId);

  Future<ReviewDetailEntity> getReviewDetail(int reviewId);

  Future<List<ArticleProcessEntity>> getArticleProcess({
    required ArticleProcessParams params,
  });

  Future<List<ReviewFilesEntity>> getReviewFiles({
    required ArticleProcessParams params,
  });

  Future<ArticleEditionsResponse> getArticleEditions({
    required ArticleEditionsParams params,
  });

  Future<List<EditionArticleEntity>> getEditionArticles({
    required int editionId,
  });

  Future<UdkEntity> getUdk({required UdkParams params});

  Future<ReviewDetailEntity> createReview(ReviewParams params);

  Future<ReviewDetailEntity> updateReview(ReviewParams params);

  //! Submitting for review is a payment action on the backend — this is
  //! what actually transitions status away from draft and creates the
  //! process log entry (the plain create/update calls above never do).
  Future<ArticleOrderPaymentEntity> createArticleOrder({
    required CreateArticleOrderParams params,
  });

  //! Site-wide settings (e.g. review_price)
  Future<String?> getSiteDataValue({required String key});

  Future<ReviewAuthorEntity> createReviewAuthor(ReviewAuthorParams params);

  Future<ReviewAuthorEntity> updateReviewAuthor(ReviewAuthorParams params);

  //! drop down
  Future<List<DropDownEntity>> getArticleType();

  Future<List<DropDownEntity>> getJournalSection();

  Future<List<DropDownEntity>> getDegree();

  //! Add main file to the articles
  Future<void> postArticleMainFile({required AddMainFileParams params});

  Future<void> postAntiplagiatFile({required AddAntiplagiatFileParams params});

  Future<ReviewFilesEntity> postReviewFile({
    required AddReviewFileParams params,
  });

  //! search articles
}
