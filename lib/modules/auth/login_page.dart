import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_controller.dart'; // Import your controller

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Instance of our controller
  final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose(); // Cleans up text fields automatically
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image Layer
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1604848698030-c434ba0861db?q=80&w=1000'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.05)),

          // 2. Login Card Layer
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          color: const Color(0xFF2EAF65).withOpacity(0.7),
                          width: 2.5,
                        ),
                      ),
                      // ListenableBuilder listens to changes emitted by our Controller class
                      child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App Branding Header
                              const Text(
                                'Welcome Back',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'SMART HOG',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                              const SizedBox(height: 16),
                              
                              // Logo Assets Placeholder
                              _buildLogoPlaceholder(),
                              const SizedBox(height: 16),
                              
                              const Text(
                                'AUTOMATED FEEDING & MONITORING',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 32),

                              // Username Field
                              TextField(
                                controller: _controller.usernameController,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                decoration: _buildInputDecoration(hint: 'Username'),
                              ),
                              const SizedBox(height: 20),

                              // Password Field
                              TextField(
                                controller: _controller.passwordController,
                                obscureText: _controller.obscurePassword,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                decoration: _buildInputDecoration(
                                  hint: 'Password',
                                  suffix: IconButton(
                                    icon: Icon(
                                      _controller.obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: const Color(0xFF2EAF65),
                                    ),
                                    onPressed: _controller.togglePasswordVisibility,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Keep Account / Reset Form controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _controller.rememberMe,
                                          activeColor: const Color(0xFF2EAF65),
                                          side: const BorderSide(color: Color(0xFF2EAF65), width: 2),
                                          onChanged: (bool? value) {
                                            _controller.setRememberMe(value ?? false);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Remember this device',
                                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 12, 
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Action Execution
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _controller.handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF12A153),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
                                  ),
                                  child: const Text('Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Visual component refactors for clean scannability
  InputDecoration _buildInputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 18),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.black54, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF2EAF65), width: 2),
      ),
      suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12.0), child: suffix) : null,
    );
  }

  Widget _buildLogoPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text('SMART HOG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 2),
            Icon(Icons.wb_sunny_outlined, color: Colors.orange[700], size: 16),
            Icon(Icons.gite_outlined, color: Colors.brown[700], size: 24),
          ],
        ),
      ],
    );
  }
}