import 'package:flutter/material.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/network/api_provider.dart';

class LoginViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  String _token = "";
  String get token => _token;

  late ApiProvider _provider;
  late UserManager _userManager;
  late AuthManager _authManager;

  LoginViewmodel(provider, userManager, authManager) {
    _provider = provider;
    _userManager = userManager;
    _authManager = authManager;
  }

  //MARK: Public Functions
  void checkLastLogin() async {
    final lastUserLogin = await _userManager.getUserData();
    if (lastUserLogin != null) {
      final username = lastUserLogin.username;
      final password = lastUserLogin.password;
      login(username, password);
    }
  }

  void login(String username, String password) async {
    _startLoading();
    final response = await _provider.signIn(username, password);
    _stopLoading();
    _token = response.data ?? "";
    if (_token.isNotEmpty) {
      _authManager.saveUserToken(_token);
      final newUser = UserModel(username: username, password: password);
      _userManager.saveUserData(newUser);
    }
    _setError(response.error ?? "");
  }

  void resetAttributes() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      _error = "";
      _token = "";
      notifyListeners();
    });
  }

  //MARK: Private Functions

  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
      _error = "";
      _token = "";
      notifyListeners();
    });
  }

  void _stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void _setError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
    });
  }
}
