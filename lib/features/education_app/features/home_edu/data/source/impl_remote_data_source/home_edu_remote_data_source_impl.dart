import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/remote_data_source/home_edu_remote_data_source.dart';

class HomeEduRemoteDataSourceImpl implements HomeEduRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<CommentsResponseModel> fetchComments({
    required CommentsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}${ApiUrls.userComments}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return CommentsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }
}
