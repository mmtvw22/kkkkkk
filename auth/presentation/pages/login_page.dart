import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:green_bonus/main.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        _emailController.text.contains('@') && _passwordController.text.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonCircle(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Вход',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Добро пожаловать! Введите данные для авторизации.',
                style: TextStyle(
                  fontSize: 14,
                  color: AuthColors.muted,
                ),
              ),
              const SizedBox(height: 18),
              const AuthIllustration(icon: Icons.lock_outline_rounded),
              const SizedBox(height: 8),
              AuthField(
                label: 'Электронная почта',
                hint: 'Введите электронную почту',
                controller: _emailController,
                onChanged: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              AuthField(
                label: 'Пароль',
                hint: 'Введите пароль',
                controller: _passwordController,
                obscureText: !_showPassword,
                onChanged: () {
                  setState(() {});
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                  child: Icon(
                    _showPassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: AuthColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Забыли пароль?',
                    style: TextStyle(
                      color: AuthColors.greenDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthButton(
                label: 'Продолжить',
                enabled: canContinue,
                onPressed: canContinue
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Вы вошли в систему!')),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Уже есть аккаунт? Зарегистрироваться',
                    style: TextStyle(
                      color: AuthColors.greenDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}