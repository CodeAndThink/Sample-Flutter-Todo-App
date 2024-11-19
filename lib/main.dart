import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/views/todo/todo_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'configs/configs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Configs.apiSupabaseBaseUrl,
    anonKey: Configs.apiSubabaseKey,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: Center(
          child: TodoScreen(),
        ),
      ),
    );
  }
}
