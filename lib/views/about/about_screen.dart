import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/views/about/about_view_model.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late AboutViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = AboutViewModel();

    _vm.getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _vm,
      builder: (context, child) {
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
                        _bottomDecoration(),

                        const SizedBox(
                          height: 16,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 16,
                        ),

//MARK: App Version Text
                        _appVersionText()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

//MARK: App Version Text

  Widget _appVersionText() {
    return Selector<AboutViewModel, String>(
        builder: (context, version, child) {
          return Text(
            "${AppLocalizations.of(context)!.version}: ${_vm.appVersion}",
            style: Theme.of(context).textTheme.bodySmall,
          );
        },
        selector: (context, viewmodel) => viewmodel.appVersion);
  }

//========================================================
}
