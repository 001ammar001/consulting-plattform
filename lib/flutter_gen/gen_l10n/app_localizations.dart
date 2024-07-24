import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @construction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get construction;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @bright.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get bright;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account ?'**
  String get no_account;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get have_account;

  /// No description provided for @signIn_here.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn_here;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get create_account;

  /// No description provided for @expert_account.
  ///
  /// In en, this message translates to:
  /// **'Expert Account'**
  String get expert_account;

  /// No description provided for @book_appointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get book_appointment;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @search_helper.
  ///
  /// In en, this message translates to:
  /// **'counselor Name'**
  String get search_helper;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Numbers'**
  String get phone_number;

  /// No description provided for @hello_again.
  ///
  /// In en, this message translates to:
  /// **'Hello Again! \nWelcome \nBack'**
  String get hello_again;

  /// No description provided for @hello_sing_up.
  ///
  /// In en, this message translates to:
  /// **'Hello! \nSignup to \nget started'**
  String get hello_sing_up;

  /// No description provided for @other_details.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get other_details;

  /// No description provided for @list_of_schedule.
  ///
  /// In en, this message translates to:
  /// **'List Of Schedule'**
  String get list_of_schedule;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @not_empty.
  ///
  /// In en, this message translates to:
  /// **'can\'t be empty'**
  String get not_empty;

  /// No description provided for @emailNotContainAt.
  ///
  /// In en, this message translates to:
  /// **'email must have @'**
  String get emailNotContainAt;

  /// No description provided for @emailNotContainDot.
  ///
  /// In en, this message translates to:
  /// **'email must have .'**
  String get emailNotContainDot;

  /// No description provided for @emailContainAtDot.
  ///
  /// In en, this message translates to:
  /// **'The email must be a valid email address'**
  String get emailContainAtDot;

  /// No description provided for @emailStartDot.
  ///
  /// In en, this message translates to:
  /// **'The email must be a valid email address'**
  String get emailStartDot;

  /// No description provided for @passwordMore4.
  ///
  /// In en, this message translates to:
  /// **'password must be more than 6 characters'**
  String get passwordMore4;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalid;

  /// No description provided for @not_same.
  ///
  /// In en, this message translates to:
  /// **'not the same'**
  String get not_same;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @experience_details.
  ///
  /// In en, this message translates to:
  /// **'Experience Details'**
  String get experience_details;

  /// No description provided for @enter_dates.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Dates'**
  String get enter_dates;

  /// No description provided for @date_time.
  ///
  /// In en, this message translates to:
  /// **'Date Time'**
  String get date_time;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get start_time;

  /// No description provided for @end_time.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get end_time;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Session Price'**
  String get price;

  /// No description provided for @typeOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Type Of Experience'**
  String get typeOfExperience;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @expert_conslutings.
  ///
  /// In en, this message translates to:
  /// **'Expert Conslutings'**
  String get expert_conslutings;

  /// No description provided for @no_expert_found.
  ///
  /// In en, this message translates to:
  /// **'No Expert Found for this Category'**
  String get no_expert_found;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hour;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @book_the_date.
  ///
  /// In en, this message translates to:
  /// **'Do you want to book the date'**
  String get book_the_date;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirm;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @no_free_time.
  ///
  /// In en, this message translates to:
  /// **'No free time left match your search try changeing the hours and/or day '**
  String get no_free_time;

  /// No description provided for @succsess.
  ///
  /// In en, this message translates to:
  /// **'Succsess'**
  String get succsess;

  /// No description provided for @end_must_be_after_start.
  ///
  /// In en, this message translates to:
  /// **'end time must be after start time'**
  String get end_must_be_after_start;

  /// No description provided for @phone_used.
  ///
  /// In en, this message translates to:
  /// **'The phone number has already been taken'**
  String get phone_used;

  /// No description provided for @time_should_be_in_order.
  ///
  /// In en, this message translates to:
  /// **'Times in the same day should be inserted in order and must’nt be conflicted'**
  String get time_should_be_in_order;

  /// No description provided for @start_end_minute.
  ///
  /// In en, this message translates to:
  /// **'Start time and end time should in the same periode start at the same minute'**
  String get start_end_minute;

  /// No description provided for @unknow_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknow_error;

  /// No description provided for @consluting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get consluting;

  /// No description provided for @image_cant_be_null.
  ///
  /// In en, this message translates to:
  /// **'Image can\'t be empty'**
  String get image_cant_be_null;

  /// No description provided for @select_a_day.
  ///
  /// In en, this message translates to:
  /// **'Chose day'**
  String get select_a_day;

  /// No description provided for @experince.
  ///
  /// In en, this message translates to:
  /// **'Experince'**
  String get experince;

  /// No description provided for @one_day_at_least.
  ///
  /// In en, this message translates to:
  /// **'you should enter one day at least'**
  String get one_day_at_least;

  /// No description provided for @chose_consulting.
  ///
  /// In en, this message translates to:
  /// **'Chose consluting type'**
  String get chose_consulting;

  /// No description provided for @chose.
  ///
  /// In en, this message translates to:
  /// **'Chose'**
  String get chose;

  /// No description provided for @chose_consulting_first.
  ///
  /// In en, this message translates to:
  /// **'You need to chose the consluting type before booking an appointment'**
  String get chose_consulting_first;

  /// No description provided for @no_fav_exp.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have favorites experts to show'**
  String get no_fav_exp;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'please wait'**
  String get please_wait;

  /// No description provided for @add_successful.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get add_successful;

  /// No description provided for @remove_successful.
  ///
  /// In en, this message translates to:
  /// **'Removed successfully'**
  String get remove_successful;

  /// No description provided for @appointment_booked_successfully.
  ///
  /// In en, this message translates to:
  /// **'Appointment booked successfully'**
  String get appointment_booked_successfully;

  /// No description provided for @book_with_self.
  ///
  /// In en, this message translates to:
  /// **'You cannot book an appointment with yourself'**
  String get book_with_self;

  /// No description provided for @charge_card.
  ///
  /// In en, this message translates to:
  /// **'You have to charge your card first'**
  String get charge_card;

  /// No description provided for @booked_appointments.
  ///
  /// In en, this message translates to:
  /// **'\'Booked Appointments'**
  String get booked_appointments;

  /// No description provided for @cant_rate.
  ///
  /// In en, this message translates to:
  /// **'you cant rate this consluting before booking an appointment for it'**
  String get cant_rate;

  /// No description provided for @one_number_at_least.
  ///
  /// In en, this message translates to:
  /// **'you should have one number at least'**
  String get one_number_at_least;

  /// No description provided for @add_new_phone.
  ///
  /// In en, this message translates to:
  /// **'add new numbers'**
  String get add_new_phone;

  /// No description provided for @password_incorect.
  ///
  /// In en, this message translates to:
  /// **'Password incorect'**
  String get password_incorect;

  /// No description provided for @free_time.
  ///
  /// In en, this message translates to:
  /// **'Free Time'**
  String get free_time;

  /// No description provided for @add_new_consluting.
  ///
  /// In en, this message translates to:
  /// **'Add new consluting'**
  String get add_new_consluting;

  /// No description provided for @one_cons_at_least.
  ///
  /// In en, this message translates to:
  /// **'you should have one consluting at least'**
  String get one_cons_at_least;

  /// No description provided for @add_new_time.
  ///
  /// In en, this message translates to:
  /// **'Add new time'**
  String get add_new_time;

  /// No description provided for @times_used.
  ///
  /// In en, this message translates to:
  /// **'A part or more from the time you enterd already used by you'**
  String get times_used;

  /// No description provided for @no_chats_have_been_found.
  ///
  /// In en, this message translates to:
  /// **'no chats have been found'**
  String get no_chats_have_been_found;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
