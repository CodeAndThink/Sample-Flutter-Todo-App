import 'package:flutter/material.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:validators/validators.dart';

class RegisterViewModel extends ChangeNotifier {

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

  String _repassword = "";
  String get repassword => _repassword;

  String? _errorUsernameText;
  String? get errorUsernameText => _errorUsernameText;

  String? _errorPasswordText;
  String? get errorPasswordText => _errorPasswordText;

  String? _errorRepasswordText;
  String? get errorRepasswordText => _errorRepasswordText;

  late ApiProvider _provider;

  //MARK: Construction

  RegisterViewModel(provider) {
    _provider = provider;
  }

  //MARK: Public Functions

  //Function for setting username
  void setUsername(String username) {
    _username = username;

    notifyListeners();
  }

  //Function for setting password
  void setPassword(String password) {
    _password = password;

    notifyListeners();
  }

  //Function for setting repassword
  void setRePassword(String repassword) {
    _repassword = repassword;

    notifyListeners();
  }

  //Function for resetting password
  void resetErrorText() {
    _errorUsernameText = null;
    _errorPasswordText = null;
    _errorRepasswordText = null;
  }

  //Function for validating password
  void validateInput(BuildContext context) {
    if (_username.isNotEmpty &&
        _password.isNotEmpty &&
        _repassword == _password &&
        isEmail(_username)) {
      _register(_username, _repassword);
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
  
  //MARK: Private Functions

  //Function of loading animation
  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
      _error = "";
      _token = "";
      notifyListeners();
    });
  }

  //Function for stopping loading animation
  void _stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  //Function set the error value if available 
  void _setError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
    });
  }

  //Function of register feature
  void _register(String username, String password) async {
    _startLoading();
    final response = await _provider.signUp(username, password);
    _stopLoading();
    _token = response.data ?? "";
    _setError(response.error ?? "");
  }
}
