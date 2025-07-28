import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/constants.dart';
import 'providers/shopping_list_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ListeGoApp());
}

class ListeGoApp extends StatelessWidget {
  const ListeGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          ThemeMode themeMode;
          switch (settingsProvider.themeMode) {
            case 'dark':
              themeMode = ThemeMode.dark;
              break;
            case 'light':
              themeMode = ThemeMode.light;
              break;
            default:
              themeMode = ThemeMode.system;
          }
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(AppConstants.primaryColorValue),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(AppConstants.primaryColorValue),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
} 