import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class AddRoomSheet extends StatefulWidget {
  const AddRoomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showRemontSheet<void>(
      context,
      child: const AddRoomSheet(),
    );
  }

  @override
  State<AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends State<AddRoomSheet> {
  final _nameController = TextEditingController();
  bool _nameHasError = false;

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

    context.read<EstimateCubit>().addRoom(name: name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppSheetBody(
      title: l10n.addRoom,
      footer: AppPrimaryButton(
        label: l10n.saveRoom,
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
