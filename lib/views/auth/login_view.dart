import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/pattern_background.dart';
import '../../widgets/themed_buttons.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        l10n.translate('login_title_new'),
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkBlue,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('login_prompt'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      _InputWrapper(
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: l10n.translate('email_hint'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            labelText: null,
                          ),
                          validator: (value) =>
                              value != null && value.contains('@')
                                  ? null
                                  : l10n.translate('invalid_email'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InputWrapper(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: l10n.translate('password_hint'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: AppColors.textSecondary,
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) =>
                              (value != null && value.length >= 6)
                                  ? null
                                  : l10n.translate('invalid_password'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(l10n.translate('create_account'))),
                            ),
                            child: Text(l10n.translate('create_account')),
                          ),
                          TextButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(l10n.translate('forgot_password'))),
                            ),
                            child: Text(l10n.translate('forgot_password')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OrangeButton(
                        label: l10n.translate('login_button'),
                        onPressed: authState.loading
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .login(_emailController.text.trim(),
                                          _passwordController.text);
                                }
                              },
                      ),
                      const SizedBox(height: 12),
                      GreenButton(
                        label: l10n.translate('login_guest'),
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .loginAsVisitor();
                          if (context.mounted) context.go('/home');
                        },
                      ),
                      if (authState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            authState.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 28),
                      const _BottomIllustration(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomIllustration extends StatelessWidget {
  const _BottomIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.list_alt_outlined, color: Colors.white),
          Icon(Icons.pets, color: Colors.white),
          Icon(Icons.settings_outlined, color: Colors.white),
        ],
      ),
    );
  }
}

class _InputWrapper extends StatelessWidget {
  const _InputWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
