import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_dialog.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/edit_room_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/material_form_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/material_list_tile.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final Set<String> _selectedIds = {};
  bool _selectionMode = false;

  void _openAddMaterial() {
    MaterialFormSheet.show(context, roomId: widget.roomId);
  }

  void _openEditMaterial(String materialId) {
    MaterialFormSheet.show(
      context,
      roomId: widget.roomId,
      materialId: materialId,
    );
  }

  void _enterSelection(String materialId) {
    setState(() {
      _selectionMode = true;
      _selectedIds.add(materialId);
    });
  }

  void _toggleSelection(String materialId) {
    setState(() {
      if (_selectedIds.contains(materialId)) {
        _selectedIds.remove(materialId);
        if (_selectedIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedIds.add(materialId);
      }
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  Future<void> _confirmDeleteSelected(
    BuildContext context,
    List<MaterialItemModel> materials,
  ) async {
    if (_selectedIds.isEmpty) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final count = _selectedIds.length;
    final confirmed = await showRemontDialog<bool>(
      context,
      title: l10n.deleteMaterialsTitle(count),
      content: Text(l10n.deleteMaterialsMessage),
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

    if (confirmed != true || !context.mounted) {
      return;
    }

    final cubit = context.read<EstimateCubit>();
    final toDelete = materials.where((m) => _selectedIds.contains(m.id));
    for (final material in toDelete) {
      await MaterialImageStorage.deleteAllIfOwned(material.photoPaths);
    }
    cubit.deleteMaterials(_selectedIds);
    _exitSelection();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EstimateCubit, EstimateState>(
      builder: (context, state) {
        final room = state.roomById(widget.roomId);
        if (room == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.roomNotFound)),
          );
        }

        final materials = state.materialsForRoom(widget.roomId);
        final subtotal = state.subtotalForRoom(widget.roomId);
        final purchasedSubtotal =
            state.purchasedSubtotalForRoom(widget.roomId);
        final selectedCount = _selectedIds.length;

        return Scaffold(
          appBar: _selectionMode
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _exitSelection,
                  ),
                  title: Text(l10n.selectedMaterialsCount(selectedCount)),
                  actions: [
                    if (selectedCount > 0)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.redAccent,
                        onPressed: () =>
                            _confirmDeleteSelected(context, materials),
                      ),
                  ],
                )
              : AppBar(
                  title: Text(room.name),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l10n.editRoom,
                      onPressed: () => EditRoomSheet.show(
                        context,
                        roomId: widget.roomId,
                        initialName: room.name,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDeleteRoom(context, room),
                    ),
                  ],
                ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _RoomSubtotalHeader(
                subtotal: subtotal,
                purchasedSubtotal: purchasedSubtotal,
                itemCount: materials.length,
                currencyCode: state.currencyCode,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    l10n.materials,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    l10n.itemsCount(materials.length),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (materials.isEmpty)
                _EmptyMaterials(onAdd: _openAddMaterial)
              else
                ...materials.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: MaterialListTile(
                      material: m,
                      currencyCode: state.currencyCode,
                      isSelectionMode: _selectionMode,
                      isSelected: _selectedIds.contains(m.id),
                      onPurchasedChanged: _selectionMode
                          ? null
                          : (purchased) => context
                              .read<EstimateCubit>()
                              .setMaterialPurchased(m.id, purchased),
                      onLongPress: _selectionMode
                          ? null
                          : () => _enterSelection(m.id),
                      onTap: _selectionMode
                          ? () => _toggleSelection(m.id)
                          : () => _openEditMaterial(m.id),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: _selectionMode
              ? null
              : FloatingActionButton.extended(
                  onPressed: _openAddMaterial,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addMaterialFab),
                ),
        );
      },
    );
  }

  Future<void> _confirmDeleteRoom(BuildContext context, RoomModel room) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showRemontDialog<bool>(
      context,
      title: l10n.deleteRoomTitle(room.name),
      content: Text(l10n.deleteRoomMessage),
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
      final materials = cubit.state.materialsForRoom(room.id);
      for (final material in materials) {
        await MaterialImageStorage.deleteAllIfOwned(material.photoPaths);
      }
      cubit.deleteRoom(room.id);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _RoomSubtotalHeader extends StatelessWidget {
  const _RoomSubtotalHeader({
    required this.subtotal,
    required this.purchasedSubtotal,
    required this.itemCount,
    required this.currencyCode,
  });

  final double subtotal;
  final double purchasedSubtotal;
  final int itemCount;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.palette.accentMuted,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.roomSubtotal,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(subtotal, currencyCode),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.roomPurchasedSubtotal,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: context.palette.textSecondary,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            CurrencyFormatter.format(purchasedSubtotal, currencyCode),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.palette.accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.materialsCount(itemCount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMaterials extends StatelessWidget {
  const _EmptyMaterials({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: context.palette.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.noMaterialsInRoom,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.noMaterialsInRoomHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onAdd, child: Text(l10n.addMaterialFab)),
        ],
      ),
    );
  }
}
