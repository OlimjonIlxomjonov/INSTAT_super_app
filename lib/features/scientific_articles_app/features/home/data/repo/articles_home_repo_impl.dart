import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/remote_data_source/user_articles_remote_data_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/udk/udk_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_order_payment/article_order_payment_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/articles_stats/articles_stats_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ArticlesHomeRepoImpl implements ArticlesHomeRepository {
  final UserArticlesRemoteDataSource remoteDataSource;

  ArticlesHomeRepoImpl({required this.remoteDataSource});

  @override
  Future<UserArticlesResponse> getUserArticles({
    required String status,
    required String search,
    int page = 1,
  }) {
    return remoteDataSource.fetchUserArticles(
      status: status,
      search: search,
      page: page,
    );
  }

  @override
  Future<List<ReviewAuthorEntity>> getReviewAuthors(int reviewId) {
    return remoteDataSource.fetchReviewAuthors(reviewId);
  }

  @override
  Future<ReviewDetailEntity> getReviewDetail(int reviewId) {
    return remoteDataSource.fetchReviewDetail(reviewId);
  }

  @override
  Future<List<ArticleProcessEntity>> getArticleProcess({
    required ArticleProcessParams params,
  }) {
    return remoteDataSource.fetchArticleProcess(params: params);
  }

  @override
  Future<List<ReviewFilesEntity>> getReviewFiles({
    required ArticleProcessParams params,
  }) {
    return remoteDataSource.fetchReviewFiles(params: params);
  }

  @override
  Future<ArticleEditionsResponse> getArticleEditions({
    required ArticleEditionsParams params,
  }) {
    return remoteDataSource.fetchArticleEditions(params: params);
  }

  @override
  Future<UdkEntity> getUdk({required UdkParams params}) {
    return remoteDataSource.fetchUdk(params: params);
  }

  @override
  Future<List<EditionArticleEntity>> getEditionArticles({
    required int editionId,
  }) {
    return remoteDataSource.fetchEditionArticles(editionId: editionId);
  }

  @override
  Future<ReviewDetailEntity> createReview(ReviewParams params) {
    return remoteDataSource.createReview(params);
  }

  @override
  Future<ReviewDetailEntity> updateReview(ReviewParams params) {
    return remoteDataSource.updateReview(params);
  }

  @override
  Future<ArticleOrderPaymentEntity> createArticleOrder({
    required CreateArticleOrderParams params,
  }) {
    return remoteDataSource.createArticleOrder(params: params);
  }

  @override
  Future<String?> getSiteDataValue({required String key}) {
    return remoteDataSource.fetchSiteDataValue(key: key);
  }

  @override
  Future<ReviewAuthorEntity> createReviewAuthor(ReviewAuthorParams params) {
    return remoteDataSource.createReviewAuthor(params);
  }

  @override
  Future<ReviewAuthorEntity> updateReviewAuthor(ReviewAuthorParams params) {
    return remoteDataSource.updateReviewAuthor(params);
  }

  //! drop down
  @override
  Future<List<DropDownEntity>> getArticleType() {
    return remoteDataSource.fetchArticleType();
  }

  @override
  Future<List<DropDownEntity>> getJournalSection() {
    return remoteDataSource.fetchJournalSection();
  }

  @override
  Future<List<DropDownEntity>> getDegree() {
    return remoteDataSource.fetchDegree();
  }

  //! main file articles
  @override
  Future<void> postArticleMainFile({required AddMainFileParams params}) {
    return remoteDataSource.postMainArticlesFile(params: params);
  }

  @override
  Future<void> postAntiplagiatFile({required AddAntiplagiatFileParams params}) {
    return remoteDataSource.postAntiplagiatFile(params: params);
  }

  @override
  Future<ReviewFilesEntity> postReviewFile({
    required AddReviewFileParams params,
  }) {
    return remoteDataSource.postReviewFile(params: params);
  }

  @override
  Future<List<ArticleProcessEntity>> getReviewProcess({
    required ReviewProcessParams params,
  }) {
    return remoteDataSource.fetchReviewProcess(params: params);
  }

  @override
  Future<ArticlesStatsEntity> getArticlesStats({required String countType}) {
    return remoteDataSource.fetchArticlesStats(countType: countType);
  }
}
