import 'package:flutter/material.dart';
import 'package:consulting_platform/models/profile_drawer.dart';
import 'package:consulting_platform/modules/Experts%20List/Categories%20Screen/categories_screen.dart';
import 'package:consulting_platform/modules/Main%20Screen/main_screen.dart';
import 'package:consulting_platform/modules/favorites Screen/favorites_screen.dart';
import 'package:consulting_platform/modules/SignUp%20Page/sign_up_page.dart';
import 'package:consulting_platform/modules/Add%20Expert%20Page/add_expert_page.dart';
import 'package:consulting_platform/modules/chat%20Page/chat_page.dart';
import 'package:consulting_platform/modules/profile%20page/Info%20Edit/info_edit.dart';
import 'package:consulting_platform/modules/profile%20page/Profile%20Details%20Page/profile_details.dart';
import 'package:consulting_platform/modules/profile%20page/Profile%20Phones/profile_phones.dart';
import 'package:consulting_platform/modules/profile%20page/booked%20appointments%20page/booked_appointments_page.dart';
import 'package:consulting_platform/modules/search%20expert%20page/search_expert_page.dart';
import 'package:consulting_platform/modules/signIn%20Page/sign_in_page.dart';
import 'package:consulting_platform/modules/specialized_screens/Other%20Details/other_details_screen.dart';
import 'package:consulting_platform/modules/specialized_screens/Phone%20Numbers%20Screen/phone_number_screen.dart';
import 'package:consulting_platform/modules/specialized_screens/Scheduale/scheduale_screen.dart';
import 'package:consulting_platform/modules/specialized_screens/expert_details_screen.dart';

const String singIn = '/singIn';
const String singUp = '/singUp';
const String mainPage = '/mainScreen';
const String expertPage = '/expertPage';
const String spiralizerPage = '/spiralizerScreen';
const String favoritesPage = '/favoritesPage';
const String categoryPage = '/categoriesScreen';
const String chatPage = '/chatPage';
const String detailsPage = '/detailsPage';
const String phoneNumberPage = '/phonePage';
const String schedulePage = '/schedulePage';
const String bookedAppointmentsPage = '/bookedAppointmentsPage';
const String searchExpertPage = '/searchExpertPage';
const String profilePhones = '/profilePhones';
const String infoEdit = '/infoEdit';
const String profileDetails = '/profileDetails';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case singIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case singUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case mainPage:
        Arg arg = settings.arguments as Arg;
        return MaterialPageRoute(
            builder: (_) => MainScreen(
                  isExpert: arg.isExpert,
                  infoProf: arg.data,
                ));
      case expertPage:
        return MaterialPageRoute(builder: (_) => const AddExpertPage());
      case categoryPage:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case favoritesPage:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case detailsPage:
        return MaterialPageRoute(builder: (_) => const OtherDetails());
      case phoneNumberPage:
        return MaterialPageRoute(builder: (_) => const PhoneNumberScreen());
      case profilePhones:
        return MaterialPageRoute(builder: (_) => const ProfilePhone());
      case infoEdit:
        return MaterialPageRoute(builder: (_) => const InofEdit());
      case profileDetails:
        return MaterialPageRoute(builder: (_) => const ProfileDetails());
      case bookedAppointmentsPage:
        return MaterialPageRoute(
            builder: (_) => const BookedAppointmentsPage());
      case searchExpertPage:
        return MaterialPageRoute(builder: (_) => const SearchExpertPage());
      case schedulePage:
        return MaterialPageRoute(
          builder: (_) => const ScheduleScreen(),
        );
      case chatPage:
        int id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ChatPage(
            chatId: id,
          ),
        );
      case spiralizerPage:
        return MaterialPageRoute(
          builder: (_) => ExpertDetailsScreen(
            id: settings.arguments as int,
          ),
        );
    }
    return MaterialPageRoute(
      builder: (_) => const SignInPage(),
    );
  }
}

class Arg {
  final bool isExpert;
  final DataProfile data;

  Arg(this.isExpert, this.data);
}
