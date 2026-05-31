import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_response_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_authors/review_author_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_detail/review_detail_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/remote_data_source/user_articles_remote_data_source.dart';

class UserArticlesRemoteDataSourceImpl implements UserArticlesRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<UserArticlesResponseModel> fetchUserArticles() async {
    try {
      final response = await _dioClient.get(ApiUrls.userArticles);
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
      final response = await _dioClient.get('${ApiUrls.userArticles}$reviewId/');
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
}
