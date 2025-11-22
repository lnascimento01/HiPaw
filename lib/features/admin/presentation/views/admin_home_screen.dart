import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrador'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text('Gestão do sistema'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Usuários'),
              subtitle: Text('Estrutura inicial para CRUD'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo(a), ${user?.email ?? 'Administrador'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'Utilize o menu lateral para navegar nas funcionalidades de gestão. '
              'Esta tela já está preparada para receber componentes de CRUD de pacientes, '
              'profissionais e agenda.',
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: const Text('Visão geral do sistema'),
                subtitle: const Text('Adicione cards, gráficos ou tabelas com os dados que preferir.'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
