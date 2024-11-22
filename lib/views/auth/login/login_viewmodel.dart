import 'package:flutter/material.dart';
import 'package:todo_app/network/api_provider.dart';

class LoginViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  String _token = "";
  String get token => _token;

  late ApiProvider _provider;

  LoginViewmodel(provider) {
    _provider = provider;
  }

  //MARK: Public Functions

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

  void login(String username, String password) async {
    _startLoading();
    final response = await _provider.signIn(username, password);
    _stopLoading();
    _token = response.data ?? "";
    _setError(response.error ?? "");
  }
}
