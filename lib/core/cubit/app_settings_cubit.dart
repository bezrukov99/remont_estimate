import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:remont_estimate/core/constants/storage_keys.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.languageCode,
    this.themeMode,
  });

  /// `en`, `ru`, or null for system default.
  final String? languageCode;

  /// `light`, `dark`, or null for system default.
  final String? themeMode;

  Locale? get locale {
    if (languageCode == null) {
      return null;
    }
    return Locale(languageCode!);
  }

  ThemeMode get materialThemeMode => switch (themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  AppSettingsState copyWith({
    String? languageCode,
    String? themeMode,
    bool clearLanguage = false,
    bool clearThemeMode = false,
  }) {
    return AppSettingsState(
      languageCode:
          clearLanguage ? null : (languageCode ?? this.languageCode),
      themeMode: clearThemeMode ? null : (themeMode ?? this.themeMode),
    );
  }

  static const AppSettingsState initial = AppSettingsState();

  @override
  List<Object?> get props => [languageCode, themeMode];

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'themeMode': themeMode,
      };

  factory AppSettingsState.fromJson(Map<String, dynamic> json) {
    return AppSettingsState(
      languageCode: json['languageCode'] as String?,
      themeMode: json['themeMode'] as String?,
    );
  }
}

class AppSettingsCubit extends HydratedCubit<AppSettingsState> {
  AppSettingsCubit() : super(AppSettingsState.initial);

  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  void setLanguageCode(String? code) {
    if (code == state.languageCode) {
      return;
    }
    if (code == null) {
      emit(state.copyWith(clearLanguage: true));
      return;
    }
    emit(state.copyWith(languageCode: code));
  }

  void setThemeMode(String? mode) {
    if (mode == state.themeMode) {
      return;
    }
    if (mode == null) {
      emit(state.copyWith(clearThemeMode: true));
      return;
    }
    emit(state.copyWith(themeMode: mode));
  }

  @override
  String get storagePrefix => StorageKeys.appSettingsCubit;

  @override
  AppSettingsState? fromJson(Map<String, dynamic> json) {
    return AppSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppSettingsState state) {
    return state.toJson();
  }
}
