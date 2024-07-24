import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/container_text.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/components/input_field.dart';
import 'package:consulting_platform/modules/Add%20Expert%20Page/cubit/add_expert_states.dart';

class AddExpertPageCubit extends Cubit<AddExpertPageStates> {
  AddExpertPageCubit() : super(AddExpertLoadingState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<TextEditingController> listPhone = [TextEditingController()];
  List<TextEditingController> listConsult = [TextEditingController()];
  List<TextEditingController> expName = [TextEditingController()];
  List<TextEditingController> expDesc = [TextEditingController()];
  final TextEditingController countyController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController expDetailsController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  String? msg;

  List<List> st = [];

  Future<String> sendData(BuildContext context) async {
    emit(SendingDataLoadingState());
    List<String> data = [
      priceController.text,
      countyController.text,
      cityController.text,
      streetController.text,
    ];
    final AppLocalizations trans = AppLocalizations.of(context)!;
    File? imageFile = pickedFile != null ? File(pickedFile!.path) : null;
    List<String> phone1, expName1, expDesc1, listConsult1;
    List<List> et = [], st = [];
    if (startTimes.isEmpty || endTimes.isEmpty || dataDays.isEmpty) {
      emit(FinishSendingDataLoadingState());
      return msg = trans.one_day_at_least;
    }
    for (int i = 0; i < endTimes.length; i++) {
      if (!endTimes[i].contains(trans.end_time)) {
        et.insert(i, [dataDays[i], endTimes[i]]);
      }
    }
    for (int i = 0; i < startTimes.length; i++) {
      if (!startTimes[i].contains(trans.start_time)) {
        st.insert(i, [dataDays[i], startTimes[i]]);
      }
    }
    st.sort(
      (a, b) {
        int temp1 = a[0];
        int temp2 = b[0];
        return temp1.compareTo(temp2);
      },
    );
    et.sort(
      (a, b) {
        int temp1 = a[0];
        int temp2 = b[0];
        return temp1.compareTo(temp2);
      },
    );
    phone1 = listPhone.map((e) => e.text).toList();
    expName1 = expName.map((e) => e.text).toList();
    expDesc1 = expDesc.map((e) => e.text).toList();
    listConsult1 = listConsult.map((e) => e.text).toList();
    msg = await DioHelper.addExpert(
        phone1, expName1, expDesc1, listConsult1, data, st, et, imageFile);

    switch (msg) {
      case "1":
        msg = trans.succsess;
        break;
      case "2":
        msg = trans.end_must_be_after_start;
        break;
      case "3":
        msg = trans.phone_used;
        break;
      case "4":
        msg = trans.time_should_be_in_order;
        break;
      case "5":
        msg = trans.start_end_minute;
        break;
      case "6":
        msg = trans.family;
        break;
      case "7":
        msg = trans.unknow_error;
        break;
    }
    emit(FinishSendingDataLoadingState());
    return msg.toString();
  }

  void onChanged(
      String? value, int index, List<TextEditingController> dataList) {
    if (dataList.length == index + 1 &&
        value != null &&
        value.trim().isNotEmpty) {
      dataList.insert(index + 1, TextEditingController());
      emit(AddTextFieldState());
    }
  }

  removeEle(int index, List dataList) {
    if (index != 0) {
      dataList.removeAt(index);
      emit(DeleteTextFieldState());
    }
  }

  void changeImage() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    emit(ChangeImageState());
  }

  List<String> days = [''];
  List<int> dataDays = [];
  List<String> startTimes = [''];
  List<String> endTimes = [''];

  Widget buildAddTimes(BuildContext context, int index) {
    final AppLocalizations trans = AppLocalizations.of(context)!;

    bool checkStartTime(int index) =>
        !startTimes[index].contains(trans.start_time);
    bool checkEndTime(int index) => !endTimes[index].contains(trans.end_time);
    bool checkDays(int index) => !days[index].contains(trans.select_a_day);

    days[index].isEmpty ? days[index] = trans.select_a_day : null;
    startTimes[index].isEmpty
        ? startTimes[index] = '${trans.start_time} ${index + 1}'
        : null;
    endTimes[index].isEmpty
        ? endTimes[index] = '${trans.end_time} ${index + 1}'
        : null;

    List<String> daysOfWeek = [
      trans.saturday,
      trans.sunday,
      trans.monday,
      trans.tuesday,
      trans.wednesday,
      trans.thursday,
      trans.friday,
    ];

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ListView.separated(
                      itemCount: 7,
                      shrinkWrap: true,
                      itemBuilder: (context, index1) => InkWell(
                        onTap: () {
                          days[index] = daysOfWeek[index1];
                          if (checkStartTime(index) &&
                              checkEndTime(index) &&
                              startTimes.length - 1 == index) {
                            days.add(trans.select_a_day);
                            startTimes.add('${trans.start_time} ${index + 2}');
                            endTimes.add('${trans.end_time} ${index + 2}');
                          }
                          dataDays.insert(index, index1 + 1);
                          emit(ChangeDateTimeState());
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(daysOfWeek[index1]),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.indigo,
                      ),
                    ),
                  );
                },
              );
            },
            child: ContainerText(
              text: days[index],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? startTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
              );
              if (startTime != null) {
                startTimes[index] = startTime.myFormat;
                if (checkDays(index) &&
                    checkEndTime(index) &&
                    startTimes.length - 1 == index) {
                  days.add(trans.select_a_day);
                  startTimes.add('${trans.start_time} ${index + 2}');
                  endTimes.add('${trans.end_time} ${index + 2}');
                }
                emit(ChangeTimeOfDayState());
              }
              return;
            },
            child: ContainerText(
              text: startTimes[index],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? endTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
              );
              if (endTime != null) {
                endTimes[index] = endTime.myFormat;
                if (checkDays(index) &&
                    checkStartTime(index) &&
                    startTimes.length - 1 == index) {
                  days.add(trans.select_a_day);
                  startTimes.add('${trans.start_time} ${index + 2}');
                  endTimes.add('${trans.end_time} ${index + 2}');
                }
                emit(ChangeTimeOfDayState());
              }
              return;
            },
            child: ContainerText(
              text: endTimes[index],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              if (index != 0) {
                startTimes.removeAt(index);
                endTimes.removeAt(index);
                days.removeAt(index);
                emit(DeleteTextFieldState());
              }
            },
            icon: const Icon(Icons.cancel))
      ],
    );
  }

  Widget buildListView(
      List<TextEditingController> dataList, String name, TextInputType type) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  isValid: index == 0 ? true : false,
                  labelText: '$name ${index + 1}',
                  keyboard: type,
                  controller: dataList[index],
                  onChanged: (String? value) {
                    onChanged(value, index, dataList);
                    return null;
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeEle(index, dataList);
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildExpDetails(List<TextEditingController> expName,
      List<TextEditingController> expDesc) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expName.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  isValid: index == 0 ? true : false,
                  labelText:
                      "${AppLocalizations.of(context)!.experince} ${index + 1}",
                  controller: expName[index],
                  onChanged: (String? value) {
                    if (expDesc[index].text.trim().isNotEmpty) {
                      onChanged(value, index, expName);
                      onChanged(value, index, expDesc);
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeEle(index, expName);
                    removeEle(index, expDesc);
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
          const SizedBox(height: 10),
          InputField(
            isValid: index == 0 ? true : false,
            labelText: AppLocalizations.of(context)!.experience_details,
            controller: expDesc[index],
            onChanged: (String? value) {
              if (expName[index].text.trim().isNotEmpty) {
                onChanged(value, index, expDesc);
                onChanged(value, index, expName);
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

extension FormatX on TimeOfDay {
  String get myFormat =>
      DateFormat('HH:mm').format(DateTime(0, 0, 0, hour, minute, 0, 0, 0));
}
