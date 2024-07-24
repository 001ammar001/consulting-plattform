class ExpertProfile {
  final int expertId;
  final String image;
  final String country;
  final String city;
  final String street;
  final int cost;
  final String firstName;
  final String lastName;
  final String email;
  final Map freeTimes;
  final List<BookedAppointments> bookedAppointments;
  final List<PhoneNumbers> phoneNumbers;
  final List<Experiences> experiences;
  final List<ExpertConsultings> expertConsultings;
  final double totalRate;
  final Map consultingsRates;
  final Map idsOfConsultings;
  int balance;

  ExpertProfile({
    required this.expertId,
    required this.image,
    required this.country,
    required this.city,
    required this.street,
    required this.cost,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.freeTimes,
    required this.bookedAppointments,
    required this.phoneNumbers,
    required this.experiences,
    required this.expertConsultings,
    required this.totalRate,
    required this.consultingsRates,
    required this.idsOfConsultings,
    required this.balance,
  });

  factory ExpertProfile.fromJson(Map<String, dynamic> json) {
    List<BookedAppointments> listBooked = [];
    List<PhoneNumbers> listPhone = [];
    List<Experiences> listExp = [];
    List<ExpertConsultings> listExpCons = [];

    List dataBooked = json['booked_appointments']['Booked_appointments'];
    List dataPhone = json['phone_numbers'];
    List dataExp = json['experiences'];
    List dataExpCons = json['expert_consultings'];

    for (int i = 0; i < dataBooked.length; i++) {
      listBooked.add(BookedAppointments.fromJson(dataBooked[i]));
    }
    for (int i = 0; i < dataPhone.length; i++) {
      listPhone.add(PhoneNumbers.fromJson(dataPhone[i]));
    }
    for (int i = 0; i < dataExp.length; i++) {
      listExp.add(Experiences.fromJson(dataExp[i]));
    }
    for (int i = 0; i < dataExpCons.length; i++) {
      listExpCons.add(ExpertConsultings.fromJson(dataExpCons[i]));
    }

    var free = json['free_times'];
    Map<String, dynamic> temp = {};
    free is List && free.isEmpty ? free = temp : null;

    return ExpertProfile(
      expertId: json['expert_id'],
      image: json['image'],
      country: json['country'],
      city: json['city'],
      street: json['street'],
      cost: json['cost'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      freeTimes: free,
      bookedAppointments: listBooked,
      phoneNumbers: listPhone,
      experiences: listExp,
      expertConsultings: listExpCons,
      totalRate: json["total_rate"].toDouble(),
      consultingsRates: json['rates_of_consultings'],
      idsOfConsultings: json['ids_of_consultings'], balance: json['balance']['balance'],
    );
  }
}

class PhoneNumbers {
  final int id;
  final int number;

  PhoneNumbers({required this.id, required this.number});

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) {
    return PhoneNumbers(
      id: json['phone_number_id'],
      number: json['phone_number'],
    );
  }
}

class Experiences {
  final int id;
  final String name;
  final String description;

  Experiences(
      {required this.id, required this.name, required this.description});

  factory Experiences.fromJson(Map<String, dynamic> json) {
    return Experiences(
      id: json['experience_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class ExpertConsultings {
  final int id;
  final String name;

  ExpertConsultings({required this.id, required this.name});

  factory ExpertConsultings.fromJson(Map<String, dynamic> json) {
    return ExpertConsultings(
        id: json['consulting_id'], name: json['consulting_name']);
  }
}

class BookedAppointments {
  final String firstName;
  final String lastName;
  final int day;
  final String startTime;
  final int numberOfHours;

  BookedAppointments(
      {required this.firstName,
      required this.lastName,
      required this.day,
      required this.startTime,
      required this.numberOfHours});

  factory BookedAppointments.fromJson(Map<String, dynamic> json) {
    return BookedAppointments(
        firstName: json['first_name'],
        lastName: json['last_name'],
        day: json['day'],
        startTime: json['start_time'],
        numberOfHours: json['number_of_hours']);
  }
}

// class ExpertConsultings {
//   final String consultingName;
//   final int rate;
//
//   ExpertConsultings({required this.consultingName, required this.rate});
//
//   factory ExpertConsultings.fromJson(Map<String, dynamic> json) {
//     return ExpertConsultings(
//         consultingName: json['consulting_name'], rate: json['rate']);
//   }
// }