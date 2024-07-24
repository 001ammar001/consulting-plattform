import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/show_expert_info.dart';
import 'specialized_details_states.dart';

class DetailsScreenCubit extends Cubit<DetailsStates> {
  DetailsScreenCubit() : super(DetailsInitState());

  bool rated = false;
  double rating = 3.0;
  bool isFavorite = false;
  ShowExpertInfo? expert;
  int numberOfHours = 1;
  String hoursSelected = '1';
  late List<dynamic>? times = [];
  List endTime = [];
  int indexOfDay = 1;
  late String daySelected;
  late List<String> daysMenuItems;
  String? chosedConsluting;
  String? chosedConslutingId;
  List<String> conslutings = [];
  List<String> conslutingsIds = [];
  late List<DropdownMenuItem<String>> conslutingsDropDownItems;
  late List<DropdownMenuItem<String>> daysDropDownItems;

  void setDate(context) {
    daysMenuItems = [
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
    ];
    daySelected = AppLocalizations.of(context)!.saturday;
    daysDropDownItems = daysMenuItems.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
    formatEndTime();
  }

  void setConslutings() {
    conslutings = [];
    conslutingsIds = [];
    times = expert!.freeTimes['1'];
    expert!.idsOfConsultings.forEach((key, value) {
      conslutings.add(key);
      conslutingsIds.add(value.toString());
    });
    conslutingsDropDownItems = conslutings
        .map((String e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
        .toList();
  }

  static const hoursMenuItems = <String>['1', '2', '3'];

  final List<DropdownMenuItem<String>> hoursDropDownItems = hoursMenuItems
      .map((String val) => DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          ))
      .toList();

  Future<void> loadEexpertData(int id, context, {bool update = false}) async {
    emit(LoadingExepertDataState());
    if (expert == null) {
      expert = await DioHelper.expertDetails(id);
      if (expert != null) {
        isFavorite = expert!.isFavorite;
        changeDay(daySelected);
        emit(FinishLoadingExepertDataState());
      } else {
        loadEexpertData(id, context);
      }
    } else if (expert!.expertId != id || update) {
      expert = await DioHelper.expertDetails(id);
      if (expert != null) {
        isFavorite = expert!.isFavorite;
        update ? null : resetTime(context);
        changeDay(daySelected);
        emit(FinishLoadingExepertDataState());
      } else {
        loadEexpertData(id, context);
      }
    } else {
      emit(FinishLoadingExepertDataState());
    }
  }

  Future<String> bookAppointment(int index, context) async {
    emit(BookingAppointmentLoadingState());
    String res = await DioHelper.bookAppointment('${expert!.expertId}',
        '$indexOfDay', times![index], '$numberOfHours', '$chosedConslutingId');
    switch (res) {
      case '1':
        return AppLocalizations.of(context)!.appointment_booked_successfully;
      case '2':
        return AppLocalizations.of(context)!.book_with_self;
      case '3':
        return AppLocalizations.of(context)!.charge_card;
    }
    return AppLocalizations.of(context)!.unknow_error;
  }

  void resetTime(context) {
    indexOfDay = 1;
    daySelected = AppLocalizations.of(context)!.saturday;
    numberOfHours = 1;
    hoursSelected = '1';
    times = expert!.freeTimes['1'];
    conslutings.clear();
    conslutingsIds.clear();
    chosedConsluting = null;
    chosedConslutingId = null;
    endTime = [];
  }

  void changeDay(String value) {
    daySelected = value;
    indexOfDay = daysMenuItems.indexWhere(
          (element) => daySelected == element,
        ) +
        1;
    times = expert!.freeTimes['$indexOfDay'];
    changeHour(hoursSelected);
    emit(ChangeDayState());
  }

  void changeHour(String value) {
    hoursSelected = value;
    numberOfHours =
        hoursMenuItems.indexWhere((element) => hoursSelected == element) + 1;
    times = expert!.freeTimes['$indexOfDay'];
    List<dynamic>? temp = [];
    if (times != null) {
      for (String elm in times!) {
        int startHour = int.parse(elm.substring(0, 2));
        int startMinute = int.parse(elm.substring(3, 5));
        bool time1 = false;
        bool time2 = false;
        for (String elm2 in times!) {
          int endHour = int.parse(elm2.substring(0, 2));
          int endMinute = int.parse(elm2.substring(3, 5));
          if (numberOfHours == 3) {
            if (startHour + numberOfHours - 1 == endHour &&
                    startMinute == endMinute ||
                startHour + numberOfHours - 2 == endHour &&
                    startMinute == endMinute) {
              !time1 ? time1 = true : time2 = true;
              if (time1 && time2) {
                temp.add(elm);
                break;
              }
            }
          } else {
            if (startHour + numberOfHours - 1 == endHour &&
                startMinute == endMinute) {
              temp.add(elm);
              break;
            }
          }
        }
      }
    }
    temp.isEmpty ? times = null : times = temp;
    formatEndTime();
    emit(ChangeHourState());
  }

  void changeConsluting(String value) {
    chosedConsluting = value;
    int index = conslutings.indexOf(chosedConsluting!);
    chosedConslutingId = conslutingsIds[index];
    emit(ChangeConslutingState());
  }

  void formatEndTime() {
    endTime = [];
    if (times != null) {
      for (String elm in times!) {
        endTime.add(
            (int.parse(elm.substring(0, 2)) + numberOfHours).toString() +
                elm.substring(2, 5));
      }
    }
  }

  void changeRating(double value) {
    rating = value;
    emit(ChangeRatingState());
  }

  Future<void> sendRating(context, consId) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      AppLocalizations.of(context)!.please_wait,
    )));
    emit(RatingDataLoadingState());
    await DioHelper.rateExpert(consId, rating).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.please_wait)));
      emit(RatingDataFinishState());
      ScaffoldMessenger.of(context).clearSnackBars();
      switch (value) {
        case '1':
          value = AppLocalizations.of(context)!.cant_rate;
          break;
        case '2':
          value = AppLocalizations.of(context)!.add_successful;
          break;
        case '3':
          value = AppLocalizations.of(context)!.unknow_error;
          break;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value)));
    });
    await loadEexpertData(expert!.expertId, context, update: true);
  }

  void changeFavorite() {
    isFavorite = !isFavorite;
    expert!.isFavorite = isFavorite;
    emit(ChangeFavoriteState());
  }

  Future<bool> addToFavorite() async {
    return await DioHelper.addToFavorite('${expert!.expertId}');
  }

  Future<bool> removeFromFavorite() async {
    return await DioHelper.removeFromFavorite('${expert!.expertId}');
  }

  Future<int> creatChannel(BuildContext context) async {
    return await DioHelper.createChannel('${expert!.expertId}');
  }
}
