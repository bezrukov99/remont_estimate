import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:remont_estimate/core/cubit/app_settings_cubit.dart';
import 'package:remont_estimate/core/theme/app_theme.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/screens/dashboard_screen.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class RemontEstimateApp extends StatelessWidget {
  const RemontEstimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppSettingsCubit()),
        BlocProvider(create: (_) => EstimateCubit()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.materialThemeMode,
            locale: settings.locale,
            supportedLocales: AppSettingsCubit.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
