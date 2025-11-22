import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_buttons.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../core/ui/widgets/hi_paws_text_field.dart';
import '../../l10n/app_localizations.dart';

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
      body: HiPawsPatternBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: HiPawsSpacing.defaultHorizontal,
                vertical: HiPawsSpacing.defaultVertical,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.translate('login_title_new'),
                        textAlign: TextAlign.center,
                        style: HiPawsTextStyles.screenTitle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('login_prompt'),
                        textAlign: TextAlign.center,
                        style: HiPawsTextStyles.body,
                      ),
                      const SizedBox(height: 32),
                      Text(l10n.translate('email'),
                          style: HiPawsTextStyles.orangeSectionLabel),
                      const SizedBox(height: 6),
                      HiPawsTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: l10n.translate('email_hint'),
                        validator: (value) =>
                            value != null && value.contains('@')
                                ? null
                                : l10n.translate('invalid_email'),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.translate('password'),
                          style: HiPawsTextStyles.orangeSectionLabel),
                      const SizedBox(height: 6),
                      HiPawsTextField(
                        controller: _passwordController,
                        hintText: l10n.translate('password_hint'),
                        obscureText: _obscurePassword,
                        validator: (value) =>
                            (value != null && value.length >= 6)
                                ? null
                                : l10n.translate('invalid_password'),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: HiPawsColors.textSecondary,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
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
                            child: Text(l10n.translate('create_account'),
                                style: HiPawsTextStyles.smallLink),
                          ),
                          TextButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(l10n.translate('forgot_password'))),
                            ),
                            child: Text(l10n.translate('forgot_password'),
                                style: HiPawsTextStyles.smallLink),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      HiPawsPrimaryButton(
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
                      const SizedBox(height: 16),
                      HiPawsSecondaryButton(
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
