import 'package:flutter/material.dart';

class ClaymoreCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ClaymoreCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
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
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),

          Checkbox(
            value: value,
            activeColor: Colors.blueAccent,
            checkColor: Colors.white,
            side: const BorderSide(
              color: Colors.white54,
            ),
            onChanged: (newValue) {
              onChanged(newValue ?? false);
            },
          ),
        ],
      ),
    );
  }
}