import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/alert.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/views/auth/register/register_viewmodel.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  String? _errorUsernameText;
  String? _errorPasswordText;
  String? _errorRepasswordText;

  @override
  void initState() {
    super.initState();
  }

  void _resetErrorText() {
    _errorUsernameText = null;
    _errorPasswordText = null;
    _errorRepasswordText = null;
  }

  void _validateInput() {
    if (_username.text.isEmpty) {
      setState(() {
        _errorUsernameText = AppLocalizations.of(context)!.usernameEmptyWarning;
      });
    }
    if (_password.text.isEmpty) {
      setState(() {
        _errorPasswordText = AppLocalizations.of(context)!.passwordEmptyWarning;
      });
    }
    if (_repassword.text.isEmpty) {
      setState(() {
        _errorRepasswordText =
            AppLocalizations.of(context)!.passwordEmptyWarning;
      });
    }
    if (isEmail(_username.text)) {
      setState(() {
        _errorUsernameText = null;
      });
    } else {
      setState(() {
        _errorUsernameText =
            AppLocalizations.of(context)!.usernameInvalidWarning;
      });
    }

    if (_password.text.length >= 6) {
      setState(() {
        _errorPasswordText = null;
      });
    } else {
      setState(() {
        _errorPasswordText =
            AppLocalizations.of(context)!.passwordInvalidWarning;
      });
    }

    if (_repassword.text == _password.text && _repassword.text.isNotEmpty) {
      setState(() {
        _errorRepasswordText = null;
      });
    } else {
      setState(() {
        _errorRepasswordText =
            AppLocalizations.of(context)!.repasswordNotSameWarning;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.11,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _customAppBar(),
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Center(
              child: Wrap(children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: Theme.of(context).colorScheme.surface),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registerScreenTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextBox(
                      controller: _username,
                      hintText: AppLocalizations.of(context)!.usernameHint,
                      lineNumber: 1,
                      textError: _errorUsernameText,
                      onTap: _resetErrorText,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextBox(
                      controller: _password,
                      hintText: AppLocalizations.of(context)!.passwordHint,
                      lineNumber: 1,
                      isSecure: true,
                      textError: _errorPasswordText,
                      onTap: _resetErrorText,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextBox(
                      controller: _repassword,
                      hintText: AppLocalizations.of(context)!.repasswordHint,
                      lineNumber: 1,
                      isSecure: true,
                      textError: _errorRepasswordText,
                      onTap: _resetErrorText,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 56,
                      child: MainBottomButton(
                          ontap: () {
                            if (_username.text.isNotEmpty &&
                                _password.text.isNotEmpty &&
                                _repassword.text == _password.text &&
                                isEmail(_username.text)) {
                              Provider.of<RegisterViewmodel>(context,
                                      listen: false)
                                  .register(_username.text, _password.text);
                            } else {
                              _validateInput();
                            }
                          },
                          buttonLabel: AppLocalizations.of(context)!
                              .registerButtonTitle),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.loginButtonTitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ))
                  ],
                ),
              ),
            ),
          ])),
        ),
        Consumer<RegisterViewmodel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Loading();
            } else if (vm.token.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAlert(context, AppLocalizations.of(context)!.success,
                    AppLocalizations.of(context)!.registerSuccess, () {
                  Provider.of<RegisterViewmodel>(context, listen: false)
                      .resetAttributes();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              });
              return Container();
            } else if (vm.error.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAlert(context, AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.registerFailure, () {
                  Navigator.pop(context);
                });
              });

              return Container();
            } else {
              return Container();
            }
          },
        )
      ]),
    );
  }

  Widget _customAppBar() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.06,
            width: screenHeight * 0.06,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(screenHeight * 0.06 / 2)),
                color: Colors.white),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  "assets/icons/back.svg",
                  height: screenHeight * 0.015,
                  width: screenHeight * 0.015,
                )),
          ),
        ],
      ),
    );
  }

  void _showAlert(
      BuildContext context, String title, String content, Function() action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alert(
          title: title,
          content: content,
          action: action,
        );
      },
    );
  }
}
