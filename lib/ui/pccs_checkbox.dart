import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/checkbox.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:claymore/ui/label.dart';
import 'package:claymore/ui/textfield.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PccsCheckbox extends StatefulWidget {
  final String input;

  const PccsCheckbox({super.key, required this.input});

  @override
  State<PccsCheckbox> createState() => _PccsCheckboxState();
}

class _PccsCheckboxState extends State<PccsCheckbox> {
  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    final firstSpace = widget.input.indexOf(' ');

    final inputSerial = firstSpace == -1
        ? widget.input
        : widget.input.substring(0, firstSpace);

    final inputString = firstSpace == -1
        ? ''
        : widget.input.substring(firstSpace + 1);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 45,
                child: Text(
                  inputSerial,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(child: ClaymoreLabel(inputString)),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: IgnorePointer(
                  ignoring: ![
                    'JTAC-I',
                    'JTAC-E',
                  ].contains(appData.currentUser.qualification),
                  child: ClaymoreCheckbox(
                    label: 'Achieved',
                    value: appData.selectedJtac?.pccs[inputSerial] != null,
                    onChanged: (value) {
                      setState(() {
                        if (appData.selectedJtac?.pccs[inputSerial] != null &&
                            appData.selectedJtac?.pccs[inputSerial] !=
                                appData.currentUser.id) {
                          return;
                        }
                        if (value) {
                          appData.selectedJtac?.pccs[inputSerial] =
                              appData.currentUser.id;
                        } else {
                          appData.selectedJtac?.pccs.remove(inputSerial);
                        }
                        FirestoreService.update(
                          collectionPath: 'users',
                          docId: appData.selectedJtac?.id as String,
                          data:
                              appData.selectedJtac?.toFirestore()
                                  as Map<String, dynamic>,
                        );
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: IgnorePointer(
                  ignoring: true,
                  child: ClaymoreTextField(
                    key: ValueKey(appData.selectedJtac?.pccs[inputSerial]),
                    label: 'Supervised By',
                    initialValue:
                        appData.selectedJtac?.pccs[inputSerial] != null
                        ? appData.users
                              .firstWhere(
                                (user) =>
                                    user.id ==
                                    appData.selectedJtac?.pccs[inputSerial],
                              )
                              .getUserName
                        : '',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(color: Colors.white, height: 1),
        ],
      ),
    );
  }
}
