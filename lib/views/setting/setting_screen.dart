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
//MARK: Change Language Button
                            return _changeLanguageSwitchListTile();
                          } else if (index == 1) {
//MARK: Change Notification Setting Button
                            return _changeNotificationSettingSwitchListTile();
                          } else if (index == 2) {
//MARK: Navigate To Privacy Screen
                            return _navigatePrivacyScreenListTile();
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
//MARK: Navigate To About Screen
                            return _navigateAboutScreenListTile();
                          } else if (index == 1) {
//MARK: Buy Me Coffee Button                            
                            return _buyMeCoffeeListTile();
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

//MARK: Change Language Button

  Widget _changeLanguageSwitchListTile() {
    return Selector<SettingViewModel, bool>(
        selector: (context, viewmodel) =>
            viewmodel.currentLocale.languageCode != 'en',
        builder: (context, isNotEng, child) {
          return SwitchListTile(
            activeThumbImage: AssetImage(Assets.icons.vn.path),
            activeTrackColor: const Color(0xFFF48F8A),
            inactiveThumbImage: AssetImage(Assets.icons.us.path),
            inactiveTrackColor: const Color(0xFF5256B6),
            title: Text(AppLocalizations.of(context)!.languageChange),
            value: isNotEng,
            onChanged: (bool value) {
              Provider.of<SettingViewModel>(context, listen: false)
                  .toggleLocale();
            },
          );
        });
  }

//========================================================

//MARK: Change Notification Setting Button

  Widget _changeNotificationSettingSwitchListTile() {
    return Selector<SettingViewModel, bool>(
        selector: (context, viewmodel) => viewmodel.isNotiEnable,
        builder: (context, isEnable, child) {
          return SwitchListTile(
            title: Text(AppLocalizations.of(context)!.enableNotification),
            value: isEnable,
            onChanged: (bool value) {
              Provider.of<SettingViewModel>(context, listen: false)
                  .toggleNoti();
            },
          );
        });
  }

//========================================================

//MARK: Navigate To Privacy Screen

  Widget _navigatePrivacyScreenListTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.privacy),
      trailing: Image.asset(
        Assets.icons.privacyPolicy.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivacyScreen()));
      },
    );
  }

//========================================================

//MARK: Navigate To About Screen

  Widget _navigateAboutScreenListTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.about),
      trailing: Image.asset(
        Assets.icons.info.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AboutScreen()));
      },
    );
  }

//========================================================

//MARK: Buy Me Coffee Button

  Widget _buyMeCoffeeListTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buyMeACoffee),
      trailing: Image.asset(
        Assets.icons.coffeeCup.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {},
    );
  }

//========================================================
}
