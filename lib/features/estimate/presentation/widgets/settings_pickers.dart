import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/constants/app_currencies.dart';
import 'package:remont_estimate/core/cubit/app_settings_cubit.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

Future<void> showLanguagePicker(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final settings = context.read<AppSettingsCubit>();

  return showRemontSheet<void>(
    context,
    child: AppSheetBody(
      title: l10n.language,
      children: [
        _PickerOption(
          title: l10n.languageSystem,
          selected: settings.state.languageCode == null,
          onTap: () {
            settings.setLanguageCode(null);
            Navigator.pop(context);
          },
        ),
        _PickerOption(
          title: l10n.languageEnglish,
          selected: settings.state.languageCode == 'en',
          onTap: () {
            settings.setLanguageCode('en');
            Navigator.pop(context);
          },
        ),
        _PickerOption(
          title: l10n.languageRussian,
          selected: settings.state.languageCode == 'ru',
          onTap: () {
            settings.setLanguageCode('ru');
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<void> showThemePicker(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final settings = context.read<AppSettingsCubit>();

  return showRemontSheet<void>(
    context,
    child: AppSheetBody(
      title: l10n.theme,
      children: [
        _PickerOption(
          title: l10n.themeSystem,
          selected: settings.state.themeMode == null,
          onTap: () {
            settings.setThemeMode(null);
            Navigator.pop(context);
          },
        ),
        _PickerOption(
          title: l10n.themeLight,
          selected: settings.state.themeMode == 'light',
          onTap: () {
            settings.setThemeMode('light');
            Navigator.pop(context);
          },
        ),
        _PickerOption(
          title: l10n.themeDark,
          selected: settings.state.themeMode == 'dark',
          onTap: () {
            settings.setThemeMode('dark');
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<void> showCurrencyPicker(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final cubit = context.read<EstimateCubit>();
  final selectedCode = cubit.state.currencyCode;
  final maxHeight = MediaQuery.sizeOf(context).height * 0.55;

  final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

  return showRemontSheet<void>(
    context,
    child: SizedBox(
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
              l10n.currency,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 22,
                    letterSpacing: -0.3,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView.builder(
                itemCount: AppCurrencies.all.length,
                itemBuilder: (context, index) {
                final currency = AppCurrencies.all[index];
                final selected = currency.code == selectedCode;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Material(
                    color: selected
                        ? context.palette.accentMuted
                        : context.palette.surfaceMuted,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                    child: InkWell(
                      onTap: () {
                        cubit.setCurrencyCode(currency.code);
                        Navigator.pop(context);
                      },
                      borderRadius:
                          BorderRadius.circular(AppSpacing.buttonRadius),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: context.palette.surface,
                              child: Text(
                                currency.symbol,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? context.palette.accent
                                      : context.palette.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              currency.code,
                              style:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            if (selected)
                              Icon(
                                Icons.check_circle,
                                color: context.palette.accent,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    ),
  );
}

class _PickerOption extends StatelessWidget {
  const _PickerOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: selected ? palette.accentMuted : palette.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          color: selected ? palette.accent : null,
                        ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, color: palette.accent, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String languageSubtitle(BuildContext context, AppSettingsState settings) {
  final l10n = AppLocalizations.of(context)!;
  return switch (settings.languageCode) {
    'en' => l10n.languageEnglish,
    'ru' => l10n.languageRussian,
    _ => l10n.languageSystem,
  };
}

String themeSubtitle(BuildContext context, AppSettingsState settings) {
  final l10n = AppLocalizations.of(context)!;
  return switch (settings.themeMode) {
    'light' => l10n.themeLight,
    'dark' => l10n.themeDark,
    _ => l10n.themeSystem,
  };
}

String currencySubtitle(String currencyCode) {
  final currency = AppCurrencies.findByCode(currencyCode);
  return currency?.displayLabel ?? currencyCode;
}
