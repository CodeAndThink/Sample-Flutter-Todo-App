import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/configs/custom_text_box.dart';
import 'package:todo_app/configs/main_bottom_button.dart';
import 'package:todo_app/views/todo/todo_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            height: screenHeight * 0.06,
            width: screenHeight * 0.06,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/back.svg",
                height: screenHeight * 0.015,
                width: screenHeight * 0.015,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
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
                  CustomTextBox(
                    controller: _repassword,
                    hintText: AppLocalizations.of(context)!.repasswordHint,
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
                          AppLocalizations.of(context)!.registerButtonTitle),
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
    );
  }
}
