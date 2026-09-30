import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:green_bonus/main.dart';
import 'login_page.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _translations = {
    'Русский': {
      'Откуда вы?': 'Откуда вы?',
      'Введите электронную почту': 'Введите электронную почту',
      'Подтвердите код': 'Подтвердите код',
      'Создайте пароль': 'Создайте пароль',
      'Выберите город': 'Выберите город',
      'Выберите язык': 'Выберите язык',
      'Продолжить': 'Продолжить',
      'Уже есть аккаунт? Войти': 'Уже есть аккаунт? Войти',
      'Я принимаю условия': 'Я принимаю условия пользовательского соглашения и политики конфиденциальности',
    },
    'Кыргызча': {
      'Откуда вы?': 'Кайдан сиз?',
      'Введите электронную почту': 'Электрондук почтаңызды киргизиңиз',
      'Подтвердите код': 'Кодду тастыктаңыз',
      'Создайте пароль': 'Сыр сөздү түзүңүз',
      'Выберите город': 'Шахарды тандаңыз',
      'Выберите язык': 'Тилди тандаңыз',
      'Продолжить': 'Улантуу',
      'Уже есть аккаунт? Войти': 'Акчасы барбы? Кирүү',
      'Я принимаю условия': 'Колдонуучу келишимин жана купуялуулук саясатын кабыл алам',
    },
    'English': {
      'Откуда вы?': 'Where are you from?',
      'Введите электронную почту': 'Enter your email',
      'Подтвердите код': 'Confirm code',
      'Создайте пароль': 'Create password',
      'Выберите город': 'Select city',
      'Выберите язык': 'Select language',
      'Продолжить': 'Continue',
      'Уже есть аккаунт? Войти': 'Already have an account? Login',
      'Я принимаю условия': 'I accept the terms of service and privacy policy',
    },
  };

  static String translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _step = 0;
  String _selectedCity = '';
  String _selectedLanguage = 'Русский';
  late TextEditingController _emailController;
  bool _acceptedTerms = false;

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
      AppLocalizations.translate('Откуда вы?', _selectedLanguage),
      AppLocalizations.translate('Введите электронную почту', _selectedLanguage),
      AppLocalizations.translate('Подтвердите код', _selectedLanguage),
      AppLocalizations.translate('Создайте пароль', _selectedLanguage),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_step > 0) {
          setState(() => _step--);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_step > 0)
                  BackButtonCircle(
                    onPressed: () {
                      setState(() => _step--);
                    },
                  )
                else
                  const SizedBox(height: 34),
                const SizedBox(height: 12),
                Text(
                  titles[_step],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AuthColors.text,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(child: _buildStepContent()),
                const SizedBox(height: 14),
                AuthButton(
                  label: AppLocalizations.translate('Продолжить', _selectedLanguage),
                  enabled: _isStepValid(),
                  onPressed: _isStepValid() ? _handleContinue : null,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: Text(
                      AppLocalizations.translate('Уже есть аккаунт? Войти', _selectedLanguage),
                      style: const TextStyle(
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
      ),
    );
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthIllustration(icon: Icons.location_on_outlined),
          const SizedBox(height: 16),
          ChoiceTile(
            title: _selectedCity.isEmpty
                ? AppLocalizations.translate('Выберите город', _selectedLanguage)
                : _selectedCity,
            selected: _selectedCity.isNotEmpty,
            onTap: () => _showCityBottomSheet(),
          ),
          const SizedBox(height: 8),
          ChoiceTile(
            title: _selectedLanguage,
            selected: true,
            onTap: () => _showLanguageBottomSheet(),
          ),
        ],
      );
    }

    if (_step == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthIllustration(icon: Icons.mail_outline_rounded),
          const SizedBox(height: 4),
          AuthField(
            label: AppLocalizations.translate('Введите электронную почту', _selectedLanguage),
            hint: AppLocalizations.translate('Введите электронную почту', _selectedLanguage),
            controller: _emailController,
            onChanged: () {
              setState(() {});
            },
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              // Открыть ссылку на условия
            },
            child: Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() => _acceptedTerms = value ?? false);
                  },
                  activeColor: AuthColors.green,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _acceptedTerms = !_acceptedTerms);
                    },
                    child: Text(
                      AppLocalizations.translate('Я принимаю условия', _selectedLanguage),
                      style: const TextStyle(
                        color: AuthColors.muted,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_step == 2) {
      return VerifyCodeStep(
        onCodeVerified: () {
          setState(() => _step++);
        },
        language: _selectedLanguage,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AuthIllustration(icon: Icons.lock_outline_rounded),
        const SizedBox(height: 4),
        const AuthField(
          label: 'Пароль',
          hint: 'Введите пароль',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        const AuthField(
          label: 'Повтерите пароль',
          hint: 'Введите пароль',
          obscureText: true,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(color: AuthColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google (заглушка)')),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(color: AuthColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Apple (заглушка)')),
                    );
                  },
                  child: const Center(
                    child: Icon(
                      Icons.apple,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCityBottomSheet() {
    final cities = ['Ош', 'Бишкек', 'Манас', 'Нарын', 'Баткен'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.translate('Выберите город', _selectedLanguage),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AuthColors.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...cities.map((city) => ChoiceTile(
                title: city,
                selected: _selectedCity == city,
                onTap: () {
                  setState(() => _selectedCity = city);
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    final languages = [
      {'name': 'Русский', 'flag': '🇷🇺'},
      {'name': 'Кыргызча', 'flag': '🇰🇬'},
      {'name': 'English', 'flag': '🇬🇧'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.translate('Выберите язык', _selectedLanguage),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AuthColors.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...languages.map((lang) => ChoiceTile(
                title: '${lang['flag']} ${lang['name']}',
                selected: _selectedLanguage == lang['name'],
                onTap: () {
                  setState(() => _selectedLanguage = lang['name'] as String);
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  bool _isStepValid() {
    switch (_step) {
      case 0:
        return _selectedCity.isNotEmpty && _selectedLanguage.isNotEmpty;
      case 1:
        return _emailController.text.contains('@') && _acceptedTerms;
      case 2:
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _handleContinue() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация завершена!')),
      );
    }
  }
}

class VerifyCodeStep extends StatefulWidget {
  final VoidCallback onCodeVerified;
  final String language;

  const VerifyCodeStep({
    super.key,
    required this.onCodeVerified,
    required this.language,
  });

  @override
  State<VerifyCodeStep> createState() => _VerifyCodeStepState();
}

class _VerifyCodeStepState extends State<VerifyCodeStep> {
  late List<TextEditingController> _codeControllers;
  int _remainingSeconds = 115;
  final String _correctCode = '1234';

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
      widget.onCodeVerified();
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