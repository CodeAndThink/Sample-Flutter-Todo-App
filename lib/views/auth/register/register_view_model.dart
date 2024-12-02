import 'package:flutter/material.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:validators/validators.dart';

class RegisterViewModel extends ChangeNotifier {
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

  String _repassword = "";
  String get repassword => _repassword;

  String? _errorUsernameText;
  String? get errorUsernameText => _errorUsernameText;

  String? _errorPasswordText;
  String? get errorPasswordText => _errorPasswordText;

  String? _errorRepasswordText;
  String? get errorRepasswordText => _errorRepasswordText;

  late ApiProvider _provider;

  RegisterViewModel(provider) {
    _provider = provider;
  }

  //MARK: Public Functions

  void setUsername(String username) {
    _username = username;

    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;

    notifyListeners();
  }

  void setRePassword(String repassword) {
    _repassword = repassword;

    notifyListeners();
  }

  void resetErrorText() {
    _errorUsernameText = null;
    _errorPasswordText = null;
    _errorRepasswordText = null;
  }

  void validateInput(BuildContext context) {
    if (_username.isNotEmpty &&
        _password.isNotEmpty &&
        _repassword == _password &&
        isEmail(_username)) {
      register(_username, _repassword);
    } else {
      if (_username.isEmpty) {
        _errorUsernameText = AppLocalizations.of(context)!.usernameEmptyWarning;
      }
      if (_password.isEmpty) {
        _errorPasswordText = AppLocalizations.of(context)!.passwordEmptyWarning;
      }
      if (_repassword.isEmpty) {
        _errorRepasswordText =
            AppLocalizations.of(context)!.passwordEmptyWarning;
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

      if (_repassword == _password && _repassword.isNotEmpty) {
        _errorRepasswordText = null;
      } else {
        _errorRepasswordText =
            AppLocalizations.of(context)!.repasswordNotSameWarning;
      }

      notifyListeners();
    }
  }

  void resetAttributes() {
    _isLoading = false;
    _error = "";
    notifyListeners();
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

  void register(String username, String password) async {
    _startLoading();
    final response = await _provider.signUp(username, password);
    _stopLoading();
    _token = response.data ?? "";
    _setError(response.error ?? "");
  }
}
