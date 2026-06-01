import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/remote_data_source/user_articles_remote_data_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class ArticlesHomeRepoImpl implements ArticlesHomeRepository {
  final UserArticlesRemoteDataSource remoteDataSource;

  ArticlesHomeRepoImpl({required this.remoteDataSource});

  @override
  Future<UserArticlesResponse> getUserArticles({required String status}) {
    return remoteDataSource.fetchUserArticles(status: status);
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
}
