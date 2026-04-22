import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class SupabaseAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with Email and Password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with Email and Password
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google
  static Future<void> signInWithGoogle() async {
    const webClientId = '681249716756-utm6v4jofdpsj7v0j3uhvktdgo5gavt8.apps.googleusercontent.com';
    
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? webClientId : null,
      serverClientId: kIsWeb ? null : webClientId,
    );

    
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Google Sign-in failed: Missing tokens';
    }

    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }


  /// Sign in with Discord using OAuth
  static Future<bool> signInWithDiscord() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.discord,
      redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
    );
  }

  /// Get current user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    return response;
  }

  /// Record a new trade
  static Future<void> placeTrade({
    required String symbol,
    required String type,
    required double amount,
    required double price,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await _supabase.from('trade').insert({
      'user_id': user.id,
      'symbol': symbol,
      'type': type,
      'amount': amount,
      'price': price,
    });
  }

  /// Send a password reset email
  static Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// Sign out from Supabase
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Get current session
  static Session? get currentSession => _supabase.auth.currentSession;

  /// Get current user
  static User? get currentUser => _supabase.auth.currentUser;
}
