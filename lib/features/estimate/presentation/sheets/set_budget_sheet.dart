import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/constants/app_currencies.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class SetBudgetSheet extends StatefulWidget {
  const SetBudgetSheet({super.key, required this.initialState});

  final EstimateState initialState;

  static Future<void> show(BuildContext context) {
    final state = context.read<EstimateCubit>().state;
    return showRemontSheet<void>(
      context,
      child: BlocProvider.value(
        value: context.read<EstimateCubit>(),
        child: SetBudgetSheet(initialState: state),
      ),
    );
  }

  @override
  State<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<SetBudgetSheet> {
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    final target = widget.initialState.targetBudget;
    _budgetController = TextEditingController(
      text: target != null && target > 0 ? target.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<EstimateCubit>();
    final budgetText = _budgetController.text.trim().replaceAll(',', '.');

    if (budgetText.isEmpty) {
      cubit.clearTargetBudget();
    } else {
      final budget = double.tryParse(budgetText);
      if (budget == null || budget <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enterValidBudget)),
        );
        return;
      }
      cubit.setTargetBudget(budget);
    }

    Navigator.of(context).pop();
  }

  void _clearBudget() {
    context.read<EstimateCubit>().clearTargetBudget();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasBudget = widget.initialState.hasTargetBudget;
    final currencySymbol =
        AppCurrencies.symbolFor(widget.initialState.currencyCode);

    return AppSheetBody(
      title: l10n.targetBudgetTitle,
      footer: AppPrimaryButton(
        label: l10n.saveBudget,
        icon: Icons.check_rounded,
        onPressed: _save,
      ),
      children: [
        AppTextField(
          controller: _budgetController,
          autofocus: true,
          label: l10n.budgetAmount,
          hint: l10n.budgetAmountHint,
          prefixIcon: Icons.account_balance_wallet_outlined,
          prefixText: '$currencySymbol ',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
        ),
        if (hasBudget) ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: _clearBudget,
              child: Text(l10n.removeBudgetLimit),
            ),
          ),
        ],
      ],
    );
  }
}
