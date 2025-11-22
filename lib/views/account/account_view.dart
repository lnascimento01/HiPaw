import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/firestore_repository.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _updatingEmail = false;
  bool _updatingPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final l10n = AppLocalizations.of(context);
    if (user == null && !auth.isVisitor) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.translate('account_title'))),
        body: _AccountEmptyState(
          message: l10n.translate('visitor_profile_message'),
          actionLabel: l10n.translate('account_login_button'),
          onTap: () => context.go('/login'),
        ),
      );
    }
    if (auth.isVisitor) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.translate('account_title'))),
        body: _AccountEmptyState(
          message: l10n.translate('account_visitor_message'),
          actionLabel: l10n.translate('account_login_button'),
          onTap: () => context.go('/login'),
        ),
      );
    }
    final email = user?.email ?? '';
    if (_emailController.text != email) {
      _emailController.text = email;
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('account_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.translate('account_profile'), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.translate('account_email_label')),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _updatingEmail
                  ? null
                  : () async {
                      setState(() => _updatingEmail = true);
                      await ref.read(firestoreRepositoryProvider).updateEmail(_emailController.text.trim());
                      if (mounted) setState(() => _updatingEmail = false);
                    },
              child: _updatingEmail
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.translate('account_update_email')),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.translate('account_new_password_label')),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _updatingPassword
                  ? null
                  : () async {
                      if (_passwordController.text.length < 6) return;
                      setState(() => _updatingPassword = true);
                      await ref.read(firestoreRepositoryProvider).updatePassword(_passwordController.text);
                      if (mounted) {
                        setState(() => _updatingPassword = false);
                        _passwordController.clear();
                      }
                    },
              child: _updatingPassword
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.translate('account_update_password')),
            ),
            const SizedBox(height: 32),
            FilledButton.tonal(
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              child: Text(l10n.translate('account_logout')),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountEmptyState extends StatelessWidget {
  const _AccountEmptyState({required this.message, required this.actionLabel, required this.onTap});

  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onTap, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
