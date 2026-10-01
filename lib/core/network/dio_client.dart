import 'package:dio/dio.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';

import '../utils/constants/api_urls/api_urls.dart';

const _skipAuthRedirectKey = 'skipAuthRedirect';
const _skipAuthKey = 'skipAuth';

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
    /// {TOKEN}
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //! Ommaviy endpoint — token yuborilsa backend natijani
          //! foydalanuvchiga qarab filtrlab yuboradi
          if (options.extra[_skipAuthKey] == true) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          final token = TokenStorageServiceImpl().getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          //! Server xatosi 200 bilan ham kelishi mumkin.
          //! ok:false ning o'zi yetarli emas — ayrim endpointlarda u
          //! "ruxsat yo'q" degani, xato emas.
          final data = response.data;
          final error = data is Map ? data['error'] : null;
          final isServerFailure =
              error is Map &&
              (error['type']?.toString() ?? '').endsWith('ServerError');

          if (isServerFailure) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
              ),
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          final token = TokenStorageServiceImpl().getAccessToken();
          final statusCode = error.response?.statusCode;

          final isUnauthorized = statusCode == 401;
          final hasToken = token != null && token.isNotEmpty;

          final skipRedirect =
              error.requestOptions.extra[_skipAuthRedirectKey] == true;

          if (isUnauthorized &&
              hasToken &&
              !skipRedirect &&
              !_isHandlingSessionExpiry) {
            _isHandlingSessionExpiry = true;

            await TokenStorageServiceImpl().deleteAccessToken();

            try {
              final context = AppRoute.navigatorKey.currentContext;
              if (context != null) {
                errorFlushBar(
                  context,
                  AppLocalizations.of(context)!.sessionExpiredMessage,
                );
              }
            } catch (_) {}

            AppRoute.open(const LogInOptionsPage());
          }

          return handler.next(error);
        },
      ),
    );

    //! Log oxirgi bo'lsin — interceptorlar qo'shgan sarlavhalar ham ko'rinadi
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
  void clearToken() {
    _dio.options.headers.remove('Authorization');
    _isHandlingSessionExpiry = false;
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  ///
  void setToken(String token) {
    _dio.options.headers['Authorization'] = "Bearer $token";
    _isHandlingSessionExpiry = false;
  }

  /// DOWNLOAD
  ///
  /// Token faqat o'z serverimizga qo'shiladi, begona manzilga emas.
  /// 401 bu yerda sessiyani yopmaydi — faylga ruxsat yo'qligi
  /// foydalanuvchini ilovadan chiqarib yubormasligi kerak.
  Future<Response> download(String url, String savePath) async {
    final isOwnHost = url.startsWith(ApiUrls.origin) || !url.startsWith('http');
    if (!isOwnHost) {
      return await Dio().download(url, savePath);
    }

    try {
      return await _dio.download(
        url,
        savePath,
        options: Options(extra: const {_skipAuthRedirectKey: true}),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    bool skipAuth = false,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParams,
        options: skipAuth ? Options(extra: const {_skipAuthKey: true}) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST
  Future<Response> post(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: skipAuth ? Options(extra: const {_skipAuthKey: true}) : null,
      );
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
