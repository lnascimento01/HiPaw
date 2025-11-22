import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/admin_data_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/app_user.dart';

class AdminUsersView extends ConsumerStatefulWidget {
  const AdminUsersView({super.key});

  @override
  ConsumerState<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends ConsumerState<AdminUsersView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final adminState = ref.watch(adminControllerProvider);
    final usersAsync = ref.watch(adminUsersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('admin_users'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.translate('create_user'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('name'))),
          const SizedBox(height: 8),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: l10n.translate('email'))),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.translate('temporary_password')),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: adminState.submittingUser
                ? null
                : () => ref.read(adminControllerProvider.notifier).createPatient(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
            child: adminState.submittingUser
                ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.translate('save_patient')),
          ),
          if (adminState.userError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(adminState.userError!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 32),
          Text(l10n.translate('admin_existing_patients'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          usersAsync.when(
            data: (users) {
              if (users.isEmpty) return Text(l10n.translate('admin_no_patients'));
              return Column(
                children: users
                    .map(
                      (user) => Card(
                        child: ListTile(
                          title: Text(user.name.isEmpty ? user.email : user.name),
                          subtitle: Text(user.email),
                          trailing: Chip(label: Text(_roleLabel(user.role, l10n))),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ],
      ),
    );
  }

  String _roleLabel(UserRole role, AppLocalizations l10n) {
    switch (role) {
      case UserRole.admin:
        return l10n.translate('role_admin');
      case UserRole.patient:
        return l10n.translate('role_patient');
    }
  }
}
