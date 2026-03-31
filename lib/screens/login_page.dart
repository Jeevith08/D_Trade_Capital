import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
// import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  bool _isSignUp = false;

  static const Color bg = Color(0xFF070300);
  static const Color gold = Color(0xFFFFB800);
  static const Color border = Color(0xFF3A2500);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();

      if (!mounted) return;

      // AuthGate stream will handle navigation automatically
      if (userCredential?.user != null) {
        // Do nothing, stream builder updates the UI
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // AuthGate stream will handle navigation automatically
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _createAccount() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // AuthGate stream will handle navigation automatically
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Account creation failed')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: VerticalAccentLine(),
            ),
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Hero(
                        tag: 'app_logo',
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          width: 220,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: gold),
                        ),
                        child: const Text(
                          'INSTITUTIONAL',
                          style: TextStyle(
                            color: gold,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 44),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Terminal '),
                            TextSpan(
                              text: 'Access',
                              style: TextStyle(
                                color: gold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isSignUp ? 'CREATE SECURE ACCOUNT' : 'AUTHENTICATE TO PROCEED',
                        style: const TextStyle(
                          color: Colors.white70,
                          letterSpacing: 2.5,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          "DTrade Capital deploys behavioral AI infrastructure — Trader Genome™, Emotional Volatility Index, Behavioral Shield, and AI Guardian — to detect irrational decisions before they execute. Built for institutional-grade traders who demand edge.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            height: 1.6,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      const GoogleSignInButtonWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: const [
                          Expanded(child: Divider(color: border)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR PROTOCOL AUTH',
                              style: TextStyle(
                                color: Colors.white70,
                                letterSpacing: 2,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: border)),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EMAIL ADDRESS',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _inputBox(
                        controller: emailController,
                        hint: 'you@example.com',
                        icon: Icons.mail_outline,
                        obscure: false,
                      ),
                      const SizedBox(height: 22),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'PASSWORD',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _inputBox(
                        controller: passwordController,
                        hint: '••••••••••',
                        icon: Icons.lock_outline,
                        obscure: obscurePassword,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: const RoundedRectangleBorder(),
                          ),
                          onPressed: isLoading ? null : (_isSignUp ? _createAccount : _signInWithEmail),
                          child: Text(
                            isLoading ? 'PLEASE WAIT...' : (_isSignUp ? 'SIGN UP' : 'LOGIN'),
                            style: const TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isSignUp ? 'Already have an account? ' : 'No active account? ',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: isLoading ? null : () {
                              setState(() {
                                _isSignUp = !_isSignUp;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: gold,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              _isSignUp ? 'Login' : 'Sign up',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Privacy  ·  Terms',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required IconData icon,
    required Color borderColor,
    required Color textColor,
    VoidCallback? onTap,
    Color fillColor = const Color(0xFF0C0803),
  }) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: obscure ? TextInputType.text : TextInputType.emailAddress,
      textInputAction: obscure ? TextInputAction.done : TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.black,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: gold),
        ),
      ),
    );
  }
}

class VerticalAccentLine extends StatelessWidget {
  const VerticalAccentLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: const Color(0xFF3A2500),
    );
  }
}

class GoogleSignInButtonWidget extends StatefulWidget {
  const GoogleSignInButtonWidget({super.key});

  @override
  State<GoogleSignInButtonWidget> createState() => _GoogleSignInButtonWidgetState();
}

class _GoogleSignInButtonWidgetState extends State<GoogleSignInButtonWidget> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();
        
      if (userCredential?.user != null && mounted) {
        // AuthGate stream will handle navigation automatically
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: _isLoading ? null : _handleGoogleSignIn,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF0C0803),
          border: Border.all(color: const Color(0xFF3A2500)),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'SIGN IN WITH GOOGLE',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}