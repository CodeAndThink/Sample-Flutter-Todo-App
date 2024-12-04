import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/setting_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/views/todo/todo_screen.dart';
import 'package:todo_app/views/todo/todo_view_model.dart';
import 'configs/configs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Configs.apiSupabaseBaseUrl,
    anonKey: Configs.apiSubabaseKey,
  );

  // await Alarm.init();

  final lastLocale = await SettingManager.shared.getUserLocale();

  final lastUserLogin = await UserManager.shared.getUserData();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => TodoViewModel(
              ApiProvider.shared, UserManager.shared, AuthManager.shared)),
    ],
    child: MainApp(
      lastLocale: lastLocale,
      lastUserLogin: lastUserLogin,
    ),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.lastLocale, this.lastUserLogin});
  final Locale lastLocale;
  final UserModel? lastUserLogin;

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  Locale _locale = const Locale('en', 'US');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('vi', 'VN')
          : const Locale('en', 'US');
      SettingManager.shared
          .saveUserLocale(_locale.languageCode, _locale.countryCode!);
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = widget.lastLocale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      home: Scaffold(
        body: Center(
          child: widget.lastUserLogin != null
              ? Supabase.instance.client.auth.currentSession!.isExpired == false
                  ? TodoScreen(toggleLocale: _toggleLocale)
                  : LoginScreen(toggleLocale: _toggleLocale)
              : LoginScreen(toggleLocale: _toggleLocale),
        ),
      ),
    );
  }
}
