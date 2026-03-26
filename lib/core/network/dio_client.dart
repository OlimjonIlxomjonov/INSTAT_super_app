import 'package:dio/dio.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';

import '../utils/constants/api_urls/api_urls.dart';

class DioClient {
  final Dio _dio;

  DioClient._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Accept': 'application/json'},
        ),
      ) {
    // Logging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    /// {TOKEN}
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = TokenStorageServiceImpl().getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final token = TokenStorageServiceImpl().getAccessToken();
          final statusCode = error.response?.statusCode;

          final isUnauthorized = statusCode == 401;
          final hasToken = token != null && token.isNotEmpty;

          if (isUnauthorized && hasToken) {
            await TokenStorageServiceImpl().deleteAccessToken();

            AppRoute.open(const LogInOptionsPage());
          }

          return handler.next(error);
        },
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  ///
  void setToken(String token) {
    _dio.options.headers['Authorization'] = "Bearer $token";
  }

  /// GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }

  /// POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }
}
