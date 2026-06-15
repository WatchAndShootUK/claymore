import 'package:claymore/models/user.dart';
import 'package:flutter/material.dart';

class UserRow extends StatefulWidget {
  final User user;
  const UserRow({super.key, required this.user});

  @override
  State<UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<UserRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(children: [Text(widget.user.firstName)]),
    );
  }
}
