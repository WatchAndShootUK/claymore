import 'package:cloud_firestore/cloud_firestore.dart';

class TrgEvent {
  String id;
  String trgJtacID;
  String trgType;
  DateTime trgDate;
  String trgLocation;
  String trgSupervisorID;
  List<String> trgDetails;
  bool approved;

  TrgEvent({
    required this.id,
    required this.trgJtacID,
    required this.trgType,
    required this.trgDate,
    required this.trgLocation,
    required this.trgSupervisorID,
    required this.trgDetails,
    required this.approved,
  });

  factory TrgEvent.empty(String currentUserID) {
    return TrgEvent(
      id: '',
      trgJtacID: currentUserID,
      trgDate: DateTime.now(),
      trgType: '',
      trgLocation: '',
      trgDetails: [],
      trgSupervisorID: '',
      approved: false,
    );
  }

  factory TrgEvent.fromFirestore(String id, Map<String, dynamic> data) {
    return TrgEvent(
      id: id,
      trgDate: _dateFromAny(data['trgDate']),
      trgDetails: (data['trgDetails'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      trgJtacID: data['trgJtacID'] ?? '',
      trgLocation: data['trgLocation'] ?? '',
      trgSupervisorID: data['trgSupervisorID'] ?? '',
      trgType: data['trgType'] ?? '',
      approved: data['approved'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'trgDate': trgDate,
      'trgDetails': trgDetails,
      'trgJtacID': trgJtacID,
      'trgLocation': trgLocation,
      'trgSupervisorID': trgSupervisorID,
      'trgType': trgType,
      'approved': approved,
    };
  }

  static DateTime _dateFromAny(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();

    return DateTime.now();
  }
}
