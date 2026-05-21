import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remont_estimate/core/constants/app_currencies.dart';
import 'package:remont_estimate/core/constants/material_photo_limits.dart';
import 'package:remont_estimate/core/l10n/material_unit_l10n.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_dialog.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/material_photo_picker.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/quantity_stepper.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/unit_selector_chips.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

/// In-store friendly add/edit material form.
class MaterialFormSheet extends StatefulWidget {
  const MaterialFormSheet({
    super.key,
    this.initialRoomId,
    this.materialId,
  });

  final String? initialRoomId;
  final String? materialId;

  static Future<void> show(
    BuildContext context, {
    String? roomId,
    String? materialId,
  }) {
    return showRemontSheet<void>(
      context,
      child: BlocProvider.value(
        value: context.read<EstimateCubit>(),
        child: MaterialFormSheet(
          initialRoomId: roomId,
          materialId: materialId,
        ),
      ),
    );
  }

  @override
  State<MaterialFormSheet> createState() => _MaterialFormSheetState();
}

class _MaterialFormSheetState extends State<MaterialFormSheet> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _articleController = TextEditingController();
  final _storeController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _priceController = TextEditingController();

  late String? _selectedRoomId;
  final List<String> _photoPaths = [];
  final Set<String> _originalPhotoPaths = {};
  double _quantity = 1;
  MaterialUnit _unit = MaterialUnit.pieces;
  bool _isSaving = false;
  bool _nameHasError = false;
  bool _priceHasError = false;
  /// After successful save, photos are owned by the material — do not delete on dispose.
  bool _photosSavedWithMaterial = false;

  bool get _isEditing => widget.materialId != null;

  @override
  void initState() {
    super.initState();
    _hydrateFromState();
  }

  void _hydrateFromState() {
    final state = context.read<EstimateCubit>().state;

    if (_isEditing) {
      final material = state.materialById(widget.materialId!);
      if (material == null) {
        return;
      }
      _selectedRoomId = material.roomId;
      _nameController.text = material.name;
      _brandController.text = material.brand ?? '';
      _articleController.text = material.article ?? '';
      _storeController.text = material.store ?? '';
      _dimensionsController.text = material.dimensions ?? '';
      _priceController.text = material.pricePerUnit.toStringAsFixed(2);
      _photoPaths
        ..clear()
        ..addAll(material.photoPaths);
      _originalPhotoPaths
        ..clear()
        ..addAll(material.photoPaths);
      _quantity = material.quantity;
      _unit = material.unit;
      return;
    }

    _selectedRoomId = widget.initialRoomId ??
        (state.rooms.length == 1 ? state.rooms.first.id : null);
    _priceController.text = '';
  }

  @override
  void dispose() {
    if (!_photosSavedWithMaterial) {
      for (final path in _photoPaths) {
        if (!_originalPhotoPaths.contains(path)) {
          MaterialImageStorage.deleteIfOwned(path);
        }
      }
    }
    _nameController.dispose();
    _brandController.dispose();
    _articleController.dispose();
    _storeController.dispose();
    _dimensionsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  int get _photosRemaining =>
      MaterialPhotoLimits.maxPerMaterial - _photoPaths.length;

  double get _totalPrice {
    final price = double.tryParse(
          _priceController.text.trim().replaceAll(',', '.'),
        ) ??
        0;
    return _quantity * price;
  }

  Future<void> _pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    if (_photosRemaining <= 0) {
      _showError(l10n.maxPhotosReached(MaterialPhotoLimits.maxPerMaterial));
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final files = await _picker.pickMultiImage(
          maxWidth: 1920,
          imageQuality: 85,
          limit: _photosRemaining,
        );
        if (files.isEmpty || !mounted) {
          return;
        }
        final added = <String>[];
        for (final file in files) {
          if (_photoPaths.length + added.length >=
              MaterialPhotoLimits.maxPerMaterial) {
            break;
          }
          added.add(await MaterialImageStorage.persistFromPicker(file));
        }
        setState(() => _photoPaths.addAll(added));
        return;
      }

      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (file == null || !mounted) {
        return;
      }

      final savedPath = await MaterialImageStorage.persistFromPicker(file);
      setState(() => _photoPaths.add(savedPath));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotLoadImage(e.toString()))),
      );
    }
  }

  Future<void> _removePhoto(String path) async {
    if (!_originalPhotoPaths.contains(path)) {
      await MaterialImageStorage.deleteIfOwned(path);
    }
    setState(() => _photoPaths.remove(path));
  }

  Future<void> _cleanupRemovedOriginalPhotos(
    Iterable<String> previousPaths,
  ) async {
    for (final path in previousPaths) {
      if (!_photoPaths.contains(path)) {
        await MaterialImageStorage.deleteIfOwned(path);
      }
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<EstimateCubit>();
    final state = cubit.state;
    final name = _nameController.text.trim();
    var roomId = _selectedRoomId;
    final price = double.tryParse(
      _priceController.text.trim().replaceAll(',', '.'),
    );

    final rooms = state.sortedRooms;
    if (roomId == null && rooms.isNotEmpty) {
      roomId = rooms.first.id;
    }
    if (roomId == null) {
      _showError(l10n.addRoomBeforeMaterials);
      return;
    }

    final priceText = _priceController.text.trim();
    final nameInvalid = name.isEmpty;
    final priceInvalid = priceText.isEmpty || price == null || price < 0;

    if (nameInvalid || priceInvalid) {
      setState(() {
        _nameHasError = nameInvalid;
        _priceHasError = priceInvalid;
      });
      return;
    }

    final quantity = _quantity > 0 ? _quantity : 1.0;

    setState(() => _isSaving = true);

    try {
      final dimensions = _dimensionsController.text.trim();
      final brand = _brandController.text.trim();
      final article = _articleController.text.trim();
      final store = _storeController.text.trim();

      if (_isEditing) {
        final old = state.materialById(widget.materialId!);
        if (old != null) {
          await _cleanupRemovedOriginalPhotos(old.photoPaths);
        }

        cubit.updateMaterial(
          materialId: widget.materialId!,
          roomId: roomId,
          name: name,
          photoPaths: List<String>.from(_photoPaths),
          dimensions: dimensions.isEmpty ? null : dimensions,
          quantity: quantity,
          unit: _unit,
          pricePerUnit: price,
          clearPhotoPaths: _photoPaths.isEmpty,
          clearDimensions: dimensions.isEmpty,
          brand: brand.isEmpty ? null : brand,
          article: article.isEmpty ? null : article,
          store: store.isEmpty ? null : store,
          clearBrand: brand.isEmpty,
          clearArticle: article.isEmpty,
          clearStore: store.isEmpty,
        );
      } else {
        cubit.addMaterial(
          roomId: roomId,
          name: name,
          quantity: quantity,
          unit: _unit,
          pricePerUnit: price,
          photoPaths: List<String>.from(_photoPaths),
          dimensions: dimensions.isEmpty ? null : dimensions,
          brand: brand.isEmpty ? null : brand,
          article: article.isEmpty ? null : article,
          store: store.isEmpty ? null : store,
        );
      }

      _photosSavedWithMaterial = true;
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteMaterial() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showRemontDialog<bool>(
      context,
      title: l10n.deleteMaterialTitle,
      content: Text(l10n.deleteMaterialMessage),
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

    if (confirmed != true || !mounted) {
      return;
    }

    final material =
        context.read<EstimateCubit>().state.materialById(widget.materialId!);
    if (material != null) {
      await MaterialImageStorage.deleteAllIfOwned(material.photoPaths);
      if (mounted) {
        context.read<EstimateCubit>().deleteMaterial(material.id);
        Navigator.of(context).pop();
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EstimateCubit, EstimateState>(
      builder: (context, state) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        final rooms = state.sortedRooms;
        final currencySymbol = AppCurrencies.symbolFor(state.currencyCode);

        if (rooms.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(l10n.addRoomBeforeMaterials),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEditing ? l10n.editMaterial : l10n.addMaterial,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 22),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _RoomSelector(
                    rooms: rooms,
                    selectedRoomId: _selectedRoomId,
                    onSelected: (id) => setState(() => _selectedRoomId = id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _nameController,
                    autofocus: !_isEditing,
                    required: true,
                    label: l10n.materialName,
                    hint: l10n.materialNameHint,
                    textCapitalization: TextCapitalization.sentences,
                    errorText:
                        _nameHasError ? l10n.enterMaterialName : null,
                    onChanged: (_) {
                      if (_nameHasError) {
                        setState(() => _nameHasError = false);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MaterialPhotoPicker(
                    photoPaths: _photoPaths,
                    onPickCamera: () => _pickImage(ImageSource.camera),
                    onPickGallery: () => _pickImage(ImageSource.gallery),
                    onRemovePath: _removePhoto,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppSheetSectionTitle(l10n.materialDetails),
                  AppTextField(
                    controller: _brandController,
                    label: l10n.materialBrand,
                    hint: l10n.materialBrandHint,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _articleController,
                    label: l10n.materialArticle,
                    hint: l10n.materialArticleHint,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _storeController,
                    label: l10n.materialStore,
                    hint: l10n.materialStoreHint,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _dimensionsController,
                    label: l10n.dimensionsOptional,
                    hint: l10n.dimensionsHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSheetSectionTitle(l10n.quantityAndUnit),
                  const SizedBox(height: AppSpacing.sm),
                  UnitSelectorChips(
                    selected: _unit,
                    onSelected: (unit) => setState(() => _unit = unit),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  QuantityStepper(
                    quantity: _quantity,
                    unit: _unit,
                    onChanged: (q) => setState(() => _quantity = q),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _priceController,
                    required: true,
                    label: l10n.pricePerUnit(
                      _unit.localizedLabel(context).toLowerCase(),
                    ),
                    hint: '0.00',
                    prefixText: '$currencySymbol ',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                    ],
                    errorText:
                        _priceHasError ? l10n.enterValidPrice : null,
                    onChanged: (_) {
                      setState(() {
                        if (_priceHasError) {
                          _priceHasError = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TotalPriceBanner(
                    total: _totalPrice,
                    currencyCode: state.currencyCode,
                    quantity: _quantity,
                    unit: _unit,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    label: _isEditing ? l10n.saveChanges : l10n.saveMaterial,
                    icon: Icons.check_rounded,
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _save,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _deleteMaterial,
                      child: Text(
                        l10n.deleteMaterial,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
            ],
          ),
        );
      },
    );
  }
}

class _RoomSelector extends StatelessWidget {
  const _RoomSelector({
    required this.rooms,
    required this.selectedRoomId,
    required this.onSelected,
  });

  final List<RoomModel> rooms;
  final String? selectedRoomId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSheetSectionTitle(l10n.room),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: rooms.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final room = rooms[index];
              final selected = room.id == selectedRoomId;
              return FilterChip(
                selected: selected,
                showCheckmark: false,
                label: Text(room.name),
                selectedColor: context.palette.accentMuted,
                onSelected: (_) => onSelected(room.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TotalPriceBanner extends StatelessWidget {
  const _TotalPriceBanner({
    required this.total,
    required this.currencyCode,
    required this.quantity,
    required this.unit,
  });

  final double total;
  final String currencyCode;
  final double quantity;
  final MaterialUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final qtyLabel = quantity % 1 == 0
        ? quantity.toInt().toString()
        : quantity.toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.accentMuted,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalPrice,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  CurrencyFormatter.format(total, currencyCode),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: context.palette.accent,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '$qtyLabel × ${unit.localizedLabel(context)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: context.palette.textTertiary,
                ),
          ),
        ],
      ),
    );
  }
}
