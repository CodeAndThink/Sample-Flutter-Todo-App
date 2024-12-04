import 'package:flutter/material.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:validators/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginViewModel extends ChangeNotifier {
  //MARK: Properties

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  String _token = "";
  String get token => _token;

  String _username = "";
  String get username => _username;

  String _password = "";
  String get password => _password;

  String? _errorUsernameText;
  String? get errorUsernameText => _errorUsernameText;

  String? _errorPasswordText;
  String? get errorPasswordText => _errorPasswordText;

  late ApiProvider _provider;
  late UserManager _userManager;
  late AuthManager _authManager;

  //MARK: Construction

  LoginViewModel(provider, userManager, authManager) {
    _provider = provider;
    _userManager = userManager;
    _authManager = authManager;
  }

  //MARK: Public Functions

  //Function of login feature
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

  //Function setting username
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  //Function setting password
  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  //Function reset the error text of input text box
  void resetErrorText() {
    _errorUsernameText = null;
    _errorPasswordText = null;
  }

  //Function for validating username and password
  void validateInput(BuildContext context) {
    if (_username.isNotEmpty && _password.isNotEmpty && isEmail(_username)) {
      login(_username, _password);
    } else {
      if (_username.isEmpty) {
        _errorUsernameText = AppLocalizations.of(context)!.usernameEmptyWarning;
      }
      if (_password.isEmpty) {
        _errorPasswordText = AppLocalizations.of(context)!.passwordEmptyWarning;
      }
      if (isEmail(_username)) {
        _errorUsernameText = null;
      } else {
        _errorUsernameText =
            AppLocalizations.of(context)!.usernameInvalidWarning;
      }

      if (_password.length >= 6) {
        _errorPasswordText = null;
      } else {
        _errorPasswordText =
            AppLocalizations.of(context)!.passwordInvalidWarning;
      }

      notifyListeners();
    }
  }

  void resetState() {
    _isLoading = false;
    _error = "";
  }

  //Function set the initial value of username equal last username at the last login
  void getLastLoginUsername() async {
    final lastUserLogin = await UserManager.shared.getUserData();
    if (lastUserLogin != null) {
      setUsername(lastUserLogin.username);
    }
  }

  //MARK: Private Functions

  //Function of loading animation
  void _startLoading() {
    _isLoading = true;
    _error = "";
    _token = "";
    notifyListeners();
  }

  //Function for stopping loading animation
  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  //Function set the error value if available
  void _setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }
}
