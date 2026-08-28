import 'package:dio/dio.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';

abstract class QrAuthService {
  Future<void> loginWithQr(String rawQrData);
}

class QrAuthServiceImpl implements QrAuthService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;

  QrAuthServiceImpl({TokenStorageService? tokenStorage, DioClient? dioClient})
    : _tokenStorage = tokenStorage ?? TokenStorageServiceImpl(),
      _dioClient = dioClient ?? DioClient();

  @override
  Future<void> loginWithQr(String rawQrData) async {
    final String qrString = rawQrData.trim();

    final requestBody = {'qr_string': qrString};

    logger.i('QR login request body: $requestBody');

    try {
      final response = await _dioClient.post(
        ApiUrls.qrLogin,
        data: requestBody,
      );

      logger.i(
        'QR login response code: ${response.statusCode}, data: ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        String? token;
        if (data is Map) {
          token =
              (data['access'] ??
                      data['token'] ??
                      data['data']?['access'] ??
                      data['data']?['token'] ??
                      data['tokens']?['access'])
                  ?.toString();
        }

        if (token != null && token.isNotEmpty) {
          await _tokenStorage.saveAccessToken(token);
          _dioClient.setToken(token);
        }
      } else {
        throw Exception(response.statusMessage ?? 'QR login failed');
      }
    } on DioException catch (e) {
      logger.e('QR login failed', error: e.response?.data ?? e);
      final message = _extractErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      logger.e('QR login error', error: e);
      rethrow;
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      if (data['detail'] != null) {
        return data['detail'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
      if (data['error'] != null) {
        final err = data['error'];
        if (err is Map && err['message'] != null) {
          return err['message'].toString();
        }
        return err.toString();
      }
      if (data['qr_string'] != null) {
        final qrErr = data['qr_string'];
        if (qrErr is List) return qrErr.join(', ');
        return qrErr.toString();
      }
    }
    return e.response?.statusMessage ??
        e.message ??
        'QR scan authentication failed';
  }
}
