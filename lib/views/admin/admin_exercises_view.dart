import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/admin_data_providers.dart';
import '../../core/extensions/pillar_localization_extension.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../models/docx_blueprint.dart';
import '../../models/exercise.dart';
import '../../widgets/info_helper_button.dart';

class AdminExercisesView extends ConsumerStatefulWidget {
  const AdminExercisesView({super.key});

  @override
  ConsumerState<AdminExercisesView> createState() => _AdminExercisesViewState();
}

class _AdminExercisesViewState extends ConsumerState<AdminExercisesView> {
  final _exerciseTitle = TextEditingController();
  final _exerciseSubtitle = TextEditingController();
  final _descriptionInitial = TextEditingController();
  final _descriptionIntermediate = TextEditingController();
  final _descriptionAdvanced = TextEditingController();
  final _materialsInitial = TextEditingController();
  final _materialsIntermediate = TextEditingController();
  final _materialsAdvanced = TextEditingController();
  final _stepsInitial = TextEditingController();
  final _stepsIntermediate = TextEditingController();
  final _stepsAdvanced = TextEditingController();
  final _notesInitial = TextEditingController();
  final _notesIntermediate = TextEditingController();
  final _notesAdvanced = TextEditingController();
  final _videoUrl = TextEditingController();

  Set<PsychomotorPillar> _selectedPillars = {PsychomotorPillar.motora};
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String _selectedDifficulty = 'initial';

  @override
  void dispose() {
    _exerciseTitle.dispose();
    _exerciseSubtitle.dispose();
    _descriptionInitial.dispose();
    _descriptionIntermediate.dispose();
    _descriptionAdvanced.dispose();
    _materialsInitial.dispose();
    _materialsIntermediate.dispose();
    _materialsAdvanced.dispose();
    _stepsInitial.dispose();
    _stepsIntermediate.dispose();
    _stepsAdvanced.dispose();
    _notesInitial.dispose();
    _notesIntermediate.dispose();
    _notesAdvanced.dispose();
    _videoUrl.dispose();
    super.dispose();
  }

  List<String> _splitLines(String text) => text
      .split(RegExp(r'[\n,]+'))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList();

  void _applyBlueprint(DocxExerciseBlueprint blueprint) {
    setState(() {
      _exerciseTitle.text = blueprint.title;
      _exerciseSubtitle.text = blueprint.subtitle;
      _descriptionInitial.text = blueprint.initial.description;
      _descriptionIntermediate.text = blueprint.intermediate.description;
      _descriptionAdvanced.text = blueprint.advanced.description;
      _materialsInitial.text = blueprint.initial.materials.join('\n');
      _materialsIntermediate.text = blueprint.intermediate.materials.join('\n');
      _materialsAdvanced.text = blueprint.advanced.materials.join('\n');
      _stepsInitial.text = blueprint.initial.steps.join('\n');
      _stepsIntermediate.text = blueprint.intermediate.steps.join('\n');
      _stepsAdvanced.text = blueprint.advanced.steps.join('\n');
      _notesInitial.text = blueprint.initial.notes;
      _notesIntermediate.text = blueprint.intermediate.notes;
      _notesAdvanced.text = blueprint.advanced.notes;
      _videoUrl.text = blueprint.videoUrl;
      _selectedPillars = blueprint.pillars.toSet();
    });
  }

  void _syncCategoryDefaults(List<Category> categories) {
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedCategoryId = categories.first.id;
          _selectedCategoryName = categories.first.name;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final adminState = ref.watch(adminControllerProvider);
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    final exercisesAsync = ref.watch(adminExercisesProvider);
    categoriesAsync.whenData(_syncCategoryDefaults);
    final categories = categoriesAsync.asData?.value ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('create_exercise'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _exerciseTitle, decoration: InputDecoration(labelText: l10n.translate('title'))),
            const SizedBox(height: 12),
            TextField(controller: _exerciseSubtitle, decoration: InputDecoration(labelText: l10n.translate('subtitle'))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: InputDecoration(labelText: l10n.translate('category'), helperText: l10n.translate('select_category')),
              items: categories
                  .map((category) => DropdownMenuItem(value: category.id, child: Text(category.name)))
                  .toList(),
              onChanged: categories.isEmpty
                  ? null
                  : (value) {
                      final selected = categories.firstWhere((element) => element.id == value);
                      setState(() {
                        _selectedCategoryId = selected.id;
                        _selectedCategoryName = selected.name;
                      });
                    },
            ),
            if (categories.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l10n.translate('categories_empty'), style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: InputDecoration(labelText: l10n.translate('difficulty'), helperText: l10n.translate('difficulty_hint')),
              items: [
                DropdownMenuItem(value: 'initial', child: Text(l10n.translate('difficulty_beginner'))),
                DropdownMenuItem(value: 'intermediate', child: Text(l10n.translate('difficulty_intermediate'))),
                DropdownMenuItem(value: 'advanced', child: Text(l10n.translate('difficulty_advanced'))),
              ],
              onChanged: (value) => setState(() => _selectedDifficulty = value ?? 'initial'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: PsychomotorPillar.values
                  .map(
                    (pillar) => FilterChip(
                      label: Text(pillar.localizedLabel(l10n)),
                      selected: _selectedPillars.contains(pillar),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPillars = {..._selectedPillars, pillar};
                          } else {
                            final next = {..._selectedPillars}..remove(pillar);
                            _selectedPillars = next.isEmpty ? {PsychomotorPillar.motora} : next;
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _SectionForm(
              title: '${l10n.translate('level_initial')} - ${l10n.translate('objective')}',
              controller: _descriptionInitial,
              helper: l10n.translate('helper_objective'),
            ),
            _SectionForm(
              title: '${l10n.translate('level_initial')} - ${l10n.translate('materials')}',
              controller: _materialsInitial,
              helper: l10n.translate('helper_materials'),
            ),
            _SectionForm(
              title: '${l10n.translate('level_initial')} - ${l10n.translate('steps')}',
              controller: _stepsInitial,
              helper: l10n.translate('helper_steps'),
            ),
            _SectionForm(
              title: '${l10n.translate('level_initial')} - ${l10n.translate('observations')}',
              controller: _notesInitial,
              helper: l10n.translate('helper_notes'),
            ),
            const Divider(height: 32),
            _SectionForm(
              title: '${l10n.translate('level_intermediate')} - ${l10n.translate('objective')}',
              controller: _descriptionIntermediate,
            ),
            _SectionForm(
              title: '${l10n.translate('level_intermediate')} - ${l10n.translate('materials')}',
              controller: _materialsIntermediate,
            ),
            _SectionForm(
              title: '${l10n.translate('level_intermediate')} - ${l10n.translate('steps')}',
              controller: _stepsIntermediate,
            ),
            _SectionForm(
              title: '${l10n.translate('level_intermediate')} - ${l10n.translate('observations')}',
              controller: _notesIntermediate,
            ),
            const Divider(height: 32),
            _SectionForm(
              title: '${l10n.translate('level_advanced')} - ${l10n.translate('objective')}',
              controller: _descriptionAdvanced,
            ),
            _SectionForm(
              title: '${l10n.translate('level_advanced')} - ${l10n.translate('materials')}',
              controller: _materialsAdvanced,
            ),
            _SectionForm(
              title: '${l10n.translate('level_advanced')} - ${l10n.translate('steps')}',
              controller: _stepsAdvanced,
            ),
            _SectionForm(
              title: '${l10n.translate('level_advanced')} - ${l10n.translate('observations')}',
              controller: _notesAdvanced,
            ),
            const SizedBox(height: 16),
            TextField(controller: _videoUrl, decoration: InputDecoration(labelText: l10n.translate('video_url'))),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: adminState.submittingExercise || _selectedCategoryId == null
                  ? null
                  : () => ref.read(adminControllerProvider.notifier).createExercise(
                        title: _exerciseTitle.text.trim(),
                        subtitle: _exerciseSubtitle.text.trim(),
                        pillars: _selectedPillars,
                        descriptionInitial: _descriptionInitial.text.trim(),
                        descriptionIntermediate: _descriptionIntermediate.text.trim(),
                        descriptionAdvanced: _descriptionAdvanced.text.trim(),
                        materialsInitial: _splitLines(_materialsInitial.text),
                        materialsIntermediate: _splitLines(_materialsIntermediate.text),
                        materialsAdvanced: _splitLines(_materialsAdvanced.text),
                        stepsInitial: _splitLines(_stepsInitial.text),
                        stepsIntermediate: _splitLines(_stepsIntermediate.text),
                        stepsAdvanced: _splitLines(_stepsAdvanced.text),
                        categoryId: _selectedCategoryId!,
                        categoryName: _selectedCategoryName ?? '',
                        difficulty: _selectedDifficulty,
                        notesInitial: _notesInitial.text.trim(),
                        notesIntermediate: _notesIntermediate.text.trim(),
                        notesAdvanced: _notesAdvanced.text.trim(),
                        videoUrl: _videoUrl.text.trim(),
                      ),
              child: adminState.submittingExercise
                  ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.translate('save_exercise')),
            ),
            if (adminState.exerciseError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(adminState.exerciseError!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            ExpansionTile(
              title: Text(l10n.translate('docx_models_title')),
              children: docxExerciseBlueprints
                  .map(
                    (blueprint) => ListTile(
                      title: Text(blueprint.title),
                      subtitle: Text(blueprint.subtitle),
                      trailing: TextButton.icon(
                        onPressed: () => _applyBlueprint(blueprint),
                        icon: const Icon(Icons.file_download),
                        label: Text(l10n.translate('use_template')),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text(l10n.translate('admin_existing_exercises'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            exercisesAsync.when(
              data: (items) {
                if (items.isEmpty) return Text(l10n.translate('admin_no_exercises'));
                return Column(
                  children: items
                      .map(
                        (exercise) => Card(
                          child: ListTile(
                            title: Text(exercise.title),
                            subtitle: Text('${exercise.categoryName} · ${exercise.difficulty}'),
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
      ),
    );
  }
}

class _SectionForm extends StatelessWidget {
  const _SectionForm({
    required this.title,
    required this.controller,
    this.helper,
  });

  final String title;
  final TextEditingController controller;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              if (helper != null)
                InfoHelperButton(
                  title: title,
                  child: Text(helper!),
                ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
