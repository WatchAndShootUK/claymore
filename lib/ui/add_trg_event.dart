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

class AddTrgEventDialog extends StatefulWidget {
  final TrgEvent trgEvent;
  final bool readOnly;

  const AddTrgEventDialog({
    super.key,
    required this.trgEvent,
    required this.readOnly,
  });

  @override
  State<AddTrgEventDialog> createState() => _AddTrgEventDialogState();
}

class _AddTrgEventDialogState extends State<AddTrgEventDialog> {
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
              widget.readOnly ? 'View Training Event' : 'Add Training Event',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: widget.readOnly,
                  child: Column(
                    spacing: 16,
                    children: [
                      _section(
                        title: 'About',
                        child: Column(
                          spacing: 10,
                          children: [
                            ClaymoreDatePicker(
                              label: 'Date',
                              value: widget.trgEvent.trgDate,
                              onChanged: (value) {
                                setState(() {
                                  widget.trgEvent.trgDate = value;
                                });
                              },
                            ),
                            ClaymoreTextField(
                              label: 'Location',
                              initialValue: widget.trgEvent.trgLocation,
                              onChanged: (value) {
                                setState(() {
                                  widget.trgEvent.trgLocation = value;
                                });
                              },
                            ),
                            if (appData.currentUser.qualification == 'JTAC-C')
                              ClaymoreDropdown<User>(
                                label: 'Supervised By',
                                value: appData.users.firstWhereOrNull(
                                  (user) =>
                                      user.id ==
                                      widget.trgEvent.trgSupervisorID,
                                ),
                                items: appData.users
                                    .where(
                                      (user) => [
                                        'JTAC-I',
                                        'JTAC-E',
                                      ].contains(user.qualification),
                                    )
                                    .toList(),
                                itemLabel: (user) =>
                                    '${user.rank} ${user.firstName[0]} ${user.lastName} ${user.qualification}',
                                onChanged: (user) {
                                  if (user == null) return;

                                  setState(() {
                                    if (user.id != appData.currentUser.id) {
                                      widget.trgEvent.trgSupervisorID = user.id;
                                    }
                                  });
                                },
                              ),
                            ClaymoreDropdown(
                              label: 'Training Type',
                              value: widget.trgEvent.trgType != ''
                                  ? widget.trgEvent.trgType
                                  : null,
                              items: ['PCCS Training', 'PMS Training'],
                              itemLabel: (item) => item,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  widget.trgEvent.trgType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (widget.trgEvent.trgType == 'PCCS Training')
                        _section(
                          title: 'Post Course Consolidation Syllabus',
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: PCCS.items.length,
                            itemBuilder: (context, index) {
                              return _pccsLine(
                                input: PCCS.items[index],
                                readOnly: widget.readOnly,
                              );
                            },
                          ),
                        ),
                      if (widget.trgEvent.trgType == 'PMS Training')
                        _section(
                          title: 'Point Mensuration Training',
                          child: Column(
                            spacing: 6,
                            children: [
                              pmsOption('PMS Course'),
                              pmsOption('6 point drop'),
                              pmsOption('12 point drop'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            _actionBar(appData: appData, isEditing: true, context: context),
          ],
        ),
      ),
    );
  }

  Widget _pccsLine({required String input, required bool readOnly}) {
    final appData = context.read<AppData>();
    bool alreadyPCCS =
        appData.currentUser.qualification != 'JTAC-C' ||
        appData.selectedJtac == appData.currentUser;
    final firstSpace = input.indexOf(' ');

    final inputSerial = firstSpace == -1
        ? input
        : input.substring(0, firstSpace);

    final inputString = firstSpace == -1 ? '' : input.substring(firstSpace + 1);
    if (readOnly && !widget.trgEvent.trgDetails.contains(inputSerial)) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        IgnorePointer(
          ignoring: alreadyPCCS,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 9,
            children: [
              Text(
                inputSerial,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Expanded(child: ClaymoreLabel(inputString)),
              Checkbox(
                value: alreadyPCCS
                    ? true
                    : widget.trgEvent.trgDetails.contains(inputSerial),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      if (!widget.trgEvent.trgDetails.contains(inputSerial)) {
                        widget.trgEvent.trgDetails.add(inputSerial);
                      }
                    } else {
                      widget.trgEvent.trgDetails.remove(inputSerial);
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Container(color: Colors.white, height: 1),
        SizedBox(height: 9),
      ],
    );
  }

  Widget pmsOption(String label) {
    final selected = widget.trgEvent.trgDetails.contains(label);

    if (widget.readOnly && !selected) {
      return const SizedBox.shrink();
    }

    return ClaymoreCheckbox(
      label: label,
      value: selected,
      onChanged: (value) {
        setState(() {
          if (value) {
            widget.trgEvent.trgDetails
              ..remove('PMS Course')
              ..remove('6 point drop')
              ..remove('12 point drop')
              ..add(label);
          } else {
            widget.trgEvent.trgDetails.remove(label);
          }
        });
      },
    );
  }

  Widget _actionBar({
    required AppData appData,
    required BuildContext context,
    required bool isEditing,
  }) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        if (!isEditing)
          ClaymoreButton(
            onPressed: widget.trgEvent.id.isEmpty
                ? null
                : () async {
                    if (!await showDeleteDialog(context)) return;

                    try {
                      await FirestoreService.delete(
                        collectionPath: 'training',
                        docId: widget.trgEvent.id,
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint('Failed to delete control: $e');

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete control: $e')),
                      );
                    }
                  },
            text: 'Delete',
          ),
        ClaymoreButton(
          onPressed: () => Navigator.pop(context),
          text: widget.readOnly ? 'Back' : 'Cancel',
        ),
        if (!widget.readOnly)
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
                if (appData.currentUser.qualification != 'JTAC-C') {
                  widget.trgEvent.approved = true;
                }
                await FirestoreService.create(
                  collectionPath: 'training',
                  data: widget.trgEvent.toFirestore(),
                );

                if (!context.mounted) return;
                Navigator.pop(context);
              } catch (e) {
                debugPrint('Failed to save control: $e');

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save control: $e')),
                );
              }
            },
            text: 'Add',
          ),
      ],
    );
  }

  List<String> checkFields() {
    final appData = context.read<AppData>();
    List<String> errorMessage = [];

    if (widget.trgEvent.trgSupervisorID == '' &&
        appData.currentUser.qualification == 'JTAC-C') {
      errorMessage.add(
        'You must nominate a JTAC-I approver for this activity.',
      );
    }
    if (widget.trgEvent.trgType == '') {
      errorMessage.add('You must select the type of training conducted.');
    }
    if (widget.trgEvent.trgDetails.isEmpty) {
      errorMessage.add('You must select the details of the training.');
    }
    if (widget.trgEvent.trgLocation == '') {
      errorMessage.add('You must select the location of the training.');
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
