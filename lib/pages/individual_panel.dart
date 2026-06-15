import 'package:claymore/models/control.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/pages/add_control.dart';
import 'package:claymore/pages/training_view.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/control_tile.dart';
import 'package:claymore/ui/currency_table.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:claymore/ui/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndividualPanel extends StatefulWidget {
  const IndividualPanel({super.key});

  @override
  State<StatefulWidget> createState() => _IndividualPanelState();
}

class _IndividualPanelState extends State<IndividualPanel> {
  String currentView = 'controls';
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final selectedJtac = appData.selectedJtac;
    final visibleControls = appData.controls
        .where((control) => control.controllingJTACId == selectedJtac!.id)
        .toList();
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
          SizedBox(
            height: 56,
            child: Row(
              spacing: 12.0,
              children: [
                SizedBox(width: 2),
                Text(
                  '${selectedJtac?.getUserName as String} (${selectedJtac?.qualification})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                _tabButton('Controls', 'controls'),
                _tabButton('Training', 'training'),
                _tabButton('Evaluations', 'evaluations'),

                if (appData.currentUser.id == selectedJtac?.id &&
                    currentView == 'controls')
                  ClaymoreButton(
                    text: 'Add Control',
                    icon: Icons.add,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddControlDialog(
                        control: Control.empty(appData.currentUser.id),
                        readOnly: false,
                      ),
                    ),
                  ),
                if (currentView == 'training')
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 700 ? 48 : 130,
                  ),
                if (appData.currentUser.id == selectedJtac?.id &&
                    currentView == 'evaluations')
                  ClaymoreButton(
                    text: 'Add Evaluation',
                    icon: Icons.add,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddControlDialog(
                        control: Control.empty(appData.currentUser.id),
                        readOnly: false,
                      ),
                    ),
                  ),

                if (appData.currentUser.id != selectedJtac?.id &&
                    currentView != 'training')
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 700 ? 48 : 130,
                  ),
                SizedBox(width: 2),
              ],
            ),
          ),

          Container(height: 1, color: Colors.grey),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E1E), Colors.grey.shade800],
                ),
              ),
              child: switch (currentView) {
                'controls' => ListView.builder(
                  itemCount: visibleControls.length,
                  itemBuilder: (context, index) {
                    final control = visibleControls[index];

                    return ControlTile(control: control, onTap: () {});
                  },
                ),

                'training' => TrainingView(),

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
    final selected = currentView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentView = view;
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
