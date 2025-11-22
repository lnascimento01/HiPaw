import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Paciente'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user?.email ?? 'paciente'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'Aqui você encontra seus próximos atendimentos, prescrições e conteúdos exclusivos.',
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Próximo atendimento'),
                subtitle: const Text('Nenhum compromisso agendado. Toque para marcar.'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text('Conteúdos personalizados'),
                subtitle:
                    const Text('Adicione vídeos, artigos ou mensagens para orientar o paciente.'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
