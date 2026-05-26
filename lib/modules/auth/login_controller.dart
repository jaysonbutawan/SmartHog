import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  // Input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable states
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Getters to expose states to the view securely
  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;

  // Logic to toggle password text visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners(); // Triggers a UI redraw for listening widgets
  }

  // Logic to toggle the remember me checkbox
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners(); 
  }

  // Logic to handle authentication process
  void handleLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    // Perform your network validation/API requests here
    print('Processing Login Request...');
    print('User: $username | Pass: [HIDDEN] | Remember Device: $_rememberMe');
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}