import 'package:flutter/material.dart';

class RightHandPanel extends StatelessWidget {
  const RightHandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(12),
                          child: Image(image: AssetImage('assets/logo.jpg')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 12, 12),
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 12, 12),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
