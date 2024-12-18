import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/gen/assets.gen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.sampleAbout,
                      overflow: TextOverflow.clip,
                    ),
                    const SizedBox(
                      height: 24,
                    ),

//MARK: Bottom Decoration
                    _bottomDecoration()
                  ],
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
        title: AppLocalizations.of(context)!.about,
        action: () {
          Navigator.pop(context);
        });
  }

//========================================================

//MARK: Bottom Decoration

  Widget _bottomDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          Assets.icons.heart.path,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
        ),
        Image.asset(
          Assets.icons.plus.path,
          height: 24,
          width: 24,
          fit: BoxFit.cover,
        ),
        Image.asset(
          Assets.images.logo.path,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
        ),
        Image.asset(
          Assets.icons.plus.path,
          height: 24,
          width: 24,
          fit: BoxFit.cover,
        ),
        Image.asset(
          Assets.icons.coffeeCup.path,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

//========================================================
}
