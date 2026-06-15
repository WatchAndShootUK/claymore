import 'package:flutter/material.dart';

class ClaymoreButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final IconData? icon;

  const ClaymoreButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xFF2F2F2F),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF4A4A4A)),
          ),
        ),
        child: MediaQuery.of(context).size.width > 600
            ? Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              )
            : icon != null
            ? Icon(icon, color: textColor, size: 18)
            : Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
