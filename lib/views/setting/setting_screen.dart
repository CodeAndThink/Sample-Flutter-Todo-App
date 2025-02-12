import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/common/views/custom_list_tile.dart';
import 'package:todo_app/common/views/custom_separated_part_title.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/utils/gif_overlay_show.dart';
import 'package:todo_app/utils/show_alert_dialog.dart';
import 'package:todo_app/views/about/about_screen.dart';
import 'package:todo_app/views/analysis/analysis_screen.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:todo_app/views/history/history_screen.dart';
import 'package:todo_app/views/privacy/privacy_screen.dart';
import 'package:todo_app/views/profile/profile_screen.dart';
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
                padding: const EdgeInsets.all(16),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: CustomSeparatedPartTitle(
                            title: AppLocalizations.of(context)!.profile)),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 0) {
//MARK: Navigate To Profile Screen
                          return _navigateProfileScreenListTile(context);
                        }
                        if (index == 1) {
//MARK: Navigate To Analysis Screen
                          return _navigateAnalysisScreenListTile(context);
                        }
                        if (index == 2) {
//MARK: Navigate To History Screen
                          return _navigateHistoryScreenListTile(context);
                        }

                        return null;
                      },
                      childCount: 3,
                    )),
                    SliverToBoxAdapter(
                        child: CustomSeparatedPartTitle(
                            title: AppLocalizations.of(context)!.settings)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
//MARK: Change Language Button
                            return _changeLanguageSwitchListTile(context);
                          } else if (index == 1) {
//MARK: Change Notification Setting Button
                            return _changeNotificationSettingSwitchListTile(
                                context);
                          }
                          return null;
                        },
                        childCount: 2,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: CustomSeparatedPartTitle(
                            title: AppLocalizations.of(context)!.about)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
//MARK: Navigate To Privacy Screen
                            return _navigatePrivacyScreenListTile(context);
                          } else if (index == 1) {
//MARK: Navigate To About Screen
                            return _navigateAboutScreenListTile(context);
                          } else if (index == 2) {
//MARK: Buy Me Coffee Button
                            return _buyMeCoffeeListTile(context);
                          }

                          return null;
                        },
                        childCount: 3,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: CustomSeparatedPartTitle(
                            title: AppLocalizations.of(context)!
                                .advancedSettings)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
//MARK: Logout And Navigate To Login Screen
                            return _logoutListTile(context);
                          }

                          return null;
                        },
                        childCount: 1,
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

//MARK: Navigate To Profile Screen

  Widget _navigateProfileScreenListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.profile),
      leading: Image.asset(
        Assets.icons.profile.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      },
    );
  }

//========================================================

//MARK: Navigate To Analysis Screen

  Widget _navigateAnalysisScreenListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.statsScreenTitle),
      leading: Image.asset(
        Assets.icons.chart.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AnalysisScreen()));
      },
    );
  }

//========================================================

//MARK: Navigate To History Screen

  Widget _navigateHistoryScreenListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.historyScreenTitle),
      leading: Image.asset(
        Assets.icons.history.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()));
      },
    );
  }

//========================================================

//MARK: Change Language Button

  Widget _changeLanguageSwitchListTile(BuildContext context) {
    return Selector<SettingViewModel, bool>(
        selector: (context, viewmodel) =>
            viewmodel.currentLocale.languageCode !=
            Configs.defaultLocale.languageCode,
        builder: (context, isNotEng, child) {
          return CustomListTile(
              iconPath: Assets.icons.translation.path,
              title: AppLocalizations.of(context)!.languageChange,
              value: isNotEng,
              activeThumbImage: AssetImage(Assets.icons.vn.path),
              activeTrackColor: const Color(0xFFF48F8A),
              inactiveThumbImage: AssetImage(Assets.icons.us.path),
              inactiveTrackColor: const Color(0xFF5256B6),
              action: () {
                Provider.of<SettingViewModel>(context, listen: false)
                    .toggleLocale();
              });
        });
  }

//========================================================

//MARK: Change Notification Setting Button

  Widget _changeNotificationSettingSwitchListTile(BuildContext context) {
    return Selector<SettingViewModel, bool>(
        selector: (context, viewmodel) => viewmodel.isNotiEnable,
        builder: (context, isEnable, child) {
          return CustomListTile(
              iconPath: Assets.icons.bell.path,
              title: AppLocalizations.of(context)!.enableNotification,
              value: isEnable,
              action: () {
                Provider.of<SettingViewModel>(context, listen: false)
                    .toggleNoti();
              });
        });
  }

//========================================================

//MARK: Navigate To Privacy Screen

  Widget _navigatePrivacyScreenListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.privacy),
      leading: Image.asset(
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

  Widget _navigateAboutScreenListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.about),
      leading: Image.asset(
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

  Widget _buyMeCoffeeListTile(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buyMeACoffee),
      leading: Image.asset(
        Assets.icons.coffeeCup.path,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ),
      onTap: () {
        showOverlay(context, Assets.gifs.love.path);
      },
    );
  }

//========================================================

//MARK: Logout Button

  Widget _logoutListTile(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.logout,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Configs.deleteActionColor),
      ),
      leading: SvgPicture.asset(
        Assets.icons.signout,
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
            Configs.deleteActionColor, BlendMode.srcATop),
      ),
      onTap: () {
        showAlert(
            context,
            AppLocalizations.of(context)!.logoutConfirmationTitle,
            AppLocalizations.of(context)!.logoutConfirmationMessage,
            () {
              Provider.of<SettingViewModel>(context, listen: false).signout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            AppLocalizations.of(context)!.logoutConfirmationConfirm,
            () {
              Navigator.pop(context);
            },
            AppLocalizations.of(context)!.logoutConfirmationCancel);
      },
    );
  }

//========================================================
}
