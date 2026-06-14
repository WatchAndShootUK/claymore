import 'package:claymore/models/control.dart';
import 'package:claymore/models/countries.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/ui/button.dart';
import 'package:claymore/ui/checkbox.dart';
import 'package:claymore/ui/date_picker.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:claymore/ui/dropdown.dart';
import 'package:claymore/ui/textfield.dart';
import 'package:flutter/material.dart';
import 'package:claymore/state/app_data.dart';
import 'package:provider/provider.dart';

class AddControlDialog extends StatefulWidget {
  final Control control;

  const AddControlDialog({super.key, required this.control});

  @override
  State<AddControlDialog> createState() => _AddControlDialogState();
}

class _AddControlDialogState extends State<AddControlDialog> {
  CountryLocation? selectedCountry;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.control.id.isNotEmpty;

    final appData = context.read<AppData>();
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.9,
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
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ClaymoreDatePicker(
                                    label: 'Date',
                                    value: widget.control.controlDate,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.controlDate = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ClaymoreTextField(
                                    label: 'Ex/Op Name',
                                    initialValue: widget.control.operationName,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.operationName = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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

                            _label('Aircraft'),
                            SizedBox(
                              child: Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ClaymoreDropdown<int>(
                                      label: 'Number',
                                      value: widget.control.aircraftNumber == 0
                                          ? null
                                          : widget.control.aircraftNumber,
                                      items: const [
                                        1,
                                        2,
                                        3,
                                        4,
                                        5,
                                        6,
                                        7,
                                        8,
                                        9,
                                        10,
                                      ],
                                      itemLabel: (v) => v.toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          widget.control.aircraftNumber =
                                              value ?? 1;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ClaymoreTextField(
                                      label: 'Platform',
                                      initialValue: widget.control.aircraftType,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.control.aircraftType = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ClaymoreCheckbox(
                                      label: 'FW',
                                      value: widget.control.fwAircraft,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            widget.control.fwAircraft = true;
                                            widget.control.rwAircraft = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ClaymoreCheckbox(
                                      label: 'RW',
                                      value: widget.control.rwAircraft,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            widget.control.rwAircraft = true;
                                            widget.control.fwAircraft = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _label('Ordnance'),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ClaymoreDropdown<int>(
                                    label: 'Number',
                                    value: widget.control.ordnanceNumber == 0
                                        ? null
                                        : widget.control.ordnanceNumber,
                                    items: const [
                                      1,
                                      2,
                                      3,
                                      4,
                                      5,
                                      6,
                                      7,
                                      8,
                                      9,
                                      10,
                                    ],
                                    itemLabel: (v) => v.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.ordnanceNumber =
                                            value ?? 1;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ClaymoreTextField(
                                    label: 'Ordnance',
                                    initialValue: widget.control.ordnanceType,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.ordnanceType = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            _label('Environment'),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Sim',
                                    value:
                                        widget.control.environment ==
                                        'Simulated',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.environment =
                                              'Simulated';
                                          widget.control.live = false;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Dry',
                                    value: widget.control.environment == 'Dry',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.environment = 'Dry';
                                          widget.control.live = false;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Hot',
                                    value: widget.control.environment == 'Hot',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.environment = 'Hot';
                                          widget.control.live = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Ops',
                                    value:
                                        widget.control.environment ==
                                        'Operational',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.environment =
                                              'Operational';
                                          widget.control.live = false;
                                        }
                                      });
                                    },
                                  ),
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
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'T1',
                                    value: widget.control.typeofControl == 1,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.typeofControl = 1;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'T2',
                                    value: widget.control.typeofControl == 2,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.typeofControl = 2;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'T3',
                                    value: widget.control.typeofControl == 3,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.typeofControl = 3;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'BoT',
                                    value:
                                        widget.control.methodOfAttack == 'BoT',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.methodOfAttack = 'BoT';
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'BoC',
                                    value:
                                        widget.control.methodOfAttack == 'BoC',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.control.methodOfAttack = 'BoC';
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            _label('Currency elements'),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'LASER',
                                    value: widget.control.laserMark,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.laserMark = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'IR',
                                    value: widget.control.irMark,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.irMark = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'JFO',
                                    value: widget.control.remoteObserver,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.remoteObserver = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'FMV',
                                    value: widget.control.fmv,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.fmv = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Low',
                                    value: widget.control.lowLevel,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.lowLevel = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'NP',
                                    value: widget.control.nonPermissive,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.nonPermissive = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Day',
                                    value: widget.control.day,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.day = value;
                                        widget.control.night = !value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ClaymoreCheckbox(
                                    label: 'Night',
                                    value: widget.control.night,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.day = !value;
                                        widget.control.night = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      _section(
                        title: 'Authorisation / Remarks',
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ClaymoreDropdown<User>(
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
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ClaymoreCheckbox(
                                    label: 'Successful',
                                    value: widget.control.grading,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.control.grading = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEditing)
                    ClaymoreButton(
                      onPressed: widget.control.id.isEmpty
                          ? null
                          : () async {
                              if (!await showDeleteDialog(context)) return;

                              if (appData.currentUser.qualification !=
                                      'JTAC-C' &&
                                  widget.control.supervisedById ==
                                      appData.currentUser.id) {
                                widget.control.approved = true;
                              }
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
                                    content: Text(
                                      'Failed to delete control: $e',
                                    ),
                                  ),
                                );
                              }
                            },
                      text: 'Delete',
                    ),
                  Spacer(),
                  ClaymoreButton(
                    onPressed: () => Navigator.pop(context),

                    text: 'Cancel',
                  ),
                  const SizedBox(width: 12),
                  if (!isEditing)
                    ClaymoreButton(
                      onPressed: () async {
                        if (checkFields().isEmpty) {
                          if (appData.currentUser.qualification != 'JTAC-C' &&
                              widget.control.supervisedById ==
                                  appData.currentUser.id) {
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
                              SnackBar(
                                content: Text('Failed to save control: $e'),
                              ),
                            );
                          }
                        } else {
                          showMessageDialog(
                            context,
                            title: 'Error',
                            message: checkFields().join('\n'),
                          );
                        }
                      },
                      text: 'Add',
                    ),
                  if (isEditing)
                    ClaymoreButton(
                      onPressed: () async {
                        try {
                          if (appData.currentUser.qualification != 'JTAC-C' &&
                              widget.control.supervisedById ==
                                  appData.currentUser.id) {
                            widget.control.approved = true;
                          }
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
                            SnackBar(
                              content: Text('Failed to save control: $e'),
                            ),
                          );
                        }
                      },
                      text: 'Update',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
