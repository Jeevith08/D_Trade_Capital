import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<sb.AuthState>(
      stream: sb.Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = sb.Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}

