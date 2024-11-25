import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static final shared = AuthManager();
  final _storage = const FlutterSecureStorage();

  Future<void> saveUserToken(String value) async {
    await _storage.write(key: "token", value: value);
  }

  Future<String?> getUserToken() async {
    return await _storage.read(key: "token");
  }

  Future<void> removeUserToken() async {
    await _storage.write(key: "token", value: null);
  }
}