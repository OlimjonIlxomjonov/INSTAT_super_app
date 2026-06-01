import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';

import '../entity/user_articles/user_articles_response.dart';
import '../entity/review_authors/review_author_entity.dart';
import '../entity/review_detail/review_detail_entity.dart';

abstract class ArticlesHomeRepository {
  Future<UserArticlesResponse> getUserArticles({required String status});

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
}
