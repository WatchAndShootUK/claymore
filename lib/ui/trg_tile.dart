import 'package:claymore/models/trg_event.dart';
import 'package:claymore/pages/add_trg_event.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TrgTile extends StatefulWidget {
  final TrgEvent trgEvent;
  final VoidCallback? onTap;

  const TrgTile({super.key, this.onTap, required this.trgEvent});

  @override
  State<TrgTile> createState() => _TrgTileState();
}

class _TrgTileState extends State<TrgTile> {
  @override
  Widget build(BuildContext context) {
    final appData = context.read<AppData>();
    List<Color> getColours() {
      if (widget.trgEvent.trgType == 'PCCS Training') {
        return [Colors.deepOrange, Colors.orange, Color(0xFF3A3A3A)];
      }
      if (widget.trgEvent.trgType == 'PMS Training') {
        return [Colors.deepPurple, Colors.purple, Color(0xFF3A3A3A)];
      }
      return [Color(0xFF1E1E1E), Color(0xFF262626), Color(0xFF303030)];
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
          color: widget.trgEvent.approved ? Colors.white10 : Colors.yellow,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              FaIcon(
                widget.trgEvent.trgType == 'PCCS Training'
                    ? FontAwesomeIcons.graduationCap
                    : FontAwesomeIcons.computer,
                color: Colors.white,
                size: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.trgEvent.trgDate.day}/${widget.trgEvent.trgDate.month}/${widget.trgEvent.trgDate.year}: ${widget.trgEvent.trgLocation}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width > 1000
                            ? 16
                            : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      widget.trgEvent.trgType == 'PCCS Training'
                          ? 'PCCS Training: ${widget.trgEvent.trgDetails.join(', ')}'
                          : 'PMS Training: ${widget.trgEvent.trgDetails.join(', ')}',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: MediaQuery.of(context).size.width > 1000
                            ? 14
                            : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.trgEvent.trgJtacID == appData.currentUser.id)
                GestureDetector(
                  child: const Icon(Icons.delete, color: Colors.red),
                  onTap: () async {
                    if (await showDeleteDialog(context)) {
                      await FirestoreService.delete(
                        collectionPath: 'training',
                        docId: widget.trgEvent.id,
                      );
                    }
                  },
                ),

              GestureDetector(
                child: const Icon(Icons.remove_red_eye, color: Colors.white54),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AddTrgEventDialog(
                    trgEvent: widget.trgEvent,
                    readOnly: true,
                  ),
                ),
              ),

              if (!widget.trgEvent.approved &&
                  [
                    'JTAC-I',
                    'JTAC-E',
                  ].contains(appData.currentUser.qualification))
                GestureDetector(
                  child: const Icon(Icons.check, color: Colors.white54),
                  onTap: () async {
                    if (await showApproveDialog(context)) {
                      setState(() {
                        widget.trgEvent.approved = true;
                        FirestoreService.update(
                          collectionPath: 'controls',
                          docId: widget.trgEvent.id,
                          data: widget.trgEvent.toFirestore(),
                        );
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
