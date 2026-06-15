import 'package:claymore/models/control.dart';
import 'package:claymore/models/countries.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/checkbox.dart';
import 'package:claymore/ui/date_picker.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:claymore/ui/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddControlDialog extends StatefulWidget {
  final Control control;

  const AddControlDialog({
    super.key,
    required this.control,
  });

  @override
  State<AddControlDialog> createState() => _AddControlDialogState();
}

class _AddControlDialogState extends State<AddControlDialog> {
  CountryLocation? selectedCountry;

  bool get _isMobile => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.control.id.isNotEmpty;
    final appData = context.read<AppData>();

    return Dialog(
      backgroundColor: Colors.grey.shade900,
      insetPadding: EdgeInsets.all(_isMobile ? 0 : 24),
      child: SizedBox(
        width: _isMobile
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.8,
        height: _isMobile
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                isEditing ? 'Edit Control' : 'Add New Control',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _section(
                        title: 'About',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldWrap(
                              children: [
                                ClaymoreDatePicker(
                                  label: 'Date',
                                  value: widget.control.controlDate,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.controlDate = value;
                                    });
                                  },
                                ),
                                ClaymoreTextField(
                                  label: 'Ex/Op Name',
                                  initialValue: widget.control.operationName,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.operationName = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClaymoreDropdown<CountryLocation>(
                              label: 'Location',
                              value: selectedCountry,
                              items: countryLocations,
                              itemLabel: (country) => country.name,
                              onChanged: (country) {
                                if (country == null) return;

                                setState(() {
                                  selectedCountry = country;
                                  widget.control.controlLocation = country.name;
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            _label('Aircraft'),
                            _fieldWrap(
                              children: [
                                ClaymoreDropdown<int>(
                                  label: 'Number',
                                  value: widget.control.aircraftNumber == 0
                                      ? null
                                      : widget.control.aircraftNumber,
                                  items: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                  itemLabel: (v) => v.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.aircraftNumber = value ?? 1;
                                    });
                                  },
                                ),
                                ClaymoreTextField(
                                  label: 'Platform',
                                  initialValue: widget.control.aircraftType,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.aircraftType = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'FW',
                                  value: widget.control.fwAircraft,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.fwAircraft = true;
                                        widget.control.rwAircraft = false;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'RW',
                                  value: widget.control.rwAircraft,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.rwAircraft = true;
                                        widget.control.fwAircraft = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _label('Ordnance'),
                            _fieldWrap(
                              children: [
                                ClaymoreDropdown<int>(
                                  label: 'Number',
                                  value: widget.control.ordnanceNumber == 0
                                      ? null
                                      : widget.control.ordnanceNumber,
                                  items: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                  itemLabel: (v) => v.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.ordnanceNumber =
                                          value ?? 1;
                                    });
                                  },
                                ),
                                ClaymoreTextField(
                                  label: 'Ordnance',
                                  initialValue: widget.control.ordnanceType,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.ordnanceType = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _label('Environment'),
                            _fieldWrap(
                              children: [
                                ClaymoreCheckbox(
                                  label: 'Sim',
                                  value: widget.control.environment ==
                                      'Simulated',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.environment =
                                            'Simulated';
                                        widget.control.live = false;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Dry',
                                  value: widget.control.environment == 'Dry',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.environment = 'Dry';
                                        widget.control.live = false;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Hot',
                                  value: widget.control.environment == 'Hot',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.environment = 'Hot';
                                        widget.control.live = true;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Ops',
                                  value: widget.control.environment ==
                                      'Operational',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.environment =
                                            'Operational';
                                        widget.control.live = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _section(
                        title: 'Control Elements',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Gameplan'),
                            _fieldWrap(
                              children: [
                                ClaymoreCheckbox(
                                  label: 'T1',
                                  value: widget.control.typeofControl == 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.typeofControl = 1;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'T2',
                                  value: widget.control.typeofControl == 2,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.typeofControl = 2;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'T3',
                                  value: widget.control.typeofControl == 3,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.typeofControl = 3;
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'BoT',
                                  value:
                                      widget.control.methodOfAttack == 'BoT',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.methodOfAttack = 'BoT';
                                      }
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'BoC',
                                  value:
                                      widget.control.methodOfAttack == 'BoC',
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        widget.control.methodOfAttack = 'BoC';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _label('Currency elements'),
                            _fieldWrap(
                              children: [
                                ClaymoreCheckbox(
                                  label: 'LASER',
                                  value: widget.control.laserMark,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.laserMark = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'IR',
                                  value: widget.control.irMark,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.irMark = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'JFO',
                                  value: widget.control.remoteObserver,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.remoteObserver = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'FMV',
                                  value: widget.control.fmv,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.fmv = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Low',
                                  value: widget.control.lowLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.lowLevel = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'NP',
                                  value: widget.control.nonPermissive,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.nonPermissive = value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Day',
                                  value: widget.control.day,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.day = value;
                                      widget.control.night = !value;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Night',
                                  value: widget.control.night,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.day = !value;
                                      widget.control.night = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _section(
                        title: 'Authorisation / Remarks',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldWrap(
                              children: [
                                ClaymoreDropdown<User>(
                                  label: 'Authorised By',
                                  value: appData.users.firstWhere(
                                    (u) =>
                                        u.id == widget.control.supervisedById,
                                    orElse: () => appData.currentUser,
                                  ),
                                  items: appData.users,
                                  itemLabel: (user) =>
                                      '${user.rank} ${user.firstName[0]} ${user.lastName} ${user.qualification}',
                                  onChanged: (user) {
                                    if (user == null) return;

                                    setState(() {
                                      widget.control.supervisedById = user.id;
                                      widget.control.approved = false;
                                    });
                                  },
                                ),
                                ClaymoreCheckbox(
                                  label: 'Successful',
                                  value: widget.control.grading,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.control.grading = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClaymoreTextField(
                              label: 'Remarks',
                              initialValue: widget.control.remarks,
                              maxLines: 5,
                              onChanged: (value) {
                                widget.control.remarks = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _actionBar(appData: appData, isEditing: isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldWrap({
    required List<Widget> children,
  }) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width < 600 ? width - 64 : 220.0;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: children.map((child) {
        return SizedBox(
          width: itemWidth,
          child: child,
        );
      }).toList(),
    );
  }

  Widget _actionBar({
    required AppData appData,
    required bool isEditing,
  }) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        if (isEditing)
          ClaymoreButton(
            onPressed: widget.control.id.isEmpty
                ? null
                : () async {
                    if (!await showDeleteDialog(context)) return;

                    try {
                      await FirestoreService.delete(
                        collectionPath: 'controls',
                        docId: widget.control.id,
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint('Failed to delete control: $e');

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete control: $e'),
                        ),
                      );
                    }
                  },
            text: 'Delete',
          ),
        ClaymoreButton(
          onPressed: () => Navigator.pop(context),
          text: 'Cancel',
        ),
        if (!isEditing)
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

              if (appData.currentUser.qualification != 'JTAC-C' &&
                  widget.control.supervisedById == appData.currentUser.id) {
                widget.control.approved = true;
              }

              try {
                await FirestoreService.create(
                  collectionPath: 'controls',
                  data: widget.control.toFirestore(),
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
        if (isEditing)
          ClaymoreButton(
            onPressed: () async {
              if (appData.currentUser.qualification != 'JTAC-C' &&
                  widget.control.supervisedById == appData.currentUser.id) {
                widget.control.approved = true;
              }

              try {
                await FirestoreService.update(
                  collectionPath: 'controls',
                  docId: widget.control.id,
                  data: widget.control.toFirestore(),
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
            text: 'Update',
          ),
      ],
    );
  }

  List<String> checkFields() {
    final appData = context.read<AppData>();
    List<String> errorMessage = [];

    if (widget.control.controlLocation == '') {
      errorMessage.add('You must enter the control location');
    }
    if (widget.control.environment == '') {
      errorMessage.add('You must enter the control environment');
    }
    if (widget.control.rwAircraft == false &&
        widget.control.fwAircraft == false) {
      errorMessage.add('You must specify FW or RW CAS');
    }
    if (widget.control.typeofControl == 0) {
      errorMessage.add('You must enter a type of control');
    }
    if (widget.control.methodOfAttack != 'BoT' &&
        widget.control.methodOfAttack != 'BoC') {
      errorMessage.add('You must enter a method of attack');
    }
    if (widget.control.day == false && widget.control.night == false) {
      errorMessage.add(
        'You must specify if this control was conducted at day or night',
      );
    }
    if (widget.control.supervisedById == appData.currentUser.id &&
        appData.currentUser.qualification == 'JTAC-C') {
      errorMessage.add(
        'You cannot self-authorise if you are not a minimum JTAC-Q',
      );
    }

    return errorMessage;
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }
}