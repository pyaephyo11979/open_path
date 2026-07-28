import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<void> deleteAllFromSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
