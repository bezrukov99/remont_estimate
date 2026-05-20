import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.state,
    this.onSetBudgetTap,
  });

  final EstimateState state;
  final VoidCallback? onSetBudgetTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialsTotal = state.totalMaterials;
    final purchased = state.totalPurchased;
    final target = state.targetBudget;
    final hasTarget = state.hasTargetBudget;
    final progress = hasTarget
        ? (state.budgetProgress).clamp(0.0, 1.0)
        : 0.0;
    final isOver = state.isOverBudget;

    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
        gradient: palette.budgetGradient,
        boxShadow: [
          BoxShadow(
            color: palette.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.materialsTotal,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (onSetBudgetTap != null)
                  TextButton(
                    onPressed: onSetBudgetTap,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      hasTarget ? l10n.editBudget : l10n.setBudget,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white54,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              CurrencyFormatter.format(materialsTotal, state.currencyCode),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.totalSpent,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(purchased, state.currencyCode),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (hasTarget && target != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.ofTarget(
                  CurrencyFormatter.format(target, state.currencyCode),
                ),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOver ? palette.overBudget : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isOver
                    ? l10n.overBudgetBy(
                        CurrencyFormatter.format(
                          purchased - target,
                          state.currencyCode,
                        ),
                      )
                    : l10n.percentRemaining(
                        ((1 - progress) * 100)
                            .clamp(0, 100)
                            .toStringAsFixed(0),
                      ),
                style: TextStyle(
                  color: isOver ? const Color(0xFFFFEAA7) : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.setBudgetHint,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
