import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/container_text.dart';
import 'package:consulting_platform/components/input_field.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/models/expert_profile.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageStates> {
  ProfilePageCubit() : super(ProfileLoadingState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> infoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editPhoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> consKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editConsKey = GlobalKey<FormState>();

  final TextEditingController countyController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<TextEditingController> listPhone = [];
  List<TextEditingController> listConsult = [];
  List<TextEditingController> expName = [];
  List<TextEditingController> expDesc = [];
  List<TextEditingController> currentPhones = [];
  List<TextEditingController> currentCons = [];
  List<String> conslutings = [];
  List<String> conslutingsIds = [];
  TextEditingController password = TextEditingController();
  bool phoneChange = false;
  bool isAddPhone = false;
  bool seeBooked = false;
  bool consChange = false;
  bool isAddCons = false;
  bool timeChange = false;
  bool addTime = false;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  List<List> st = [];
  late List<dynamic>? times = [];
  int indexOfDay = 1;
  late String daySelected;
  late List<String> daysMenuItems;
  List<dynamic> appbointmentEndTime = [];

  List<DropdownMenuItem<String>> daysDropDownItems = [];

  Future<String> addTimes(BuildContext context) async {
    emit(AddTimeState());
    final AppLocalizations trans = AppLocalizations.of(context)!;
    List<List> et = [], st = [];

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
    String res;
    res = await DioHelper.addTimes(st, et);
    switch (res) {
      case "1":
        profile();
        addTime = false;
        return trans.succsess;
      case "2":
        return trans.times_used;
    }
    return trans.unknow_error;
  }

  void changeTime() {
    timeChange = !timeChange;
    emit(ChangeConsState());
  }

  void changeAddTime() {
    addTime = !addTime;
    emit(ChangeConsState());
  }

  void changeCons() {
    consChange = !consChange;
    emit(ChangeConsState());
  }

  void changeAddCons() {
    isAddCons = !isAddCons;
    if (isAddCons) {
      listConsult.isEmpty ? listConsult.add(TextEditingController()) : null;
    }
    emit(ChangeConsState());
  }

  void changeScheduale() {
    seeBooked = !seeBooked;
    emit(ChangeSchedualeState());
  }

  void changeDay(String value) {
    daySelected = value;
    indexOfDay = daysMenuItems.indexWhere(
          (element) => daySelected == element,
        ) +
        1;
    times = ex.freeTimes['$indexOfDay'];
    formatEndTime();
    emit(ChangeDayState());
  }

  void formatEndTime() {
    appbointmentEndTime = [];
    if (times != null) {
      for (String elm in times!) {
        appbointmentEndTime.add(
            (int.parse(elm.substring(0, 2)) + 1).toString() +
                elm.substring(2, 5));
      }
    }
  }

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

    daysDropDownItems = daysMenuItems
        .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  void changePhoneEdit() {
    phoneChange = !phoneChange;
    emit(ChangePhoneChangeState());
  }

  void changePhoneAdd() {
    isAddPhone = !isAddPhone;
    if (isAddPhone) {
      listPhone.isEmpty ? listPhone.add(TextEditingController()) : null;
    }
    emit(ChangePhoneChangeState());
  }

  Future<String> sendInfo() async {
    emit(UpdatingInfoState());
    List<String> data = [
      priceController.text,
      countyController.text,
      cityController.text,
      streetController.text,
    ];
    File? imageFile;
    if (pickedFile != null) imageFile = File(pickedFile!.path);
    List<String> expName1, expDesc1;
    expName1 = expName.map((e) => e.text).toList();
    expDesc1 = expDesc.map((e) => e.text).toList();
    String res = await DioHelper.updateInfo(
        expName1, expDesc1, data, imageFile, password.text);
    res == '1' ? await profile() : null;
    emit(FinishUpdatingState());
    return res;
  }

  void resetTime(context) {
    indexOfDay = 1;
    daySelected = AppLocalizations.of(context)!.saturday;
    times = ex.freeTimes['1'];
    conslutings.clear();
    conslutingsIds.clear();
    formatEndTime();
  }

  Future<String> addNewNumber(context) async {
    emit(SendingNumbers());
    List<int> phone1;
    String res;
    phone1 = listPhone.map((e) => int.parse(e.text)).toList();
    res = await DioHelper.addNewNumbers(phone1);
    await profile();
    isAddPhone = false;
    switch (res) {
      case "1":
        emit(FinishUpdatingState());
        return AppLocalizations.of(context)!.add_successful;
      case "2":
        emit(FinishUpdatingState());
        return AppLocalizations.of(context)!.phone_used;
    }
    emit(FinishUpdatingState());
    return AppLocalizations.of(context)!.unknow_error;
  }

  Future<String> addNewCons(context) async {
    emit(SendingNumbers());
    List<String> newCons;
    String res;
    newCons = listConsult.map((e) => e.text).toList();
    res = await DioHelper.addNewCons(newCons);
    await profile();
    isAddCons = false;
    switch (res) {
      case "1":
        emit(FinishUpdatingState());
        return AppLocalizations.of(context)!.add_successful;
      case "2":
        emit(FinishUpdatingState());
        return AppLocalizations.of(context)!.phone_used;
    }
    emit(FinishUpdatingState());
    return AppLocalizations.of(context)!.unknow_error;
  }

  Future<String> deletePhone(int id, context) async {
    String res = await DioHelper.deletePhone(id);
    switch (res) {
      case "1":
        profile();
        return AppLocalizations.of(context)!.succsess;
      case "2":
        return AppLocalizations.of(context)!.one_number_at_least;
      case "3":
        return AppLocalizations.of(context)!.unknow_error;
    }
    return AppLocalizations.of(context)!.unknow_error;
  }

  Future<String> deleteCons(int id, context) async {
    String res = await DioHelper.deleteCons(id);
    switch (res) {
      case "1":
        profile();
        return AppLocalizations.of(context)!.succsess;
      case "2":
        return AppLocalizations.of(context)!.unknow_error;
    }
    return AppLocalizations.of(context)!.unknow_error;
  }

  Future<String> editNumber(context, int id, int number) async {
    String res = await DioHelper.editPhone(id, number);
    res == '1' ? profile() : null;
    return res;
  }

  Future<String> editCons(context, int id, String number) async {
    String res = await DioHelper.editCons(id, number);
    res == '1' ? profile() : null;
    return res;
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

  late ExpertProfile ex;

  Future<void> my() async {
    ex = await DioHelper.expertProfile();
  }

  Future<void> profile() async {
    emit(ProfileLoadingState());
    listPhone = [];
    listConsult = [];
    expDesc = [];
    expName = [];
    currentPhones = [];
    currentCons = [];
    ex = (await DioHelper.expertProfile());
    cityController.text = ex.city;
    countyController.text = ex.country;
    streetController.text = ex.street;
    priceController.text = ex.cost.toString();
    for (int i = 0; i < ex.phoneNumbers.length; i++) {
      currentPhones.add(
          TextEditingController(text: ex.phoneNumbers[i].number.toString()));
    }
    for (int i = 0; i < ex.expertConsultings.length; i++) {
      currentCons.add(
          TextEditingController(text: ex.expertConsultings[i].name.toString()));
    }
    for (int i = 0; i < ex.experiences.length; i++) {
      expDesc.add(TextEditingController(
          text: ex.experiences[i].description.toString()));
      expName
          .add(TextEditingController(text: ex.experiences[i].name.toString()));
    }
    emit(ProfileFinishLoadingState());
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
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
    ];

    return Row(
      children: [
        IconButton(
            onPressed: () {
              removeEle(index, days);
              removeEle(index, startTimes);
              removeEle(index, endTimes);
            },
            icon: const Icon(Icons.cancel)),
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
        const SizedBox(width: 8),
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
        const SizedBox(width: 8),
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
      ],
    );
  }

  Widget buildListView(
      List<TextEditingController> dataList, String name, TextInputType type,
      {phys = const NeverScrollableScrollPhysics(), bool edit = false}) {
    return ListView.builder(
      physics: phys,
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              if (edit)
                IconButton(
                  onPressed: () async {
                    int id = ex.phoneNumbers[index].id;
                    int number = int.parse(currentPhones[index].text);
                    if (editPhoneKey.currentState!.validate()) {
                      await editNumber(context, id, number).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value == '1'
                                ? AppLocalizations.of(context)!.succsess
                                : value == '2'
                                    ? AppLocalizations.of(context)!.phone_used
                                    : AppLocalizations.of(context)!
                                        .unknow_error)));
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
              Expanded(
                child: InputField(
                  labelText: '$name ${index + 1}',
                  keyboard: type,
                  controller: dataList[index],
                  onChanged: (String? value) {
                    if (!edit) {
                      onChanged(value, index, dataList);
                      return null;
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (!edit) {
                      removeEle(index, dataList);
                    } else {
                      int id = ex.phoneNumbers[index].id;
                      deletePhone(id, context).then((value) =>
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(value))));
                    }
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildConsListView(
      List<TextEditingController> dataList, String name, TextInputType type,
      {phys = const NeverScrollableScrollPhysics(), bool edit = false}) {
    return ListView.builder(
      physics: phys,
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              if (edit)
                IconButton(
                  onPressed: () async {
                    int id = ex.expertConsultings[index].id;
                    String consluting = currentCons[index].text;
                    if (editConsKey.currentState!.validate()) {
                      await editCons(context, id, consluting).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value == '1'
                                ? AppLocalizations.of(context)!.succsess
                                : value == '2'
                                    ? AppLocalizations.of(context)!.phone_used
                                    : AppLocalizations.of(context)!
                                        .unknow_error)));
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
              Expanded(
                child: InputField(
                  labelText: '$name ${index + 1}',
                  keyboard: type,
                  controller: dataList[index],
                  onChanged: (String? value) {
                    if (!edit) {
                      onChanged(value, index, dataList);
                      return null;
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (!edit) {
                      removeEle(index, dataList);
                    } else if (ex.expertConsultings.length > 1) {
                      int id = ex.expertConsultings[index].id;
                      deleteCons(id, context).then((value) =>
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(value))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .one_cons_at_least)));
                    }
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
      itemCount: expName.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  labelText:
                      '${AppLocalizations.of(context)!.experince} ${index + 1}',
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
