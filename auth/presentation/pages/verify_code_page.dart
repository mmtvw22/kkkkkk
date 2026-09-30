import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:green_bonus/main.dart';



class VerifyCodePage extends StatelessWidget {
  const VerifyCodePage({super.key});

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
                'Введите код',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Введите 4-значный код, отправленный на вашу электронную почту.',
                style: TextStyle(
                  fontSize: 14,
                  color: AuthColors.muted,
                ),
              ),
              const SizedBox(height: 26),
              const CodeFields(),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'Отправить повторно можно будет через 115 секунд',
                  style: TextStyle(
                    fontSize: 12,
                    color: AuthColors.muted,
                  ),
                ),
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
