import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:green_bonus/main.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 0;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Забыли пароль?',
      'Подтвердите код',
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_step > 0) {
          setState(() => _step--);
          return false;
        }
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonCircle(
                  onPressed: () {
                    if (_step > 0) {
                      setState(() => _step--);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  titles[_step],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AuthColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                if (_step == 0)
                  const Text(
                    'Введите вашу электронную почту, указанную при регистрации, и мы отправим код для восстановления.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AuthColors.muted,
                    ),
                  ),
                const SizedBox(height: 18),
                Expanded(child: _buildStepContent()),
                const SizedBox(height: 14),
                AuthButton(
                  label: 'Продолжить',
                  enabled: _isStepValid(),
                  onPressed: _isStepValid() ? _handleContinue : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthIllustration(icon: Icons.mail_outline_rounded),
          const SizedBox(height: 12),
          AuthField(
            label: 'Электронная почта',
            hint: 'Введите электронную почту',
            controller: _emailController,
            onChanged: () {
              setState(() {});
            },
          ),
        ],
      );
    }

    return VerifyCodeStepForgot(
      onCodeVerified: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResetPasswordPageNew()),
        );
      },
    );
  }

  bool _isStepValid() {
    if (_step == 0) {
      return _emailController.text.contains('@');
    }
    return true;
  }

  void _handleContinue() {
    if (_step < 1) {
      setState(() => _step++);
    }
  }
}

class VerifyCodeStepForgot extends StatefulWidget {
  final VoidCallback onCodeVerified;

  const VerifyCodeStepForgot({
    super.key,
    required this.onCodeVerified,
  });

  @override
  State<VerifyCodeStepForgot> createState() => _VerifyCodeStepForgotState();
}

class _VerifyCodeStepForgotState extends State<VerifyCodeStepForgot> {
  late List<TextEditingController> _codeControllers;
  int _remainingSeconds = 115;
  final String _correctCode = '1234'; // Тестовый код

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(4, (_) => TextEditingController());
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        _startTimer();
      }
    });
  }

  void _checkCode() {
    final enteredCode = _codeControllers.map((c) => c.text).join();

    if (enteredCode == _correctCode) {
      // Код верный - переходим дальше
      // Здесь можно вызвать callback
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неверный код. Попробуйте еще раз'),
          backgroundColor: Colors.red,
        ),
      );
      for (var controller in _codeControllers) {
        controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthIllustration(icon: Icons.lock_outline_rounded),
          const SizedBox(height: 8),
          const Text(
            'Введите 4-значный код, отправленный на вашу электронную почту:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AuthColors.muted,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 3 ? 0 : 8),
                  child: SizedBox(
                    height: 52,
                    child: TextField(
                      controller: _codeControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                        setState(() {});
                        // Автоматическая проверка при вводе 4-й цифры
                        if (index == 3 && value.isNotEmpty) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _checkCode();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AuthColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AuthColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AuthColors.green),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_remainingSeconds > 0)
            Text(
              'Отправить повторно можно будет через $_remainingSeconds секунд',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AuthColors.muted,
              ),
            )
          else
            TextButton(
              onPressed: () {
                setState(() => _remainingSeconds = 115);
                _startTimer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Код отправлен повторно')),
                );
              },
              child: const Text(
                'Отправить код повторно',
                style: TextStyle(
                  color: AuthColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ResetPasswordPageNew extends StatefulWidget {
  const ResetPasswordPageNew({super.key});

  @override
  State<ResetPasswordPageNew> createState() => _ResetPasswordPageNewState();
}

class _ResetPasswordPageNewState extends State<ResetPasswordPageNew> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonCircle(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Создайте пароль',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.text,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthIllustration(icon: Icons.lock_outline_rounded),
                    const SizedBox(height: 8),
                    AuthField(
                      label: 'Пароль',
                      hint: 'Введите пароль',
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: () {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Повтерите пароль',
                      hint: 'Введите пароль',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      onChanged: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AuthButton(
                label: 'Продолжить',
                enabled: canContinue,
                onPressed: canContinue
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Пароль успешно изменен!')),
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
