class DataProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int wallet;

  DataProfile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.wallet});

  factory DataProfile.fromJson(Map<String, dynamic> json) {
    return DataProfile(
        id: json['user_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        wallet: json['wallet']['balance']);
  }
}
