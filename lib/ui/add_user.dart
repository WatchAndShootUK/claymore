import 'package:claymore/models/pccs.dart';
import 'package:claymore/models/trg_event.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/checkbox.dart';
import 'package:claymore/ui/date_picker.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:claymore/ui/label.dart';
import 'package:claymore/ui/textfield.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserDialog extends StatefulWidget {
  final User user;
  final bool isEditing;

  const AddUserDialog({super.key, required this.user, required this.isEditing});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  bool get _isMobile => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();

    return Dialog(
      backgroundColor: Colors.grey.shade900,
      insetPadding: _isMobile ? EdgeInsets.all(12) : EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.isEditing ? 'Edit User' : 'Add User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    _section(
                      title: 'About',
                      child: Column(
                        spacing: 10,
                        children: [
                          ClaymoreTextField(
                            label: 'Rank',
                            initialValue: widget.user.rank,
                            onChanged: (value) {
                              setState(() {
                                widget.user.rank = value;
                              });
                            },
                          ),
                          ClaymoreTextField(
                            label: 'First Name',
                            initialValue: widget.user.firstName,
                            onChanged: (value) {
                              setState(() {
                                widget.user.firstName = value;
                              });
                            },
                          ),
                          ClaymoreTextField(
                            label: 'Surname',
                            initialValue: widget.user.lastName,
                            onChanged: (value) {
                              setState(() {
                                widget.user.lastName = value;
                              });
                            },
                          ),
                          _section(
                            title: 'JTAC',
                            child: Column(
                              spacing: 20,
                              children: [
                                ClaymoreTextField(
                                  label: 'Callsign',
                                  initialValue: widget.user.callsign,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.user.callsign = value;
                                    });
                                  },
                                ),
                                ClaymoreDropdown<String>(
                                  label: 'Qualification',
                                  value: widget.user.qualification,
                                  items: ['JTAC-C', 'JTAC-Q', 'JTAC-I', 'JTAC-E', ''],
                                  itemLabel: (item) => item,
                                  onChanged: (qual) {
                                    if (qual == null) return;

                                    setState(() {
                                      widget.user.qualification = qual;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            _actionBar(appData: appData, context: context),
          ],
        ),
      ),
    );
  }

  Widget _actionBar({required AppData appData, required BuildContext context}) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        if (widget.isEditing)
          ClaymoreButton(
            onPressed: widget.user.id.isEmpty
                ? null
                : () async {
                    if (!await showDeleteDialog(context)) return;

                    try {
                      await FirestoreService.delete(
                        collectionPath: 'users',
                        docId: widget.user.id,
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint('Failed to delete user: $e');

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete user: $e')),
                      );
                    }
                  },
            text: 'Delete',
          ),
        ClaymoreButton(
          onPressed: () => Navigator.pop(context),
          text: widget.isEditing ? 'Back' : 'Cancel',
        ),

        ClaymoreButton(
          onPressed: () async {
            if (checkFields().isNotEmpty) {
              showMessageDialog(
                context,
                title: 'Error',
                message: checkFields().join('\n'),
              );
              return;
            }

            try {
              if (widget.isEditing) {
                await FirestoreService.update(
                  collectionPath: 'users',
                  docId: widget.user.id,
                  data: widget.user.toFirestore(),
                );
              } else {
                await FirestoreService.create(
                  collectionPath: 'users',
                  data: widget.user.toFirestore(),
                );
              }
              if (!context.mounted) return;
              Navigator.pop(context);
            } catch (e) {
              debugPrint('Failed to save user: $e');

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save user: $e')),
              );
            }
          },
          text: widget.isEditing ? 'Update' : 'Add',
        ),
      ],
    );
  }

  List<String> checkFields() {
    List<String> errorMessage = [];

    if (widget.user.firstName == '') {
      errorMessage.add('Enter first name.');
    }
    if (widget.user.lastName == '') {
      errorMessage.add('Enter last name.');
    }
    if (widget.user.callsign == '') {
      errorMessage.add('Enter callsign.');
    }
    if (widget.user.qualification == '') {
      errorMessage.add('Enter qualification.');
    }

    return errorMessage;
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: _isMobile ? MediaQuery.of(context).size.width - 32 : 520,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
