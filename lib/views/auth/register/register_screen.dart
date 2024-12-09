import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/auth_text_box.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/utilis/show_alert_dialog.dart';
import 'package:todo_app/views/auth/register/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  late RegisterViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = RegisterViewModel(ApiProvider.shared);

//MARK: Event Listener

    _vm.error.addListener(() {
      if (_vm.error.value.isNotEmpty) {
        showAlert(context, AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.registerFailure, () {
          Navigator.pop(context);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

    _vm.token.addListener(() {
      if (_vm.token.value.isNotEmpty) {
        showAlert(context, AppLocalizations.of(context)!.success,
            AppLocalizations.of(context)!.registerSuccess, () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

//========================================================
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
    _repassword.dispose();
    _vm.error.dispose();
    _vm.token.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return ChangeNotifierProvider(
      create: (context) => _vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.11,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: _customAppBar(),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            color: Theme.of(context).colorScheme.surface),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .registerScreenTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.usernameLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
              
                                    //MARK: Username Textbox
                                    Selector<RegisterViewModel,
                                        dartz.Tuple2<String, String?>>(
                                      selector: (context, viewmodel) =>
                                          dartz.Tuple2(viewmodel.username,
                                              viewmodel.errorUsernameText),
                                      builder: (context, data, child) {
                                        _username.text = data.value1;
                                        return CustomTextBox(
                                          controller: _username,
                                          hintText: AppLocalizations.of(context)!
                                              .usernameHint,
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
                                    ),
              
                                    //========================================================
              
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.passwordLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
              
                                    //MARK: Password Textbox
              
                                    Selector<RegisterViewModel,
                                        dartz.Tuple2<String, String?>>(
                                      selector: (context, viewmodel) =>
                                          dartz.Tuple2(viewmodel.password,
                                              viewmodel.errorPasswordText),
                                      builder: (context, data, child) {
                                        _password.text = data.value1;
                                        return AuthTextBox(
                                          controller: _password,
                                          hintText: AppLocalizations.of(context)!
                                              .passwordHint,
                                          lineNumber: 1,
                                          textError: data.value2,
                                          onTap: _vm.resetErrorText,
                                          textChangeAction: (value) {
                                            _vm.setPassword(value);
                                          },
                                        );
                                      },
                                    ),
              
                                    //========================================================
              
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .repasswordLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
              
                                    //MARK: Confirm Password Textbox
              
                                    Selector<RegisterViewModel,
                                        dartz.Tuple2<String, String?>>(
                                      selector: (context, viewmodel) =>
                                          dartz.Tuple2(viewmodel.repassword,
                                              viewmodel.errorRepasswordText),
                                      builder: (context, data, child) {
                                        _repassword.text = data.value1;
                                        return AuthTextBox(
                                          controller: _repassword,
                                          hintText: AppLocalizations.of(context)!
                                              .repasswordHint,
                                          lineNumber: 1,
                                          textError: data.value2,
                                          onTap: _vm.resetErrorText,
                                          textChangeAction: (value) {
                                            _vm.setRePassword(value);
                                          },
                                        );
                                      },
                                    ),
              
                                    //========================================================
              
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                                //MARK: Register Button
              
                                Row(children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 56,
                                      child: MainBottomButton(
                                          ontap: () {
                                            Provider.of<RegisterViewModel>(
                                                    context,
                                                    listen: false)
                                                .validateInput(context);
                                          },
                                          buttonLabel:
                                              AppLocalizations.of(context)!
                                                  .registerButtonTitle),
                                    ),
                                  ),
                                ]),
              
                                //========================================================
              
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .alreadyHaveAccount,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
              
                                //MARK: Move To Login Screen Button
              
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .loginButtonTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: Colors.blueAccent),
                                    ))
              
                                //========================================================
                              ]),
                        ),
                      ),
                    ]),
                  ),
              
                  //MARK: Loading
              
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Selector<RegisterViewModel, bool>(
                        builder: (context, isLoading, child) {
                          if (isLoading) {
                            return const Loading();
                          }
                          return const SizedBox();
                        },
                        selector: (context, viewmodel) => viewmodel.isLoading),
                  )
              
                  //========================================================
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

//MARK: App Bar

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
}

//========================================================
