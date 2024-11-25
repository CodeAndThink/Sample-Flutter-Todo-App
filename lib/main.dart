import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/views/add_new_task/add_new_task_viewmodel.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/views/auth/login/login_viewmodel.dart';
import 'package:todo_app/views/auth/register/register_viewmodel.dart';
import 'package:todo_app/views/todo/todo_viewmodel.dart';
import 'configs/configs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Configs.apiSupabaseBaseUrl,
    anonKey: Configs.apiSubabaseKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => TodoViewmodel(
              ApiProvider.shared, UserManager.shared, AuthManager.shared)),
      ChangeNotifierProvider(
          create: (context) => LoginViewmodel(
              ApiProvider.shared, UserManager.shared, AuthManager.shared)),
      ChangeNotifierProvider(
          create: (context) => RegisterViewmodel(ApiProvider.shared)),
      ChangeNotifierProvider(
          create: (context) => AddNewTaskViewmodel(ApiProvider.shared, null)),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

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
    });
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
          child: LoginScreen(toggleLocale: _toggleLocale),
        ),
      ),
    );
  }
}
