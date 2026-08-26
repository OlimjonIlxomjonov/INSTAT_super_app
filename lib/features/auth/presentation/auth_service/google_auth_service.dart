import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/features/auth/presentation/data_source/auth_constatns.dart';

abstract class GoogleAuthService {
  Future<void> signIn();
}

class GoogleAuthServiceImpl implements GoogleAuthService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;

  GoogleAuthServiceImpl({
    required TokenStorageService tokenStorage,
    required DioClient dioClient,
  }) : _tokenStorage = tokenStorage,
       _dioClient = dioClient;

  static bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: AuthConstants.googleServerClientId,
    );
    _initialized = true;
  }

  @override
  Future<void> signIn() async {
    await _ensureInitialized();

    final account = await GoogleSignIn.instance.authenticate();

    final authorizationClient = account.authorizationClient;
    final authorization =
        await authorizationClient.authorizationForScopes([
          'email',
          'profile',
        ]) ??
        await authorizationClient.authorizeScopes(['email', 'profile']);

    final response = await _dioClient.post(
      '${ApiUrls.baseUrl}auth/google/',
      data: {'access_token': authorization.accessToken},
    );

    final token = response.data['access'] as String?;
    if (token == null) throw Exception('No token in response');

    await _tokenStorage.saveAccessToken(token);
    _dioClient.setToken(token);
  }
}
