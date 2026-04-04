import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/theme_service.dart';
import 'firebase_options.dart';
import 'screens/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp immediately so the Splash Screen renders on Frame 1, avoiding native blank delays
  runApp(const DTradeApp());
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
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_started) {
      _started = true;
      _startSplash();
    }
  }

  Future<void> _startSplash() async {
    const imageProvider = AssetImage('assets/images/logo.jpeg');
    if (mounted) await precacheImage(imageProvider, context);

    if (mounted) {
      setState(() {
        _opacity = 1.0;
      });
    }

    // Initialize Firebase silently in the background while Splash is beautifully visible
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      // Firebase already initialized
    }

    // Give the splash screen a guaranteed minimum showing duration
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthGate(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          child: Hero(
            tag: 'app_logo',
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 260,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}