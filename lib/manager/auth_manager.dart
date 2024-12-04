import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static final shared = AuthManager();
  final _storage = const FlutterSecureStorage();

  //Save the current token after login
  Future<void> saveUserToken(String value) async {
    await _storage.write(key: "token", value: value);
  }

  //Get the current login token
  Future<String?> getUserToken() async {
    return await _storage.read(key: "token");
  }

  //Remove the current login token
  Future<void> removeUserToken() async {
    await _storage.write(key: "token", value: null);
  }
}