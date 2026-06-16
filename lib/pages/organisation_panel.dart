import 'package:claymore/models/user.dart';
import 'package:claymore/services/currency_calculator.dart';
import 'package:claymore/services/pms_calculator.dart';
import 'package:claymore/state/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganisationPanel extends StatefulWidget {
  const OrganisationPanel({super.key});

  @override
  State<OrganisationPanel> createState() => _OrganisationPanelState();
}

class _OrganisationPanelState extends State<OrganisationPanel> {
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();

    return Container(
      margin: const EdgeInsets.fromLTRB(6, 12, 12, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF141414),
            Colors.grey.shade900,
            const Color(0xFF242424),
          ],
        ),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _titleBar(),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                },
                border: TableBorder.all(color: Colors.black54, width: 1),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF333333), Color(0xFF1F1F1F)],
                      ),
                    ),
                    children: [
                      _headerCell('JTAC'),
                      _headerCell('PCCS'),
                      _headerCell('6'),
                      _headerCell('12'),
                      _headerCell('PMS'),
                      _headerCell('Eval'),
                    ],
                  ),
                  ...appData.users.map((user) {
                    final userControls = appData.controls
                        .where((c) => c.controllingJTACId == user.id)
                        .toList();

                    final sixMonthCurrent = CurrencyCalculator.calculate6Month(
                      user: user,
                      controls: userControls,
                    ).allTrue;

                    final twelveMonthCurrent =
                        CurrencyCalculator.calculate12Month(
                          user: user,
                          controls: userControls,
                        ).allTrue;

                    return TableRow(
                      decoration: BoxDecoration(
                        color: appData.users.indexOf(user).isEven
                            ? const Color(0xFF202020)
                            : const Color(0xFF181818),
                      ),
                      children: [
                        SizedBox(
                          height: 42,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  appData.selectedJtac = user;
                                },
                                child: Text(
                                  user.getUserName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        appData.selectedJtac?.getUserName ==
                                            user.getUserName
                                        ? Colors.white
                                        : Colors.white70,
                                    fontSize:
                                        appData.selectedJtac?.getUserName ==
                                            user.getUserName
                                        ? 15
                                        : 13,
                                    fontWeight:
                                        appData.selectedJtac?.getUserName ==
                                            user.getUserName
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        statusCell(
                          user.qualification != 'JTAC-C' ? true : false,
                          appData.selectedJtac?.getUserName == user.getUserName,
                        ),
                        statusCell(
                          sixMonthCurrent,
                          appData.selectedJtac?.getUserName == user.getUserName,
                        ),
                        statusCell(
                          twelveMonthCurrent,
                          appData.selectedJtac?.getUserName == user.getUserName,
                        ),
                        statusCell(
                          pmsCurrent(user, appData.trgEvents),
                          appData.selectedJtac?.getUserName == user.getUserName,
                        ),
                        statusCell(
                          false,
                          appData.selectedJtac?.getUserName == user.getUserName,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Row(
      children: const [
        Icon(Icons.groups, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Text(
          'Lloyds (Air) Troop Readiness Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text) {
    return SizedBox(
      height: 38,
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget statusCell(bool value, bool highlighted) {
    final colours = value
        ? [
            const Color(0xFF123F17),
            highlighted ? Colors.lightGreenAccent : const Color(0xFF43A047),
            const Color(0xFF1B5E20),
          ]
        : [
            const Color(0xFF5A1010),
            highlighted ? Colors.redAccent : const Color(0xFFE53935),
            const Color(0xFF8B0000),
          ];

    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colours,
              stops: const [0.0, 0.45, 1.0],
            ),
            border: Border.all(color: Colors.black87, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 1,
                right: 1,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
