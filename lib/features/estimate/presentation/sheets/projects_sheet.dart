import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/core/utils/project_name_display.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_dialog.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class ProjectsSheet extends StatelessWidget {
  const ProjectsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showRemontSheet<void>(
      context,
      child: BlocProvider.value(
        value: context.read<EstimateCubit>(),
        child: const ProjectsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EstimateCubit, EstimateState>(
      builder: (context, state) {
        final projects = state.projects;

        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

        return SizedBox(
          height: maxHeight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg + bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.myProjects,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.3,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.myProjectsHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: ListView.separated(
                    itemCount: projects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      final isActive = project.id == state.activeProjectId;
                      return _ProjectTile(
                        project: project,
                        isActive: isActive,
                        onTap: () {
                          context
                              .read<EstimateCubit>()
                              .switchProject(project.id);
                          Navigator.pop(context);
                        },
                        onDelete: state.projects.length > 1
                            ? () => _confirmDeleteProject(context, project)
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(
                  label: l10n.newProject,
                  icon: Icons.add,
                  onPressed: () => _showCreateProject(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCreateProject(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => const _NewProjectDialog(),
    );

    if (!context.mounted || name == null) {
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterProjectName)),
      );
      return;
    }

    context.read<EstimateCubit>().createProject(name: name);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDeleteProject(
    BuildContext context,
    ProjectModel project,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showRemontDialog<bool>(
      context,
      title: l10n.deleteProjectTitle(
        displayProjectName(context, project.name),
      ),
      content: Text(l10n.deleteProjectMessage),
      actions: [
        AppDialogAction(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppDialogAction(
          label: l10n.delete,
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<EstimateCubit>();
      for (final material in cubit.materialsInProject(project.id)) {
        await MaterialImageStorage.deleteAllIfOwned(material.photoPaths);
      }
      cubit.deleteProject(project.id);
    }
  }
}

class _NewProjectDialog extends StatefulWidget {
  const _NewProjectDialog();

  @override
  State<_NewProjectDialog> createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<_NewProjectDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppDialog(
      title: l10n.newProject,
      content: AppTextField(
        controller: _controller,
        autofocus: true,
        label: l10n.projectName,
        hint: l10n.newProjectHint,
        textCapitalization: TextCapitalization.words,
        margin: EdgeInsets.zero,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        AppDialogAction(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context),
        ),
        AppDialogAction(
          label: l10n.create,
          isPrimary: true,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.project,
    required this.isActive,
    required this.onTap,
    this.onDelete,
  });

  final ProjectModel project;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = displayProjectName(context, project.name);
    final subtitle = l10n.projectSummary(
      project.rooms.length,
      project.materials.length,
      CurrencyFormatter.compact(project.totalMaterials, project.currencyCode),
    );

    return Material(
      color: isActive ? context.palette.accentMuted : context.palette.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.home_work_outlined,
                color: isActive ? context.palette.accent : context.palette.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isActive ? context.palette.accent : null,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Icon(Icons.check_circle, color: context.palette.accent, size: 22)
              else
                Icon(Icons.chevron_right, color: context.palette.textTertiary),
              if (onDelete != null) ...[
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.redAccent,
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
