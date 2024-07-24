import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/modules/profile%20page/profile_page.dart';
import '../../Chat List Screen/chat_list_screen.dart';
import '../../Experts List/specialiset_list_screen.dart';
import 'main_screen_states.dart';

class MainScreenCubit extends Cubit<MainScreenStates> {
  MainScreenCubit() : super(MainScreenInitState());

  int currentIndex = 1;
  List<Widget> screens = const [
    ChatListScreen(),
    SpecialisestListScreen(),
    ProfilePage()
  ];

  void changeScreen({required int index}) {
    currentIndex = index;
    emit(ChangeScreenState());
  }
}
