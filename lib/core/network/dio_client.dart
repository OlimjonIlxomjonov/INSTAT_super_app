import 'package:dio/dio.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';

import '../utils/constants/api_urls/api_urls.dart';

class DioClient {
  final Dio _dio;
  bool _isHandlingSessionExpiry = false;

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

          // A single failed screen load can fire off several parallel
          // requests that all 401 at once — only react to the first one.
          if (isUnauthorized && hasToken && !_isHandlingSessionExpiry) {
            _isHandlingSessionExpiry = true;

            await TokenStorageServiceImpl().deleteAccessToken();

            final context = AppRoute.navigatorKey.currentContext;
            if (context != null) {
              errorFlushBar(
                context,
                AppLocalizations.of(context)!.sessionExpiredMessage,
              );
            }

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
    // A fresh token means a new session — the next 401 (if any) is a new
    // problem and should be handled again.
    _isHandlingSessionExpiry = false;
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
