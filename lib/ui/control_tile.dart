import 'package:claymore/models/control.dart';
import 'package:claymore/pages/add_control.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ControlTile extends StatefulWidget {
  final Control control;
  final VoidCallback? onTap;

  const ControlTile({super.key, required this.control, this.onTap});

  @override
  State<ControlTile> createState() => _ControlTileState();
}

class _ControlTileState extends State<ControlTile> {
  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    final control = widget.control;
    List<Color> getColours() {
      if (control.environment == 'Simulated') {
        return [Color(0xFF1F3B5B), Color(0xFF2D4F73), Color(0xFF3A3A3A)];
      }
      if (control.environment == 'Hot') {
        return [Color(0xFF5B1F1F), Color(0xFF733333), Color(0xFF3A3A3A)];
      }
      if (control.environment == 'Operational') {
        return [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFF616161)];
      }
      return [Color(0xFF1E1E1E), Color(0xFF262626), Color(0xFF303030)];
    }

    List<String> getConstraints() {
      List<String> data = [];
      if (control.typeofControl == 1) data.add('T1');
      if (control.typeofControl == 2) data.add('T2');
      if (control.typeofControl == 3) data.add('T3');
      if (control.methodOfAttack == 'BoC') data.add('BoT');
      if (control.methodOfAttack == 'BoT') data.add('BoC');
      if (control.laserMark) data.add('Laser');
      if (control.irMark) data.add('IR');
      if (control.remoteObserver) data.add('JFO');
      if (control.fmv) data.add('VDL');
      if (control.live) data.add('Hot');
      if (control.nonPermissive) data.add('NP');
      if (control.day) data.add('Day');
      if (control.night) data.add('Night');
      if (control.lowLevel) data.add('LL');
      if (control.supervisedById != appData.currentUser.id &&
          control.supervisedById != '') {
        data.add('SUP');
      }
      return data;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: getColours(),
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: control.approved ? Colors.white10 : Colors.red,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              FaIcon(
                control.rwAircraft
                    ? FontAwesomeIcons.helicopter
                    : FontAwesomeIcons.plane,
                color: control.grading ? Colors.green : Colors.red,
                size: 25,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${control.controlDate.day}/${control.controlDate.month}/${control.controlDate.year}: ${control.operationName == '' ? 'Unknown' : control.operationName} - ${control.controlLocation == '' ? 'Planet Earth' : control.controlLocation}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width > 1000
                            ? 16
                            : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      control.controllingJTACId != appData.currentUser.id
                          ? '${appData.users.firstWhere((u) => u.id == control.controllingJTACId).getUserName}: '
                                '${getConstraints().join(', ')}'
                          : getConstraints().join(', '),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width > 1000
                            ? 14
                            : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (control.controllingJTACId == appData.currentUser.id)
                GestureDetector(
                  child: const Icon(Icons.delete, color: Colors.red),
                  onTap: () async {
                    if (await showDeleteDialog(context)) {
                      await FirestoreService.delete(
                        collectionPath: 'controls',
                        docId: control.id,
                      );
                    }
                  },
                ),
              if (control.controllingJTACId != appData.currentUser.id)
                GestureDetector(
                  child: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white54,
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AddControlDialog(
                      control: control,
                      readOnly: true
                    ),
                  ),
                ),
              if (control.controllingJTACId == appData.currentUser.id)
                GestureDetector(
                  child: const Icon(Icons.copy, color: Colors.white54),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AddControlDialog(
                      control: control.deepCopy(appData.currentUser.id),
                      readOnly: false,
                    ),
                  ),
                ),
              if (control.controllingJTACId != appData.currentUser.id &&
                  !control.approved &&
                  [
                    'JTAC-I',
                    'JTAC-E',
                  ].contains(appData.currentUser.qualification))
                GestureDetector(
                  child: const Icon(Icons.check, color: Colors.white54),
                  onTap: () async {
                    if (await showApproveDialog(context)) {
                      setState(() {
                        control.approved = true;
                        FirestoreService.update(
                          collectionPath: 'controls',
                          docId: control.id,
                          data: control.toFirestore(),
                        );
                      });
                    }
                  },
                ),
              if (control.controllingJTACId == appData.currentUser.id)
                GestureDetector(
                  child: const Icon(Icons.edit, color: Colors.white54),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AddControlDialog(control: control,readOnly: false,),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
