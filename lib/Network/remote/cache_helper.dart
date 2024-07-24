import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static String? getToken() {
    return sharedPreferences.getString('token');
  }

  static Future<bool> setToken({required String token}) async {
    return await sharedPreferences.setString('token', token);
  }

  static Future<bool> removeToken() async {
    return await sharedPreferences.remove('token');
  }

  static String? getLanguage() {
    return sharedPreferences.getString('lang');
  }

  static Future<bool> setLanguage({required String value}) async {
    return await sharedPreferences.setString('lang', value);
  }

  static int? getId() {
    return sharedPreferences.getInt('Id');
  }

  static Future<bool> setId({required int id}) async {
    return await sharedPreferences.setInt('Id', id);
  }

  static Future<bool> removeId() async {
    return await sharedPreferences.remove('Id');
  }
}
