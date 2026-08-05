import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/services/token_storage/token_storage_service.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AppleAuthService {
  Future<void> signIn();
}

class AppleAuthServiceImpl implements AppleAuthService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;

  AppleAuthServiceImpl({
    required TokenStorageService tokenStorage,
    required DioClient dioClient,
  }) : _tokenStorage = tokenStorage,
       _dioClient = dioClient;

  @override
  Future<void> signIn() async {
    // Apple only returns givenName/familyName/email on the very first
    // authorization ever for this app + Apple ID — never again on
    // subsequent sign-ins, even from the same device. If the backend needs
    // that, it must persist it the first time it sees it.
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // TODO(backend): confirm the endpoint + payload shape — mirrored on
    // auth/google/ as a starting point, but Apple hands over a JWT
    // (identityToken) it signed itself, not an OAuth access token like
    // Google, so the backend verifies it differently (against Apple's
    // public keys) even though the shape of this call looks the same.
    final response = await _dioClient.post(
      '${ApiUrls.baseUrl}auth/apple/',
      data: {'identity_token': credential.identityToken},
    );

    final token = response.data['access'] as String?;
    if (token == null) throw Exception('No token in response');

    await _tokenStorage.saveAccessToken(token);
    _dioClient.setToken(token);
  }
}
