import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class EditRoomSheet extends StatefulWidget {
  const EditRoomSheet({
    super.key,
    required this.roomId,
    required this.initialName,
  });

  final String roomId;
  final String initialName;

  static Future<void> show(
    BuildContext context, {
    required String roomId,
    required String initialName,
  }) {
    return showRemontSheet<void>(
      context,
      child: BlocProvider.value(
        value: context.read<EstimateCubit>(),
        child: EditRoomSheet(roomId: roomId, initialName: initialName),
      ),
    );
  }

  @override
  State<EditRoomSheet> createState() => _EditRoomSheetState();
}

class _EditRoomSheetState extends State<EditRoomSheet> {
  late final TextEditingController _nameController;
  bool _nameHasError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameHasError = true);
      return;
    }

    context.read<EstimateCubit>().updateRoom(
          roomId: widget.roomId,
          name: name,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppSheetBody(
      title: l10n.editRoom,
      footer: AppPrimaryButton(
        label: l10n.saveChanges,
        icon: Icons.check_rounded,
        onPressed: _save,
      ),
      children: [
        AppTextField(
          controller: _nameController,
          autofocus: true,
          label: l10n.roomName,
          hint: l10n.roomNameHint,
          textCapitalization: TextCapitalization.words,
          errorText: _nameHasError ? l10n.enterRoomName : null,
          onChanged: (_) {
            if (_nameHasError) {
              setState(() => _nameHasError = false);
            }
          },
          onSubmitted: (_) => _save(),
        ),
      ],
    );
  }
}
