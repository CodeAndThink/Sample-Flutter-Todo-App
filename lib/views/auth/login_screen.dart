import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/configs/custom_text_box.dart';
import 'package:todo_app/configs/main_bottom_button.dart';
import 'package:todo_app/views/auth/register_screen.dart';
import 'package:todo_app/views/todo/todo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.loginScreenTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextBox(
                    controller: _username,
                    hintText: AppLocalizations.of(context)!.usernameHint,
                    lineNumber: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextBox(
                    controller: _password,
                    hintText: AppLocalizations.of(context)!.passwordHint,
                    lineNumber: 1,
                    isSecure: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MainBottomButton(
                      ontap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const TodoScreen(),
                          ),
                        );
                      },
                      buttonLabel:
                          AppLocalizations.of(context)!.loginButtonTitle),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.registerButtonTitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ))
                ],
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
