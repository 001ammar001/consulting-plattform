class ExpertList {
  final int expertId;
  final String image;
  final String firstName;
  final String lastName;
  final double rate;

  ExpertList({
    required this.expertId,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.rate,
  });

  factory ExpertList.fromJson(Map<String, dynamic> json) {
    return ExpertList(
      expertId: json['expert_id'],
      image: json['image'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      rate: json['rate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expert_id'] = expertId;
    data['image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['rate'] = rate;
    return data;
  }
}
