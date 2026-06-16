import 'package:claymore/models/countries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Control {
  String id;
  String controllingJTACId;

  DateTime controlDate;
  String controlLocation;
  String operationName;
  int aircraftNumber;
  String aircraftType;
  int ordnanceNumber;
  String ordnanceType;
  String environment;

  int typeofControl;
  String methodOfAttack;
  bool fwAircraft;
  bool rwAircraft;
  bool laserMark;
  bool irMark;
  bool remoteObserver;
  bool fmv;
  bool live;
  bool nonPermissive;
  bool day;
  bool night;
  bool lowLevel;

  String supervisedById;
  bool grading;
  String remarks;

  bool approved;

  Control({
    required this.id,
    required this.controlDate,
    required this.controlLocation,
    required this.operationName,
    required this.aircraftNumber,
    required this.aircraftType,
    required this.ordnanceNumber,
    required this.ordnanceType,
    required this.grading,
    required this.environment,
    required this.typeofControl,
    required this.methodOfAttack,
    required this.nonPermissive,
    required this.irMark,
    required this.laserMark,
    required this.fmv,
    required this.remoteObserver,
    required this.lowLevel,
    required this.day,
    required this.night,
    required this.supervisedById,
    required this.controllingJTACId,
    required this.fwAircraft,
    required this.rwAircraft,
    required this.live,
    required this.remarks,
    required this.approved,
  });

  factory Control.empty(String currentUserID) {
    return Control(
      id: '',
      controlDate: DateTime.now(),
      operationName: '',
      controlLocation: countryLocations.first.name,
      aircraftNumber: 1,
      aircraftType: '',
      ordnanceNumber: 1,
      ordnanceType: '',
      grading: false,
      environment: '',
      typeofControl: 0,
      methodOfAttack: '',
      nonPermissive: false,
      irMark: false,
      laserMark: false,
      fmv: false,
      remoteObserver: false,
      lowLevel: false,
      day: false,
      night: false,
      supervisedById: '',
      controllingJTACId: currentUserID,
      fwAircraft: false,
      rwAircraft: false,
      live: false,
      remarks: '',
      approved: false,
    );
  }

  Control deepCopy(String currentUserId) {
    final data = Map<String, dynamic>.from(toFirestore());

    final copy = Control.fromFirestore('', data);

    copy.id = '';
    copy.controlDate = DateTime.now();
    copy.controllingJTACId = currentUserId;
    copy.supervisedById = '';
    copy.approved = false;

    return copy;
  }

  factory Control.fromFirestore(String id, Map<String, dynamic> data) {
    return Control(
      id: id,
      operationName: data['operationName'] ?? '',
      controlDate: _dateFromAny(data['controlDate']),
      controlLocation: data['controlLocation'] ?? '',
      aircraftNumber: data['aircraftNumber'] ?? 0,
      aircraftType: data['aircraftType'] ?? '',
      ordnanceNumber: data['ordnanceNumber'] ?? 0,
      ordnanceType: data['ordnanceType'] ?? '',
      grading: data['grading'] ?? false,
      environment: data['environment'] ?? '',
      typeofControl: data['typeofControl'] ?? 0,
      methodOfAttack: data['methodOfAttack'] ?? '',
      nonPermissive: data['nonPermissive'] ?? false,
      irMark: data['irMark'] ?? false,
      laserMark: data['laserMark'] ?? false,
      fmv: data['fmv'] ?? false,
      remoteObserver: data['remoteObserver'] ?? false,
      lowLevel: data['lowLevel'] ?? false,
      day: data['day'] ?? false,
      night: data['night'] ?? false,
      supervisedById: data['supervisedById'] ?? '',
      controllingJTACId: data['controllingJTACId'] ?? '',
      fwAircraft: data['fwAircraft'] ?? false,
      rwAircraft: data['rwAircraft'] ?? false,
      live: data['live'] ?? false,
      remarks: data['remarks'] ?? '',
      approved: data['approved'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'operationName': operationName,
      'controlDate': controlDate,
      'aircraftNumber': aircraftNumber,
      'aircraftType': aircraftType,
      'ordnanceNumber': ordnanceNumber,
      'ordnanceType': ordnanceType,
      'controlLocation': controlLocation,
      'grading': grading,
      'environment': environment,
      'typeofControl': typeofControl,
      'methodOfAttack': methodOfAttack,
      'nonPermissive': nonPermissive,
      'irMark': irMark,
      'laserMark': laserMark,
      'fmv': fmv,
      'remoteObserver': remoteObserver,
      'lowLevel': lowLevel,
      'day': day,
      'night': night,
      'supervisedById': supervisedById,
      'controllingJTACId': controllingJTACId,
      'fwAircraft': fwAircraft,
      'rwAircraft': rwAircraft,
      'live': live,
      'remarks': remarks,
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
