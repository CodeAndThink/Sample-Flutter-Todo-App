import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/auth_text_box.dart';
import 'package:todo_app/common/views/custom_icon_button.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/setting/setting_view_model.dart';
import 'package:todo_app/utils/show_alert_dialog.dart';
import 'package:todo_app/views/auth/login/login_view_model.dart';
import 'package:todo_app/views/auth/register/register_screen.dart';
import 'package:todo_app/views/todo/todo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel _vm;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();

    _vm = LoginViewModel(
        ApiProvider.shared, UserManager.shared, AuthManager.shared);

//MARK: Event Listener

    _vm.error.addListener(() {
      if (_vm.error.value.isNotEmpty) {
        showAlert(context, AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.loginFailure, () {
          Navigator.pop(context);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

    _vm.token.addListener(() {
      if (_vm.token.value.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TodoScreen()),
          (route) => false,
        );
      }
    });

//========================================================

    _vm.getLastLoginUsername();
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
    _vm.error.dispose();
    _vm.token.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return ChangeNotifierProvider(
      create: (context) => _vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
//MARK: Change Language Button
                    _changeLanguageButton(context),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.3 > 150
                                    ? 150
                                    : screenWidth * 0.3),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                  offset: const Offset(2, 4)),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Image.asset(
                            Assets.images.logo.path,
                            height: screenWidth * 0.3 > 150
                                ? 150
                                : screenWidth * 0.3,
                            width: screenWidth * 0.3 > 150
                                ? 150
                                : screenWidth * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .loginScreenTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .usernameLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),

//MARK: Username Text Box
                                      _usernameTextBox(context),

                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .passwordLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),

//MARK: Password Text Box
                                      _passwordTextBox(context),

                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),

//MARK: Login Button
                                  _loginButton(context),

                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .becomeNewMember,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),

//MARK: Register Button
                                      _navigateRegisterScreenTextButton(context)
                                    ],
                                  ),
                                  Text(
                                      AppLocalizations.of(context)!
                                          .anotherWayToLoginTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),

//MARK: Google - Facebook - Apple Login Buttons
                                  _otherWayLoginButton(context)
                                ]),
                          ),
                        ),
                      ]),
                    ),

//MARK: Loading Animation
                    _loadingAnimation(context)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//MARK: Change Language Button

  Widget _changeLanguageButton(BuildContext context) {
    return Positioned(
      left: 16,
      child: IconButton(
          onPressed: () {
            Provider.of<SettingViewModel>(context, listen: false)
                .toggleLocale();
          },
          icon: SvgPicture.asset(Assets.icons.lang,
              height: 30,
              width: 30,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcATop))),
    );
  }

//========================================================

//MARK: Username Text Box

  Widget _usernameTextBox(BuildContext context) {
    return Selector<LoginViewModel, dartz.Tuple2<String, String?>>(
      selector: (context, viewmodel) =>
          dartz.Tuple2(viewmodel.username, viewmodel.errorUsernameText),
      builder: (context, data, child) {
        _username.text = data.value1;
        return CustomTextBox(
          controller: _username,
          hintText: AppLocalizations.of(context)!.usernameHint,
          lineNumber: 1,
          textError: data.value2,
          onTap: _vm.resetErrorText,
          textChangeAction: (value) {
            _vm.setUsername(value);
          },
          cleanAction: () {
            _vm.resetErrorText();
            _vm.setUsername("");
          },
        );
      },
    );
  }

//========================================================

//MARK: Password Text Box

  Widget _passwordTextBox(BuildContext context) {
    return Selector<LoginViewModel, dartz.Tuple2<String, String?>>(
      selector: (context, viewmodel) =>
          dartz.Tuple2(viewmodel.password, viewmodel.errorPasswordText),
      builder: (context, data, child) {
        _password.text = data.value1;
        return AuthTextBox(
          controller: _password,
          hintText: AppLocalizations.of(context)!.passwordHint,
          lineNumber: 1,
          textError: data.value2,
          onTap: _vm.resetErrorText,
          textChangeAction: (value) {
            _vm.setPassword(value);
          },
        );
      },
    );
  }

//========================================================

//MARK: Login Button

  Widget _loginButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: MainBottomButton(
                ontap: () {
                  _vm.validateInput(context);
                },
                buttonLabel: AppLocalizations.of(context)!.loginButtonTitle),
          ),
        ),
      ],
    );
  }

//========================================================

//MARK: Register Button

  Widget _navigateRegisterScreenTextButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
        child: Text(
          AppLocalizations.of(context)!.registerButtonTitle,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.blueAccent),
        ));
  }

//========================================================

//MARK: Google - Facebook - Apple Login Buttons

  Widget _otherWayLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconButton(action: () {}, iconPath: Assets.icons.google.path),
        const SizedBox(
          width: 16,
        ),
        CustomIconButton(action: () {}, iconPath: Assets.icons.facebook.path),
        const SizedBox(
          width: 16,
        ),
        CustomIconButton(action: () {}, iconPath: Assets.icons.apple.path),
      ],
    );
  }

//========================================================

//MARK: Loading Animation

  Widget _loadingAnimation(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Selector<LoginViewModel, bool>(
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Loading();
            }
            return const SizedBox();
          },
          selector: (context, viewmodel) => viewmodel.isLoading),
    );
  }

//========================================================
}
