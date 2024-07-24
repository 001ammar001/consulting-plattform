import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/cache_helper.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  Locale? locale;
  bool checkToken = CacheHelper.getToken() != null;
  bool isExpert = false;
  bool dataCompleted = false;

  Future<void> getAccountType() async {
    isExpert = await DioHelper.getAccountType();
    if (isExpert) {
      dataCompleted = await DioHelper.checkData();
    }
  }

  void setLanguage() async {
    String? lang = CacheHelper.getLanguage();
    if (lang != null) {
      locale = Locale(lang);
      return;
    } else {
      String lang = window.locale.languageCode;
      if (lang == 'en' || lang == 'ar') {
        await CacheHelper.setLanguage(value: lang)
            ? locale = Locale(lang)
            : setLanguage();
        emit(ChangeLanguageState());
      } else {
        await CacheHelper.setLanguage(value: 'en')
            ? locale = const Locale('en')
            : changeLanguage();
        emit(ChangeLanguageState());
      }
    }
  }

  void changeLanguage() async {
    String lang = CacheHelper.getLanguage()!;
    lang == 'en' ? lang = 'ar' : lang = 'en';
    if (await CacheHelper.setLanguage(value: lang)) {
      locale = Locale(lang);
      emit(ChangeLanguageState());
    } else {
      changeLanguage();
    }
  }
}
