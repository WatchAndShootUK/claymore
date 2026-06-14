import 'package:flutter/material.dart';

class ClaymoreDatePicker extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const ClaymoreDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = '${value.day}/${value.month}/${value.year}';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.grey.shade700,
                  onPrimary: Colors.white,
                  surface: const Color(0xFF2F2F2F),
                  onSurface: Colors.white,
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Color(0xFF202020),
                ),
              ),
              child: child!,
            );
          },
        );

        if (selected != null) {
          onChanged(selected);
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF4A4A4A),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$label: $dateText',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_month,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}