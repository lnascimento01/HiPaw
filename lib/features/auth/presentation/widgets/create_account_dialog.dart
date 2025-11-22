import 'package:flutter/material.dart';

import '../../domain/entities/app_user.dart';

class CreateAccountResult {
  const CreateAccountResult({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;
}

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _role = UserRole.patient;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Criar conta'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Senha mínima de 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<UserRole>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Tipo de usuário'),
              items: UserRole.values
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role == UserRole.admin ? 'Administrador' : 'Paciente'),
                    ),
                  )
                  .toList(),
              onChanged: (role) {
                if (role == null) return;
                setState(() => _role = role);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              CreateAccountResult(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                role: _role,
              ),
            );
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
