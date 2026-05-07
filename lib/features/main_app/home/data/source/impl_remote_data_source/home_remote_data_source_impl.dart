import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/user_me/user_model.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<UserModel> fetchUserMe() async {
    try {
      final response = await _dioClient.get(ApiUrls.me);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return UserModel.fromJson(data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }
    } on DioException catch (e) {
      logger.e(e);
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.response?.statusMessage ?? e.message,
      );
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<CourseListResponseModel> fetchCourses() async {
    try {
      final response = await _dioClient.get(ApiUrls.availableCourses);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseListResponseModel.fromJson(data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }
    } on DioException catch (e) {
      logger.e(e);
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.response?.statusMessage ?? e.message,
      );
    } catch (e, t) {
      logger.e(e);
      logger.e(t);
      rethrow;
    }
  }

  @override
  Future<void> postModelAvatar({required AvatarParams params}) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          params.imagePath,
          filename: params.imagePath.split('/').last,
        ),
      });
      final response = await _dioClient.post(
        ApiUrls.uploadAvatar,
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }
    } on DioException catch (e) {
      logger.e(e);
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.response?.statusMessage ?? e.message,
      );
    } catch (e, t) {
      logger.e(e);
      logger.e(t);
      rethrow;
    }
  }
}
