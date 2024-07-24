class FavoriteExpert {
  final int expertId;
  final String firstName;
  final String lastName;
  final String? image;

  FavoriteExpert(
      {required this.image,
      required this.firstName,
      required this.lastName,
      required this.expertId});

  factory FavoriteExpert.fromJson(Map<String, dynamic> json) {
    return FavoriteExpert(
        expertId: json['expert_id'],
        firstName: json['fitst_name'],
        lastName: json['last_name'],
        image: json['image']);
  }
}
