import 'package:flutter/material.dart';

import '../../core/format/formatters.dart';

class EnumDropdown<T extends Enum> extends StatelessWidget {
  const EnumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [for (final v in values) DropdownMenuItem(value: v, child: Text(itemLabel(v)))],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.allowClear = false,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool allowClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(1996),
          lastDate: now,
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: allowClear && value != null
              ? IconButton(tooltip: 'Wissen', icon: const Icon(Icons.clear), onPressed: () => onChanged(null))
              : const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(value == null ? 'Niet ingevuld' : Fmt.date(value)),
      ),
    );
  }
}

/// Money input accepting "12,50" or "12.50". Optional unless [required] is set.
class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.controller, required this.label, this.required = false, this.helper});

  final TextEditingController controller;
  final String label;
  final bool required;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixText: '€ ', helperText: helper),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return required ? 'Verplicht' : null;
        return parseMoneyInput(v) == null ? 'Ongeldig bedrag (max. 2 decimalen)' : null;
      },
    );
  }
}
