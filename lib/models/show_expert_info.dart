import 'expert_profile.dart';

class ShowExpertInfo {
  final int expertId;
  final String image;
  final String country;
  final String city;
  final String street;
  final int cost;
  bool isFavorite;
  final Map consultingsRates;
  final Map idsOfConsultings;
  final String firstName;
  final String lastName;
  final String email;
  final double totalRate;
  final Map<String, dynamic> freeTimes;
  final List<ExpertConsultings> expertConsultings;
  final List<PhoneNumbers> phoneNumbers;
  final List<Experiences> experiences;
  ShowExpertInfo({
    required this.isFavorite,
    required this.consultingsRates,
    required this.idsOfConsultings,
    required this.email,
    required this.totalRate,
    required this.expertId,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.city,
    required this.street,
    required this.cost,
    required this.freeTimes,
    required this.phoneNumbers,
    required this.experiences,
    required this.expertConsultings,
  });

  factory ShowExpertInfo.fromJson(Map<String, dynamic> json) {
    List<PhoneNumbers> listPhone = [];
    List<ExpertConsultings> listExpCons = [];
    List<Experiences> listExp = [];

    List dataPhone = json['phone_numbers'];
    List dataExpCons = json['expert_consultings'];
    List dataExp = json['experiences'];

    for (int i = 0; i < dataPhone.length; i++) {
      listPhone.add(PhoneNumbers.fromJson(dataPhone[i]));
    }
    for (int i = 0; i < dataExpCons.length; i++) {
      listExpCons.add(ExpertConsultings.fromJson(dataExpCons[i]));
    }
    for (int i = 0; i < dataExp.length; i++) {
      listExp.add(Experiences.fromJson(dataExp[i]));
    }

    var free = json['free_times'];
    Map<String, dynamic> temp = {};
    free is List && free.isEmpty ? free = temp : null;

    return ShowExpertInfo(
      expertId: json['expert_id'],
      image: json['image'],
      country: json['country'],
      city: json['city'],
      street: json['street'],
      cost: json['cost'],
      isFavorite: json['from_user_favorites'],
      consultingsRates: json['rates_of_consultings'],
      idsOfConsultings: json['ids_of_consultings'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      totalRate: json['total_rate'].toDouble(),
      freeTimes: free,
      phoneNumbers: listPhone,
      experiences: listExp,
      expertConsultings: listExpCons,
    );
  }
}
