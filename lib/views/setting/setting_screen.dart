import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/views/about/about_screen.dart';
import 'package:todo_app/views/privacy/privacy_screen.dart';
import 'package:todo_app/views/setting/setting_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            CustomAppBar(
                title: AppLocalizations.of(context)!.settings,
                action: () {
                  Navigator.pop(context);
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return Selector<SettingViewModel, bool>(
                                selector: (context, viewmodel) =>
                                    viewmodel.currentLocale.languageCode !=
                                    'en',
                                builder: (context, isNotEng, child) {
                                  return SwitchListTile(
                                    activeThumbImage:
                                        AssetImage(Assets.icons.vn.path),
                                    activeTrackColor: const Color(0xFFF48F8A),
                                    inactiveThumbImage:
                                        AssetImage(Assets.icons.us.path),
                                    inactiveTrackColor: const Color(0xFF5256B6),
                                    title: Text(AppLocalizations.of(context)!
                                        .languageChange),
                                    value: isNotEng,
                                    onChanged: (bool value) {
                                      Provider.of<SettingViewModel>(context,
                                              listen: false)
                                          .toggleLocale();
                                    },
                                  );
                                });
                          } else if (index == 1) {
                            return Selector<SettingViewModel, bool>(
                                selector: (context, viewmodel) =>
                                    viewmodel.isNotiEnable,
                                builder: (context, isEnable, child) {
                                  return SwitchListTile(
                                    title: Text(AppLocalizations.of(context)!
                                        .enableNotification),
                                    value: isEnable,
                                    onChanged: (bool value) {
                                      Provider.of<SettingViewModel>(context,
                                              listen: false)
                                          .toggleNoti();
                                    },
                                  );
                                });
                          } else if (index == 2) {
                            return ListTile(
                              title:
                                  Text(AppLocalizations.of(context)!.privacy),
                              trailing: Image.asset(
                                Assets.icons.privacyPolicy.path,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyScreen()));
                              },
                            );
                          }
                          return null;
                        },
                        childCount: 3,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return ListTile(
                              title: Text(AppLocalizations.of(context)!.about),
                              trailing: Image.asset(
                                Assets.icons.info.path,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AboutScreen()));
                              },
                            );
                          } else if (index == 1) {
                            return ListTile(
                              title: Text(
                                  AppLocalizations.of(context)!.buyMeACoffee),
                              trailing: Image.asset(
                                Assets.icons.coffeeCup.path,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {},
                            );
                          }

                          return null;
                        },
                        childCount: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
