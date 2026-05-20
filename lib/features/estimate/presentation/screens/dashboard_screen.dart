import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/project_name_display.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/features/estimate/presentation/screens/room_detail_screen.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/add_room_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/export_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/material_form_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/projects_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/project_settings_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/quick_action_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/set_budget_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/budget_summary_card.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/empty_rooms_state.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/room_card.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EstimateCubit, EstimateState>(
      builder: (context, state) {
        final rooms = state.sortedRooms;
        final palette = context.palette;

        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () => ProjectsSheet.show(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            displayProjectName(context, state.projectName),
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.unfold_more,
                          size: 20,
                          color: palette.textTertiary,
                        ),
                      ],
                    ),
                    if (state.projects.length > 1) ...[
                      Text(
                        l10n.projectsCount(state.projects.length),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: palette.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share_outlined),
                tooltip: l10n.export,
                onPressed: () => ExportSheet.show(context),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => ProjectSettingsSheet.show(context),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: BudgetSummaryCard(
                      state: state,
                      onSetBudgetTap: () => SetBudgetSheet.show(context),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          l10n.rooms,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        if (rooms.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => AddRoomSheet.show(context),
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(l10n.add),
                          ),
                      ],
                    ),
                  ),
                ),
                if (rooms.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyRoomsState(
                      onAddRoom: () => AddRoomSheet.show(context),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      100,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.sm,
                            crossAxisSpacing: AppSpacing.sm,
                            childAspectRatio: 1.35,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final room = rooms[index];
                        return RoomCard(
                          room: room,
                          itemCount: state.itemCountForRoom(room.id),
                          subtotal: state.subtotalForRoom(room.id),
                          currencyCode: state.currencyCode,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    RoomDetailScreen(roomId: room.id),
                              ),
                            );
                          },
                        );
                      }, childCount: rooms.length),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: _DashboardFab(
            hasRooms: rooms.isNotEmpty,
            onQuickAdd: () => _openQuickActions(context, rooms.isNotEmpty),
          ),
        );
      },
    );
  }

  void _openQuickActions(BuildContext context, bool hasRooms) {
    final l10n = AppLocalizations.of(context)!;

    QuickActionSheet.show(
      context,
      onAddMaterial: () {
        if (!hasRooms) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.addRoomFirstSnack),
              behavior: SnackBarBehavior.floating,
            ),
          );
          AddRoomSheet.show(context);
          return;
        }

        final rooms = context.read<EstimateCubit>().state.sortedRooms;
        MaterialFormSheet.show(
          context,
          roomId: rooms.length == 1 ? rooms.first.id : null,
        );
      },
    );
  }
}

class _DashboardFab extends StatelessWidget {
  const _DashboardFab({required this.hasRooms, required this.onQuickAdd});

  final bool hasRooms;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.fabSize,
      height: AppSpacing.fabSize,
      child: FloatingActionButton(
        onPressed: onQuickAdd,
        elevation: 6,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
