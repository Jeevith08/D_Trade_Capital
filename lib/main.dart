import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/theme_service.dart';
import 'screens/premium_splash_screen.dart';
import 'core/constants/api_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: ApiConstants.supabaseUrl,
    anonKey: ApiConstants.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: DTradeApp(),
    ),
  );
}

class DTradeApp extends StatelessWidget {
  const DTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DTrade',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.amber,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const PremiumSplashScreen(),
        );
      },
    );
  }
}
