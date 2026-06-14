import 'package:flutter/material.dart';

Widget ClaymoreLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 16),
    ),
  );
}
