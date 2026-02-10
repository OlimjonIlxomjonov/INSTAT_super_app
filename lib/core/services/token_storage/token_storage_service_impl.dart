import 'token_storage_service.dart';
import 'package:hive/hive.dart';

class TokenStorageServiceImpl implements TokenStorageService {
  final Box box = Hive.box('authBox');

  @override
  Future<void> saveAccessToken(String token) async {
    await box.put('access_token', token);
  }

  @override
  String? getAccessToken() {
    return box.get('access_token');
  }

  @override
  Future<void> deleteAccessToken() async {
    await box.delete('access_token');
  }
}
