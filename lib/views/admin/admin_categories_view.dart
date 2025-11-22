import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/admin_data_providers.dart';
import '../../core/extensions/category_type_extension.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category.dart';

class AdminCategoriesView extends ConsumerStatefulWidget {
  const AdminCategoriesView({super.key});

  @override
  ConsumerState<AdminCategoriesView> createState() => _AdminCategoriesViewState();
}

class _AdminCategoriesViewState extends ConsumerState<AdminCategoriesView> {
  final _nameController = TextEditingController();
  CategoryType _selectedType = CategoryType.motor;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final adminState = ref.watch(adminControllerProvider);
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('admin_categories'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.translate('create_category'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('category_name'))),
          const SizedBox(height: 8),
          DropdownButtonFormField<CategoryType>(
            value: _selectedType,
            decoration: InputDecoration(labelText: l10n.translate('category_type')),
            items: CategoryType.values
                .map((type) => DropdownMenuItem(value: type, child: Text(type.localizedLabel(l10n))))
                .toList(),
            onChanged: (value) => setState(() => _selectedType = value ?? CategoryType.motor),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: adminState.submittingCategory
                ? null
                : () => ref
                    .read(adminControllerProvider.notifier)
                    .createCategory(name: _nameController.text.trim(), type: _selectedType),
            child: adminState.submittingCategory
                ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.translate('save_category')),
          ),
          if (adminState.categoryError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(adminState.categoryError!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 32),
          Text(l10n.translate('categories'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          categoriesAsync.when(
            data: (items) {
              if (items.isEmpty) return Text(l10n.translate('categories_empty'));
              return Column(
                children: items
                    .map(
                      (category) => Card(
                        child: ListTile(
                          title: Text(category.name),
                          subtitle: Text(
                            '${category.type.localizedLabel(l10n)} · ${DateFormat.yMMMd(l10n.locale.toLanguageTag()).format(category.createdAt)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: l10n.translate('category_delete'),
                            onPressed: () => ref.read(adminControllerProvider.notifier).deleteCategory(category.id),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}
