import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/user_me/user_model.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  Future<void> faceRec({required FaceRecParams params}) async {
    try {
      final formData = FormData.fromMap({
        "code": params.code,
        "image": await MultipartFile.fromFile(
          params.imgPath.path,
          filename: "myid_image.jpg",
        ),
      });

      final response = await _dioClient.post(ApiUrls.faceRec, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = const JsonEncoder.withIndent('  ').convert(response.data);

        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/myid.json');

        await file.writeAsString(json);

        logger.i(file.path);
        final docData = response.data['profile']['doc_data'];

        logger.i(response.data);
        logger.i(docData);
        logger.i(docData['issued_by']);
        logger.i(docData['issued_date']);
      } else {
        throw Exception(
          'Thrown Exception: ${response.data} ${response.statusCode} ',
        );
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<String> fetchMyIdSessionId({
    required String birthDate,
    required String passportData,
  }) async {
    try {
      final data = {"birth_date": birthDate, "pass_data": passportData};

      final response = await _dioClient.post(ApiUrls.myIdSession, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("MyID session response: ${response.data}");
        final responseData = response.data;
        if (responseData is Map) {
          final sessionId =
              responseData['session_id'] ??
              responseData['sessionId'] ??
              responseData['data']?['session_id'] ??
              responseData['data']?['sessionId'];
          if (sessionId != null) {
            return sessionId.toString();
          }
        }
        throw Exception("Session ID not found in response payload.");
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      logger.e("Failed to fetch MyID session ID: $e");
      rethrow;
    }
  }
}
