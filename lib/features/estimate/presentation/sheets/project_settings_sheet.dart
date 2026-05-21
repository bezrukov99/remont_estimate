import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/cubit/app_settings_cubit.dart';
import 'package:remont_estimate/core/firebase/firebase_bootstrap.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_dialog.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/export_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/set_budget_sheet.dart';
import 'package:remont_estimate/core/sync/estimate_sync_cubit.dart';
import 'package:remont_estimate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:remont_estimate/features/auth/presentation/sheets/account_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/settings_pickers.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class ProjectSettingsSheet extends StatefulWidget {
  const ProjectSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showRemontSheet<void>(
      context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<EstimateCubit>()),
          BlocProvider.value(value: context.read<AppSettingsCubit>()),
          if (FirebaseBootstrap.isInitialized) ...[
            BlocProvider.value(value: context.read<AuthCubit>()),
            BlocProvider.value(value: context.read<EstimateSyncCubit>()),
          ],
        ],
        child: const ProjectSettingsSheet(),
      ),
    );
  }

  @override
  State<ProjectSettingsSheet> createState() => _ProjectSettingsSheetState();
}

class _ProjectSettingsSheetState extends State<ProjectSettingsSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: context.read<EstimateCubit>().state.projectName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<AppSettingsCubit>().state;
    final currencyCode = context.watch<EstimateCubit>().state.currencyCode;

    return AppSheetBody(
      title: l10n.projectSettings,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPrimaryButton(
            label: l10n.save,
            onPressed: () {
              context.read<EstimateCubit>().setProjectName(_nameController.text);
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () => _confirmReset(context),
            child: Text(
              l10n.resetAllData,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
      children: [
        AppTextField(
          controller: _nameController,
          label: l10n.projectName,
          textCapitalization: TextCapitalization.words,
        ),
        if (FirebaseBootstrap.isInitialized)
          AppSheetListTile(
            icon: Icons.account_circle_outlined,
            title: l10n.account,
            subtitle: l10n.accountSubtitle,
            onTap: () => AccountSheet.show(context),
          ),
        AppSheetListTile(
          icon: Icons.language_outlined,
          title: l10n.language,
          subtitle: languageSubtitle(context, settings),
          onTap: () => showLanguagePicker(context),
        ),
        AppSheetListTile(
          icon: Icons.dark_mode_outlined,
          title: l10n.theme,
          subtitle: themeSubtitle(context, settings),
          onTap: () => showThemePicker(context),
        ),
        AppSheetListTile(
          icon: Icons.payments_outlined,
          title: l10n.currency,
          subtitle: currencySubtitle(currencyCode),
          onTap: () => showCurrencyPicker(context),
        ),
        AppSheetListTile(
          icon: Icons.account_balance_wallet_outlined,
          title: l10n.targetBudget,
          onTap: () {
            Navigator.pop(context);
            SetBudgetSheet.show(context);
          },
        ),
        AppSheetListTile(
          icon: Icons.ios_share_outlined,
          title: l10n.exportPdfExcel,
          onTap: () {
            Navigator.pop(context);
            ExportSheet.show(context);
          },
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showRemontDialog<bool>(
      context,
      title: l10n.resetProjectTitle,
      content: Text(l10n.resetProjectMessage),
      actions: [
        AppDialogAction(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppDialogAction(
          label: l10n.reset,
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<EstimateCubit>();
      for (final material in cubit.state.materials) {
        await MaterialImageStorage.deleteAllIfOwned(material.photoPaths);
      }
      cubit.resetProject();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
