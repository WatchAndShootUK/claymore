import 'package:claymore/models/control.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/pages/add_control.dart';
import 'package:claymore/pages/right_hand_panel.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/control_tile.dart';
import 'package:claymore/ui/currency_table.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? selectedJtac;
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    selectedJtac ??= appData.currentUser;
    final visibleControls = selectedJtac?.id == 'all'
        ? appData.controls
        : appData.controls
              .where((control) => control.controllingJTACId == selectedJtac!.id)
              .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Controls
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            color: Colors.grey.shade800,
                            child: Column(
                              children: [
                                SizedBox(height: 12),
                                Row(
                                  spacing: 12.0,
                                  children: [
                                    SizedBox(width: 2),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 200,
                                      ),
                                      child: ClaymoreDropdown<User>(
                                        label: 'View controls for',
                                        value: appData.currentUser,
                                        items: appData.users,

                                        itemLabel: (user) {
                                          if (user.id == 'all') {
                                            return 'All JTACs';
                                          }
                                          return '${user.rank} ${user.firstName[0]} ${user.lastName} ${user.qualification}';
                                        },
                                        onChanged: (user) {
                                          if (user == null) return;

                                          setState(() {
                                            selectedJtac = user;
                                          });
                                        },
                                      ),
                                    ),
                                    Spacer(),
                                    if (selectedJtac?.id !=
                                            appData.currentUser.id &&
                                        visibleControls.any(
                                          (c) => c.approved == false,
                                        ) &&
                                        ['JTAC-I', 'JTAC-E'].contains(
                                          appData.currentUser.qualification,
                                        ))
                                      ClaymoreButton(
                                        onPressed: () async {
                                          if (await showApproveDialog(
                                            context,
                                          )) {
                                            setState(() {
                                              for (Control c
                                                  in visibleControls) {
                                                if (c.approved == false) {
                                                  c.approved = true;
                                                  FirestoreService.update(
                                                    collectionPath: 'controls',
                                                    docId: c.id,
                                                    data: c.toFirestore(),
                                                  );
                                                }
                                              }
                                            });
                                          }
                                        },
                                        text: "Approve All",
                                        icon: Icons.check,
                                      ),
                                    if (appData.currentUser.id ==
                                        selectedJtac?.id)
                                      ClaymoreButton(
                                        text: 'Add Control',
                                        icon: Icons.add,
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AddControlDialog(
                                                control: Control.empty(
                                                  appData.currentUser.id,
                                                ),
                                              ),
                                        ),
                                      ),

                                    SizedBox(width: 2),
                                  ],
                                ),

                                SizedBox(height: 12),
                                Container(height: 1,color: Colors.grey,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF1E1E1E),
                                          Colors.grey.shade800,
                                        ],
                                      ),
                                    ),
                                    child: ListView.builder(
                                      itemCount: visibleControls.length,
                                      itemBuilder: (context, index) {
                                        final control = visibleControls[index];

                                        return ControlTile(
                                          control: control,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(height: 1,color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MediaQuery.of(context).size.width > 700
                                      ? LargeCurrencyTable(
                                          user: selectedJtac as User,
                                        )
                                      : SmallCurrencyTable(
                                          user: selectedJtac as User,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (MediaQuery.of(context).size.width > 1000)
                          RightHandPanel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
