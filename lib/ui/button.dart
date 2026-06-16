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
    final compact = MediaQuery.of(context).size.width < 800;

    return SizedBox(
      height: 36,
      width: compact ? (icon == null ? 130 : 48) : 130,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor.withOpacity(1.0),
              backgroundColor.withOpacity(0.9),
              const Color(0xFF1E1E1E),
            ],
          ),
          border: Border.all(color: Colors.black87, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 15,
              blurStyle: BlurStyle.normal,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: compact && icon != null
                  ? Icon(icon, color: textColor, size: 20)
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
