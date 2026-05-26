import 'package:flutter/material.dart';
import 'package:smarthog/navigation/bottom_nav_page.dart';
import 'package:smarthog/modules/auth/login_service.dart';
class LoginController extends ChangeNotifier {
  final LoginService loginService;

  LoginController({
    required this.loginService,
  });

  // Input fields
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

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

      final response = await loginService.login(
        email,
        password,
      );

      _isLoading = false;
      notifyListeners();

      if (response.success == true) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomNavPage(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
            ),
          ),
        );

      }

    } catch (e) {

      _isLoading = false;
      notifyListeners();

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