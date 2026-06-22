
class User {
   String id;
   String rank;
   String firstName;
   String lastName;
   String qualification;
   String callsign;
   String password;

  User({
    required this.id,
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
      rank: '',
      firstName: '',
      lastName: '',
      qualification: '',
      callsign: '',
      password: 'password',
    );
  }

  String get getUserName =>
      '$rank ${firstName.isNotEmpty ? firstName[0] : ''} $lastName';

  factory User.fromFirestore(String id, Map<String, dynamic> data) {
    return User(
      id: id,
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
      'rank': rank,
      'firstName': firstName,
      'lastName': lastName,
      'qualification': qualification,
      'callsign': callsign,
      'password': password,
    };
  }

}
