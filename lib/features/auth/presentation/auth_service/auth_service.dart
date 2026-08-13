import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';

abstract class OneIdAuthService {
  Future<void> handleAuthSuccess(String code);
}

class OneIdAuthServiceImpl implements OneIdAuthService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;

  const OneIdAuthServiceImpl({
    required TokenStorageService tokenStorage,
    required DioClient dioClient,
  }) : _tokenStorage = tokenStorage,
       _dioClient = dioClient;

  @override
  Future<void> handleAuthSuccess(String code) async {
    final response = await _dioClient.get(
      '${ApiUrls.baseUrl}one-id/login',
      queryParams: {'code': code, 'state': 'testState'},
    );

    final token = response.data['data']['access'] as String?;
    if (token == null) throw Exception('No token in repository');

    await _tokenStorage.saveAccessToken(token);
    _dioClient.setToken(token);
  }
}
