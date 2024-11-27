import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/alert.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/views/auth/login/login_viewmodel.dart';
import 'package:todo_app/views/auth/register/register_screen.dart';
import 'package:todo_app/views/todo/todo_screen.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleLocale});
  final VoidCallback toggleLocale;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _errorUsernameText;
  String? _errorPasswordText;

  @override
  void initState() {
    super.initState();
    _username.text = "trg1432001@gmail.com";
    _password.text = "trg1432001";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<LoginViewmodel>(context, listen: false).resetAttributes();

    Provider.of<LoginViewmodel>(context, listen: false).checkLastLogin();
  }

  void _resetErrorText() {
    _errorUsernameText = null;
    _errorPasswordText = null;
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
                child: Wrap(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.loginScreenTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              AppLocalizations.of(context)!.usernameLabel,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            //MARK: Username

                            CustomTextBox(
                              controller: _username,
                              hintText:
                                  AppLocalizations.of(context)!.usernameHint,
                              lineNumber: 1,
                              textError: _errorUsernameText,
                              onTap: _resetErrorText,
                            ),

                            //========================================================

                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              AppLocalizations.of(context)!.passwordLabel,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            //MARK: Password

                            CustomTextBox(
                              controller: _password,
                              hintText:
                                  AppLocalizations.of(context)!.passwordHint,
                              lineNumber: 1,
                              isSecure: true,
                              textError: _errorPasswordText,
                              onTap: _resetErrorText,
                            ),

                            //========================================================

                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        //MARK: Login Button

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: MainBottomButton(
                                    ontap: () {
                                      if (_username.text.isNotEmpty &&
                                          _password.text.isNotEmpty &&
                                          isEmail(_username.text)) {
                                        Provider.of<LoginViewmodel>(context,
                                                listen: false)
                                            .login(
                                                _username.text, _password.text);
                                      } else {
                                        _validateInput();
                                      }
                                    },
                                    buttonLabel: AppLocalizations.of(context)!
                                        .loginButtonTitle),
                              ),
                            ),
                          ],
                        ),

                        //========================================================

                        const SizedBox(
                          height: 16,
                        ),

                        Text(
                          AppLocalizations.of(context)!.becomeNewMember,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        //MARK: Register Button

                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.registerButtonTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.blueAccent),
                            ))

                        //========================================================
                      ]),
                ),
              ),
            ])),
          ),

//MARK: Consumer

          Consumer<LoginViewmodel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const Loading();
              } else if (vm.token.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<LoginViewmodel>(context, listen: false)
                      .resetAttributes();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TodoScreen(toggleLocale: widget.toggleLocale)),
                    (route) => false,
                  );
                });
                return Container();
              } else if (vm.error.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showAlert(context, AppLocalizations.of(context)!.error,
                      AppLocalizations.of(context)!.loginFailure, () {
                    Navigator.pop(context);
                  });
                });

                return Container();
              } else {
                return Container();
              }
            },
          )

//========================================================
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
          mainAction: action,
          mainActionLabel: AppLocalizations.of(context)!.ok,
        );
      },
    );
  }
}
