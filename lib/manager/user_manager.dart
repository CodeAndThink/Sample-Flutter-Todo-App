import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/models/user_model.dart';

class UserManager {
  final _storage = const FlutterSecureStorage();
  static final shared = UserManager();

  Future<void> saveUserData(UserModel userData) async {
    final userDataJson = jsonEncode(userData);
    await _storage.write(key: "userData", value: userDataJson);
  }

  Future<UserModel?> getUserData() async {
    final userDataString = await _storage.read(key: "userData");

    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString);
      return UserModel.fromJson(userDataJson);
    }

    return null;
  }

  Future<void> removeUserData() async {
    await _storage.write(key: "userData", value: null);
  }
}
