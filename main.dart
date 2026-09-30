import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/register_page.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GreenBonusApp());
}

class GreenBonusApp extends StatelessWidget {
  const GreenBonusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Bonus',
      theme: AppTheme.theme,
      home: const RegisterPage(),
    );
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F3),
        colorScheme: ColorScheme.fromSeed(seedColor: AuthColors.green),
        fontFamily: 'Roboto',
      );
}

class AuthColors {
  static const green = Color(0xFF7FCB68);
  static const greenDark = Color(0xFF5DAA5C);
  static const text = Color(0xFF1D1D1D);
  static const muted = Color(0xFF7B7B7B);
  static const border = Color(0xFFD7DDE0);
  static const disabled = Color(0xFFD7D9D6);
  static const soft = Color(0xFFF5F6F5);
}
