class User {
  final String id;
  final String serviceNumber;
  final String rank;
  final String firstName;
  final String lastName;
  final String qualification;
  final String callsign;
  final String password;

  User({
    required this.id,
    required this.serviceNumber,
    required this.rank,
    required this.firstName,
    required this.lastName,
    required this.qualification,
    required this.callsign,
    required this.password,
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
    );
  }

  String get getUserName =>
      '$rank ${firstName.isNotEmpty ? firstName[0] : ''} $lastName';
      
  factory User.fromFirestore(String id, Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      serviceNumber: data['serviceNumber'] ?? '',
      rank: data['rank'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      qualification: data['qualification'] ?? '',
      callsign: data['callsign'] ?? '',
      password: data['password'] ?? '',
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
    };
  }
}
