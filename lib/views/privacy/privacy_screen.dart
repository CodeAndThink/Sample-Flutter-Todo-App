import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
//MARK: App Bar
              _appBar(context),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.samplePrivacy,
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//MARK: App Bar

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
        title: AppLocalizations.of(context)!.privacy,
        action: () {
          Navigator.pop(context);
        });
  }

//========================================================
}
