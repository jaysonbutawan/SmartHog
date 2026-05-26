import 'package:flutter/material.dart';
import 'modules/auth/login_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Hog App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2EAF65)),
        useMaterial3: true,
      ),
      // This is the direct change pointing the app to open your login design first
      home: const LoginPage(), 
    );
  }
}