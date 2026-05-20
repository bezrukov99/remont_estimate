import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/widgets/app_text_field.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';

class QuantityStepper extends StatefulWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.unit,
    required this.onChanged,
  });

  final double quantity;
  final MaterialUnit unit;
  final ValueChanged<double> onChanged;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  late final TextEditingController _controller;

  double get _step => switch (widget.unit) {
        MaterialUnit.squareMeters ||
        MaterialUnit.meters ||
        MaterialUnit.liters ||
        MaterialUnit.kilograms =>
          0.5,
        _ => 1,
      };

  double get _min => _step;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.quantity));
  }

  @override
  void didUpdateWidget(QuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = _format(widget.quantity);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() => widget.onChanged(widget.quantity + _step);

  void _decrement() {
    final next = widget.quantity - _step;
    if (next >= _min) {
      widget.onChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(
          icon: Icons.remove_rounded,
          onPressed: widget.quantity > _min ? _decrement : null,
        ),
        Expanded(
          child: AppCompactTextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            onSubmitted: _parseAndEmit,
            onEditingComplete: () => _parseAndEmit(_controller.text),
          ),
        ),
        _StepButton(
          icon: Icons.add_rounded,
          onPressed: _increment,
        ),
      ],
    );
  }

  void _parseAndEmit(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed != null && parsed > 0) {
      widget.onChanged(parsed);
    } else {
      _controller.text = _format(widget.quantity);
    }
  }

  static String _format(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surfaceMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            icon,
            color:
                onPressed != null ? context.palette.accent : context.palette.textTertiary,
          ),
        ),
      ),
    );
  }
}
