import 'package:claymore/models/control.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> uploaderDialog(BuildContext context, AppData appData) async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Import Logbook',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 700,
          height: 400,
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Paste logbook rows here...',
              hintStyle: TextStyle(color: Colors.white38),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = _extractLogbookRows(controller.text);

              if (result.errors.isNotEmpty) {
                await showMessageDialog(
                  context,
                  title: 'Import Error',
                  message: result.errors.join('\n'),
                );
                return;
              }

              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey.shade900,
                  title: const Text(
                    'Confirm Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    'You are uploading ${result.validRows.length} controls.\n\n'
                    '${result.skippedRows} controls are over 12 months old and will be ignored.\n\n'
                    'Continue?',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              );

              if (confirmed != true) return;

              for (final row in result.validRows) {
                await _convertLogBookLine(appData, row);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Import'),
          ),
        ],
      );
    },
  );

}

class LogbookImportResult {
  final List<String> validRows;
  final int skippedRows;
  final List<String> errors;

  const LogbookImportResult({
    required this.validRows,
    required this.skippedRows,
    required this.errors,
  });
}

LogbookImportResult _extractLogbookRows(String rawInput) {
  const columnsPerRow = 46;

  final lines = rawInput
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .toList();

  final validRows = <String>[];
  final errors = <String>[];
  int skippedRows = 0;

  if (lines.length.isOdd) {
    errors.add(
      'Expected alternating control/signature rows but found ${lines.length} lines.',
    );
  }

  final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));

  for (var i = 0; i < lines.length; i += 2) {
    final rowNumber = (i ~/ 2) + 1;
    final row = lines[i];

    final cols = row.split('\t');

    if (cols.length != columnsPerRow) {
      errors.add(
        'Control $rowNumber has ${cols.length} columns. Expected $columnsPerRow.',
      );
      continue;
    }

    try {
      final controlDate = DateFormat('dd/MM/yyyy').parse(cols[0]);

      if (controlDate.isBefore(oneYearAgo)) {
        skippedRows++;
        continue;
      }

      validRows.add(row);
    } catch (_) {
      errors.add('Control $rowNumber has an invalid date: "${cols[0]}".');
    }
  }

  return LogbookImportResult(
    validRows: validRows,
    skippedRows: skippedRows,
    errors: errors,
  );
}

Future<void> _convertLogBookLine(AppData appData, String input) async {
  final newControl = Control.empty(appData.currentUser.id);
  final cols = input.split('\t');

  for (var i = 0; i < cols.length; i++) {
    final value = cols[i].trim();

    switch (i) {
      case 0:
        newControl.controlDate = DateFormat('dd/MM/yyyy').parse(value);
        break;
      case 1:
        newControl.operationName = value;
        break;
      case 2:
        final aircraftParts = value.split(' x ');
        newControl.aircraftNumber = int.tryParse(aircraftParts[0]) ?? 1;
        newControl.aircraftType = aircraftParts.length > 1
            ? aircraftParts[1]
            : '';
        break;
      case 3:
        newControl.ordnanceNumber = int.tryParse(value) ?? 1;
        break;
      case 4:
        newControl.ordnanceType = value;
        break;
      case 5:
        newControl.grading = value != '0';
        break;
      case 9:
        if (value == '✔') newControl.environment = 'Simulated';
        break;
      case 10:
        if (value == '✔') newControl.typeofControl = 1;
        break;
      case 11:
        if (value == '✔') newControl.typeofControl = 2;
        break;
      case 12:
        if (value == '✔') newControl.typeofControl = 3;
        break;
      case 13:
        if (value == '✔') newControl.methodOfAttack = 'BoT';
        break;
      case 14:
        if (value == '✔') newControl.methodOfAttack = 'BoC';
        break;
      case 15:
        if (value == '✔') newControl.fwAircraft = true;
        break;
      case 16:
        if (value == '✔') newControl.rwAircraft = true;
        break;
      case 17:
        if (value == '✔') newControl.laserMark = true;
        break;
      case 18:
        if (value == '✔') newControl.irMark = true;
        break;
      case 24:
        if (value == '✔') newControl.remoteObserver = true;
        break;
      case 25:
        if (value == '✔') newControl.fmv = true;
        break;
      case 26:
        if (value == '✔') {
          newControl.environment = 'Hot';
          newControl.live = true;
        }
        ;
        break;
      case 27:
        if (value == '✔') newControl.nonPermissive = true;
        break;
      case 31:
        if (value == '✔') newControl.day = true;
        break;
      case 32:
        if (value == '✔') newControl.lowLevel = true;
        break;
      case 33:
        if (value == '✔') newControl.night = true;
        break;
      case 45:
        newControl.supervisedById = value.contains(appData.currentUser.lastName)
            ? appData.currentUser.id
            : '6Tacr98KzVuTGTzuf5y6';
        break;
    }
  }

  if (newControl.environment.isEmpty) {
    newControl.environment = 'Dry';
  }

  newControl.approved = true;

  await FirestoreService.create(
    collectionPath: 'controls',
    data: newControl.toFirestore(),
  );
}
