import 'package:dio/dio.dart';
import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/auth/data/models/reviewer_login_request_model.dart';
import 'package:my_template/features/auth/data/sources/remote_data_source/reviewer_auth_remote_data_source.dart';

class ReviewerAuthRemoteDataSourceImpl implements ReviewerAuthRemoteDataSource {
  final DioClient _dioClient;
  final TokenStorageService _tokenStorage;

  ReviewerAuthRemoteDataSourceImpl({
    DioClient? dioClient,
    TokenStorageService? tokenStorage,
  })  : _dioClient = dioClient ?? DioClient(),
        _tokenStorage = tokenStorage ?? TokenStorageServiceImpl();

  @override
  Future<void> login(ReviewerLoginRequestModel params) async {
    try {
      final response = await _dioClient.post(
        ApiUrls.token,
        data: params.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i('Reviewer login response: $data');

        String? token;
        if (data is Map) {
          token = (data['access'] ??
                  data['token'] ??
                  data['data']?['access'] ??
                  data['data']?['token'])
              ?.toString();
        }

        if (token == null || token.isEmpty) {
          throw ServerException(
            message: 'No token found in login response',
            statusCode: response.statusCode,
          );
        }

        await _tokenStorage.saveAccessToken(token);
        _dioClient.setToken(token);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.statusMessage ?? 'Failed to log in',
        );
      }
    } on DioException catch (e) {
      logger.e('Reviewer login failed', error: e.response?.data ?? e);
      final extractedMessage = _extractErrorMessage(e);
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: extractedMessage,
      );
    } catch (e) {
      logger.e('Reviewer login unexpected error', error: e);
      rethrow;
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      if (data['error'] is Map) {
        final errorMap = data['error'] as Map;
        final details = errorMap['details'];
        if (details is Map && details['detail'] != null) {
          return details['detail'].toString();
        }
        if (details is String && details.isNotEmpty) {
          return details;
        }
        if (errorMap['message'] != null) {
          return errorMap['message'].toString();
        }
        if (errorMap['type'] != null) {
          return errorMap['type'].toString();
        }
      }
      if (data['detail'] != null) {
        return data['detail'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.response?.statusMessage ?? e.message ?? 'Authentication failed';
  }
}
