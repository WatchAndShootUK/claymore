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
    final compact = MediaQuery.of(context).size.width < 700;

    return SizedBox(
      height: 48,
      width: compact
          ? (icon == null ? 130 : 48)
          : 130,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF4A4A4A),
            ),
          ),
        ),
        child: compact && icon != null
            ? SizedBox.expand(
                child: Center(
                  child: Icon(
                    icon,
                    color: textColor,
                    size: 18,
                  ),
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}