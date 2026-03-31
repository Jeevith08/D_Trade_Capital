import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '681249716756-nf244rlnbabkjqtafkje7up1dldt2gtf.apps.googleusercontent.com',
  );

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Use signIn for deliberate user sign ins
      var googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // For web, user needs to interact with the rendered button
        // This method should be called after button interaction
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  static GoogleSignIn get googleSignIn => _googleSignIn;
}