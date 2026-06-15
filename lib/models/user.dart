import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String serviceNumber;
  final String rank;
  final String firstName;
  final String lastName;
  final String qualification;
  final String callsign;
  final String password;
  Map<String, String> pccs;

  User({
    required this.id,
    required this.serviceNumber,
    required this.rank,
    required this.firstName,
    required this.lastName,
    required this.qualification,
    required this.callsign,
    required this.password,
    required this.pccs,
  });

  factory User.empty() {
    return User(
      id: '',
      serviceNumber: '',
      rank: '',
      firstName: '',
      lastName: '',
      qualification: '',
      callsign: '',
      password: '',
      pccs: <String, String>{},
    );
  }

  String get getUserName =>
      '$rank ${firstName.isNotEmpty ? firstName[0] : ''} $lastName';

  factory User.fromFirestore(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      serviceNumber: data['serviceNumber'] ?? '',
      rank: data['rank'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      qualification: data['qualification'] ?? '',
      callsign: data['callsign'] ?? '',
      password: data['password'] ?? '',
      pccs: _pccsFromFirestore(data['pccs']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'serviceNumber': serviceNumber,
      'rank': rank,
      'firstName': firstName,
      'lastName': lastName,
      'qualification': qualification,
      'callsign': callsign,
      'password': password,
      'pccs': pccs,
    };
  }

  static Map<String, String> _pccsFromFirestore(dynamic value) {
    if (value is! Map) return <String, String>{};

    return value.map((key, val) => MapEntry(key.toString(), val.toString()));
  }
}
