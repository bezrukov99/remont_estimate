/// Hydrated storage identifiers and persistence metadata.
abstract final class StorageKeys {
  static const String estimateCubit = 'estimate_cubit';
  static const String appSettingsCubit = 'app_settings_cubit';

  /// Bump when [EstimateState] JSON shape changes (migration hook).
  static const int estimateStateSchemaVersion = 2;
}
