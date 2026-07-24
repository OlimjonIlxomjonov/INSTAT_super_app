import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/add_article/drop_down/drop_down_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/add_article/udk/udk_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_editions/article_editions_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_process/article_process_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_files/review_files_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_authors/review_author_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_detail/review_detail_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/remote_data_source/user_articles_remote_data_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';

class UserArticlesRemoteDataSourceImpl implements UserArticlesRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<UserArticlesResponseModel> fetchUserArticles({
    required String status,
    required String search,
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.userArticles,
        queryParams: {
          'status': status,
          'search': search,
          'page': page,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return UserArticlesResponseModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReviewAuthorModel>> fetchReviewAuthors(int reviewId) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.reviewAuthors,
        queryParams: {'review_id': reviewId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final list = response.data as List?;
        return list?.map((e) => ReviewAuthorModel.fromJson(e)).toList() ?? [];
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewDetailModel> fetchReviewDetail(int reviewId) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.userArticles}$reviewId/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReviewDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<ArticleProcessModel>> fetchArticleProcess({
    required ArticleProcessParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.userArticles}${params.articleId}/processes/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = (response.data as List);
        return data.map((e) => ArticleProcessModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReviewFilesModel>> fetchReviewFiles({
    required ArticleProcessParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.userArticles}${params.articleId}/review-files/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = (response.data as List);
        return data.map((e) => ReviewFilesModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ArticleEditionsResponseModel> fetchArticleEditions({
    required ArticleEditionsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.editions}?status=${params.status}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ArticleEditionsResponseModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<UdkModel> fetchUdk({required UdkParams params}) async {
    try {
      final response = await _dioClient.get('${ApiUrls.udk}${params.udkCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return UdkModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewDetailModel> createReview(ReviewParams params) async {
    try {
      final response = await _dioClient.post(
        ApiUrls.userArticles,
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReviewDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewDetailModel> updateReview(ReviewParams params) async {
    try {
      final response = await _dioClient.put(
        '${ApiUrls.userArticles}${params.id}/',
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReviewDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<void> createArticleOrder({
    required CreateArticleOrderParams params,
  }) async {
    try {
      final response = await _dioClient.post(
        '${ApiUrls.userArticles}${params.reviewId}/create-order/',
        data: {'payment_method': params.paymentMethod},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewAuthorModel> createReviewAuthor(
    ReviewAuthorParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiUrls.reviewAuthors,
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReviewAuthorModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewAuthorModel> updateReviewAuthor(
    ReviewAuthorParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        '${ApiUrls.reviewAuthors}${params.id}/',
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReviewAuthorModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<DropDownModel>> fetchArticleType() async {
    try {
      final response = await _dioClient.get(ApiUrls.articleType);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => DropDownModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<DropDownModel>> fetchJournalSection() async {
    try {
      final response = await _dioClient.get(ApiUrls.journalSection);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => DropDownModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<DropDownModel>> fetchDegree() async {
    try {
      final response = await _dioClient.get(ApiUrls.academicDegree);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => DropDownModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<void> postMainArticlesFile({required AddMainFileParams params}) async {
    try {
      final formData = FormData.fromMap({
        'review_id': params.reviewId,
        'file': await MultipartFile.fromFile(
          params.mainFile.path,
          filename: params.mainFile.path.split('/').last,
        ),
      });
      final response = await _dioClient.post(
        '${ApiUrls.userArticles}${params.reviewId}/${ApiUrls.mainFileArticle}',
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<void> postAntiplagiatFile({
    required AddAntiplagiatFileParams params,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          params.file.path,
          filename: params.file.path.split('/').last,
        ),
      });
      final response = await _dioClient.post(
        '${ApiUrls.userArticles}${params.reviewId}/${ApiUrls.antiplagiatFileArticle}',
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<ReviewFilesModel> postReviewFile({
    required AddReviewFileParams params,
  }) async {
    try {
      final formData = FormData.fromMap({
        'review_id': params.reviewId,
        'type': params.type,
        'file': await MultipartFile.fromFile(
          params.file.path,
          filename: params.file.path.split('/').last,
        ),
      });
      final response = await _dioClient.post(
        '${ApiUrls.userArticles}${params.reviewId}/${ApiUrls.reviewFilesArticle}',
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return ReviewFilesModel.fromJson(data);
        }
        if (data is List && data.isNotEmpty) {
          return ReviewFilesModel.fromJson(data.last as Map<String, dynamic>);
        }
        throw Exception('Unexpected review file upload response');
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }
}
