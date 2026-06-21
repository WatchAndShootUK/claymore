import 'package:claymore/models/control.dart';
import 'package:claymore/models/trg_event.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/ui/uploader_dialog.dart';
import 'package:claymore/ui/add_control.dart';
import 'package:claymore/ui/add_trg_event.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/control_tile.dart';
import 'package:claymore/ui/currency_table.dart';
import 'package:claymore/ui/trg_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndividualPanel extends StatefulWidget {
  const IndividualPanel({super.key});

  @override
  State<StatefulWidget> createState() => _IndividualPanelState();
}

class _IndividualPanelState extends State<IndividualPanel> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final appData = context.watch<AppData>();
    final selectedJtac = appData.selectedJtac;
    final visibleControls =
        appData.controls
            .where((control) => control.controllingJTACId == selectedJtac!.id)
            .toList()
          ..sort((a, b) => b.controlDate.compareTo(a.controlDate));

    final visibleTrgEvents =
        appData.trgEvents
            .where((te) => te.trgJtacID == selectedJtac!.id)
            .toList()
          ..sort((a, b) => b.trgDate.compareTo(a.trgDate));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: BoxBorder.all(width: 1, color: Colors.black38),
        color: Colors.grey.shade900,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(3, 3),
          ),
        ],
      ),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 6, 12),
      child: Column(
        children: [
          if (isMobile)
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(5, 5, 0, 5),
              child: SizedBox(
                width: 200,
                child: Text(
                  '${selectedJtac?.getUserName as String} (${selectedJtac?.qualification})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          SizedBox(
            height: isMobile ? 56 : 66,
            child: Row(
              spacing: 12.0,
              children: [
                SizedBox(width: 2),
                if (!isMobile)
                  SizedBox(
                    width: 200,
                    child: Text(
                      '${selectedJtac?.getUserName as String} (${selectedJtac?.qualification})',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                _tabButton('Controls', 'controls'),
                _tabButton('Training', 'training'),
                _tabButton('Evaluations', 'evaluations'),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey),

          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [const Color(0xFF1E1E1E), Colors.grey.shade800],
                    ),
                  ),
                  child: switch (appData.currentView) {
                    'controls' => ListView.builder(
                      itemCount: visibleControls.length,
                      itemBuilder: (context, index) {
                        final control = visibleControls[index];

                        return ControlTile(control: control, onTap: () {});
                      },
                    ),

                    'training' => ListView.builder(
                      itemCount: visibleTrgEvents.length,
                      itemBuilder: (context, index) {
                        TrgEvent te = visibleTrgEvents[index];
                        return TrgTile(trgEvent: te);
                      },
                    ),

                    'evaluations' => ListView.builder(
                      itemCount: visibleControls.length,
                      itemBuilder: (context, index) {
                        final evaluation = visibleControls[index];

                        return Container();
                      },
                    ),

                    _ => const Center(
                      child: Text(
                        'Unknown view',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  },
                ),
                if (appData.selectedJtac == appData.currentUser)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: AlignmentGeometry.bottomEnd,
                      child: switch (appData.currentView) {
                        'controls' => ClaymoreButton(
                          text: 'Add Control',
                          backgroundColor: Colors.green.shade800,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AddControlDialog(
                              control: Control.empty(appData.currentUser.id),
                              readOnly: false,
                            ),
                          ),
                        ),
                        'training' => ClaymoreButton(
                          text: 'Add New',
                          backgroundColor: Colors.green.shade800,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AddTrgEventDialog(
                              trgEvent: TrgEvent.empty(appData.currentUser.id),
                              readOnly: false,
                            ),
                          ),
                        ),
                        _ => SizedBox.shrink(),
                      },
                    ),
                  ),
                if (appData.selectedJtac == appData.currentUser)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: AlignmentGeometry.bottomStart,
                      child: ClaymoreButton(
                        text: 'Upload Control',
                        backgroundColor: Colors.yellow.shade800,
                        onPressed: () => uploaderDialog(context, appData),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MediaQuery.of(context).size.width > 1200
                ? LargeCurrencyTable(user: selectedJtac as User)
                : SmallCurrencyTable(user: selectedJtac as User),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String text, String view) {
    final appData = context.watch<AppData>();
    final selected = appData.currentView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            appData.currentView = view;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          decoration: BoxDecoration(
            color: selected ? Colors.grey.shade800 : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: selected ? Colors.blueGrey : Colors.white24,
                width: selected ? 3 : 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
