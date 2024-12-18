import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/permission_manager.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/setting/setting_view_model.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/views/todo/todo_screen.dart';
import 'package:todo_app/views/todo/todo_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load file .env
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['API_URL'] ?? "",
    anonKey: dotenv.env['API_KEY'] ?? "",
  );

  await Alarm.init();

  final lastUserLoginToken = await AuthManager.shared.getUserToken();

  PermissionManager.shared.notificationPermissionRequest();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) =>
              TodoViewModel(ApiProvider.shared, AuthManager.shared)),
      ChangeNotifierProvider(create: (context) => SettingViewModel())
    ],
    child: MainApp(
      lastUserLoginToken: lastUserLoginToken,
    ),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, this.lastUserLoginToken});
  final String? lastUserLoginToken;

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingViewModel>(context);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: settingProvider.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Configs.defaultLocale,
        Configs.viLocale,
      ],
      home: Scaffold(
        body: Center(
          child: widget.lastUserLoginToken != null
              ? Supabase.instance.client.auth.currentSession?.isExpired == false
                  ? const TodoScreen()
                  : const LoginScreen()
              : const LoginScreen(),
        ),
      ),
    );
  }
}
