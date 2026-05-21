import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/firebase/firebase_bootstrap.dart';
import 'package:remont_estimate/core/sync/estimate_sync_cubit.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class AccountSheet extends StatefulWidget {
  const AccountSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showRemontSheet<void>(
      context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<AuthCubit>()),
          BlocProvider.value(value: context.read<EstimateSyncCubit>()),
        ],
        child: const AccountSheet(),
      ),
    );
  }

  @override
  State<AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends State<AccountSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthCubit>().state;
    final sync = context.watch<EstimateSyncCubit>().state;
    final firebaseReady = FirebaseBootstrap.isAvailable;

    return AppSheetBody(
      title: l10n.account,
      children: [
        if (!firebaseReady) ...[
          Text(
            l10n.cloudSyncUnavailable,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.palette.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
        ] else if (auth.isSignedIn) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: context.palette.accentMuted,
              child: Icon(Icons.person_outline, color: context.palette.accent),
            ),
            title: Text(auth.displayLabel ?? l10n.signedIn),
            subtitle: Text(
              _syncSubtitle(context, sync.status),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            label: l10n.signOut,
            onPressed: auth.isBusy
                ? null
                : () => context.read<AuthCubit>().signOut(),
          ),
        ] else ...[
          Text(
            l10n.accountHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.palette.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: l10n.signInWithGoogle,
            onPressed: !firebaseReady || auth.isBusy
                ? null
                : () => context.read<AuthCubit>().signInWithGoogle(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _emailController,
            label: l10n.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _passwordController,
            label: l10n.password,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            label: _isRegisterMode ? l10n.createAccount : l10n.signInWithEmail,
            onPressed: !firebaseReady || auth.isBusy ? null : _submitEmail,
          ),
          TextButton(
            onPressed: auth.isBusy
                ? null
                : () => setState(() => _isRegisterMode = !_isRegisterMode),
            child: Text(
              _isRegisterMode ? l10n.haveAccountSignIn : l10n.createAccount,
            ),
          ),
          if (!_isRegisterMode)
            TextButton(
              onPressed: auth.isBusy ? null : _resetPassword,
              child: Text(l10n.forgotPassword),
            ),
        ],
        if (auth.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            auth.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  String _syncSubtitle(BuildContext context, CloudSyncStatus status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      CloudSyncStatus.syncing => l10n.syncInProgress,
      CloudSyncStatus.synced => l10n.syncedToCloud,
      CloudSyncStatus.error => l10n.syncError,
      _ => l10n.syncIdle,
    };
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.length < 6) {
      return;
    }
    final auth = context.read<AuthCubit>();
    if (_isRegisterMode) {
      await auth.registerWithEmail(email: email, password: password);
    } else {
      await auth.signInWithEmail(email: email, password: password);
    }
    if (mounted && context.read<AuthCubit>().state.isSignedIn) {
      Navigator.pop(context);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return;
    }
    await context.read<AuthCubit>().sendPasswordReset(email);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.passwordResetSent),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
