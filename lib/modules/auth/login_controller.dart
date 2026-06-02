import 'package:flutter/material.dart';
import 'package:smarthog/navigation/bottom_nav_page.dart';
import 'package:smarthog/modules/auth/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final LoginService loginService;

  LoginController({
    required this.loginService,
  });

  // Input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable states
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context) async {
  final email = usernameController.text.trim();
  final password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    debugPrint('❌ LOGIN FAILED: Email or password is empty');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email and password are required'),
      ),
    );
    return;
  }

  try {
    _isLoading = true;
    notifyListeners();

    debugPrint('🔐 LOGIN ATTEMPT: $email');

    final response = await loginService.login(email, password);

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success == true) {
      debugPrint('✅ LOGIN SUCCESS: $email');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.data.token);

      debugPrint('💾 TOKEN SAVED SUCCESSFULLY');

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNavPage(),
        ),
      );
    } else {
      debugPrint('❌ LOGIN FAILED: ${response.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
        ),
      );
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();

    debugPrint('⚠️ LOGIN ERROR: $e');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}