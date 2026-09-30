import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:green_bonus/main.dart';


class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonCircle(),
              const SizedBox(height: 12),
              const Text(
                'Создайте пароль',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Придумайте надежный пароль для безопасного входа в ваш аккаунт.',
                style: TextStyle(
                  fontSize: 14,
                  color: AuthColors.muted,
                ),
              ),
              const AuthIllustration(icon: Icons.lock_outline_rounded),
              const AuthField(
                label: 'Пароль',
                hint: 'Введите пароль',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const AuthField(
                label: 'Повторите пароль',
                hint: 'Повторите пароль',
                obscureText: true,
              ),
              const Spacer(),
              AuthButton(
                label: 'Продолжить',
                enabled: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
