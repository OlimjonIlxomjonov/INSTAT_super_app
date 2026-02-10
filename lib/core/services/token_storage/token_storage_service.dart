abstract class TokenStorageService {
  Future<void> saveAccessToken(String token);

  String? getAccessToken();

  Future<void> deleteAccessToken();
}
