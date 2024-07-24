import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:consulting_platform/Network/remote/cache_helper.dart';
import 'package:consulting_platform/models/chat_model.dart';
import 'package:consulting_platform/models/profile_drawer.dart';
import 'package:consulting_platform/models/show_experts.dart';

import '../../models/expert_profile.dart';
import '../../models/favorite_expert.dart';
import '../../models/show_expert_info.dart';

String baseForEmulator = 'http://10.0.2.2:8000/api';
String baseForMobile =
    'http://192.168.43.12:80/back/consultings-back/public/api';

class DioHelper {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: baseForEmulator,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      receiveDataWhenStatusError: true,
      validateStatus: (status) => true,
    ),
  );

  static Future<bool> signIn(List<String> data) async {
    Response response = await dio.post(
      '/login',
      data: jsonEncode(
        <String, String>{
          "email": data[0],
          "password": data[1],
        },
      ),
    );
    if (response.statusCode == 200) {
      CacheHelper.setToken(token: response.data['token']);
      CacheHelper.setId(id: response.data['user_id']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signUp(List<String> data) async {
    Response response = await dio.post(
      '/register',
      data: {
        "first_name": data[0],
        "last_name": data[1],
        "email": data[2],
        "password": data[3],
        "password_confirmation": data[4],
        "is_expert": data[5]
      },
    );
    if (response.statusCode == 200) {
      CacheHelper.setToken(token: response.data['token']);
      CacheHelper.setId(id: response.data['user_id']);
      return true;
    }
    return false;
  }

  static Future<bool> logout() async {
    String token = CacheHelper.getToken()!;
    var response = await dio.post(
      '/logout',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200 &&
        await CacheHelper.removeToken() &&
        await CacheHelper.removeId()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> addExpert(
    List<String?> phone,
    List<String?> expName,
    List<String?> expDesc,
    List<String?> consName,
    List<String?> data,
    List<List> startTimes,
    List<List> endTimes,
    File? image,
  ) async {
    String token = CacheHelper.getToken()!;

    List<int> sec = [];
    int y = 0;
    int i = 1;
    for (var elm in startTimes) {
      while (i != elm[0]) {
        y = 0;
        i += 1;
      }
      sec.add(y++);
    }
    i = 0;
    y = 0;
    // print(sec);
    // print(startTimes);
    // print(endTimes);
    var p = phone.map((e) {
      if (e != '') {
        return int.parse(e!);
      }
    }).toList();
    FormData postData = FormData.fromMap({
      "image": image != null ? await MultipartFile.fromFile(image.path) : null,
      "phone_number[]": p,
      "experience_name[]": expName,
      "experience_description[]": expDesc,
      "consulting_name[]": consName,
      "cost": data[0],
      "country": data[1],
      "city": data[2],
      "street": data[3],
      for (var elm in startTimes) "start_time[${elm[0]}][${sec[i++]}]": elm[1],
      for (var elm in endTimes) "end_time[${elm[0]}][${sec[y++]}]": elm[1],
    });
    Response response = await dio.post(
      '/expert',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            "Authorization": 'Bearer $token',
          }),
      data: postData,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "1";
    } else if (response.data["message"].contains("must be a date after")) {
      return "2";
    } else if (response.data["message"]
        .contains("The phone number has already been taken")) {
      return "3";
    } else if (response.data["message"]
        .contains("Times should be inserted in order")) {
      return "4";
    } else if (response.data["message"]
        .contains("Start time and end time should start at the same minute")) {
      return "5";
    } else if (response.data["message"].contains("does not match the format")) {
      return "6";
    }
    return "7";
  }

  static Future<List<ExpertList>> getExperts(String id) async {
    List<ExpertList> dataList = [];
    String token = CacheHelper.getToken()!;
    Response response = await dio.get(
      '/consulting_experts/$id',
      options: Options(headers: {
        'Authorization': 'Bearer  $token',
        'Accept': 'application/json ',
      }),
    );
    if (response.statusCode == 200) {
      List d = response.data['data'];
      dataList = d.map((e) => ExpertList.fromJson(e)).toList();
      return dataList;
    }
    return [];
  }

  static Future<List<dynamic>> getAllConsulting() async {
    String token = CacheHelper.getToken()!;
    Response response = await dio.get(
      '/consultings',
      options: Options(headers: {
        'Authorization': 'Bearer  $token',
      }),
    );
    if (response.statusCode == 200) {
      return response.data['consultings'];
    } else {
      return [];
    }
  }

  static Future<ShowExpertInfo?> expertDetails(int id) async {
    String token = CacheHelper.getToken()!;
    Response response = await dio.get(
      '/show_expert_info/$id',
      options: Options(headers: {
        'Authorization': 'Bearer  $token',
      }),
    );
    if (response.statusCode == 200) {
      return ShowExpertInfo.fromJson(response.data);
    } else {
      return null;
    }
  }

  static Future<String> bookAppointment(String expertId, String day,
      String startTime, String hour, String conId) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.post(
      '/book_appointment/$expertId/$conId',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
      data: {
        "day": day,
        "start_time": startTime,
        "number_of_hours": hour,
      },
    );
    if (response.statusCode == 200) {
      return '1';
    } else if (response.statusCode == 405 &&
        response.data["message"]
            .contains("You cannot book an appointment with yourself")) {
      return '2';
    } else if (response.statusCode == 405 &&
        response.data['message']
            .contains("You have to charge your card first")) {
      return '3';
    }
    return '4';
  }

  static Future<bool> getAccountType() async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/account_type',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data['message'] == "Expert" ||
              response.data['message'] == "Data is not completed "
          ? true
          : false;
    }
    return false;
  }

  static Future<bool> checkData() async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/is_completed',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data['message'] == "Completed" ? true : false;
    }
    return false;
  }

  static Future<bool> addToFavorite(String id) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.post(
      '/favorite/$id',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<FavoriteExpert>?> getFavoriteExpert() async {
    String token = CacheHelper.getToken()!;
    List<FavoriteExpert> result = [];
    Response response = await dio.get(
      '/favorites',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    List? d = response.data['Favorite experts'];
    if (response.statusCode == 200 && d != null && d.isNotEmpty) {
      for (int i = 0; i < d.length; i++) {
        result.add(
          FavoriteExpert.fromJson(response.data['Favorite experts'][i]),
        );
      }
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> removeFromFavorite(String id) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.delete(
      '/favorite/$id',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<ExpertProfile> expertProfile() async {
    String token = CacheHelper.getToken()!;

    Response response = await dio.get(
      '/expert_profile',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    return ExpertProfile.fromJson(response.data);
  }

  static Future<String> rateExpert(int id, double rate) async {
    String token = CacheHelper.getToken()!;
    Response res = await dio.post(
      '/rate_expert/$id',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: {"rate": rate},
    );
    if (res.statusCode == 200 && res.data == '') {
      return '2';
    } else if (res.statusCode == 200 &&
        res.data['message'] == "you cant rate this expert") {
      return '1';
    }
    return '3';
  }

  static Future<List<ChatListItem>> getAllChats() async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/chats',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      List d = response.data;
      List<ChatListItem> dataList =
          d.map((e) => ChatListItem.fromJson(e)).toList();
      return dataList;
    }
    return [];
  }

  static Future<List<Massege>> getAllMessages(int chatId, int page) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/messages',
      queryParameters: {"chat_id": chatId, "page": page},
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      List d = response.data;
      List<Massege> dataList = d.map((e) => Massege.fromJson(e)).toList();
      return dataList;
    }
    return [];
  }

  static Future<bool> sendMassage(
    String chatId,
    String massage,
  ) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.post(
      '/messages',
      data: {"chat_id": chatId, "message": massage},
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<int> createChannel(
    String expertId,
  ) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.post(
      '/chats',
      data: {"expert_id": expertId},
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 422) {
      if (response.data["chat_id"] == null) return -1;
      return response.data["chat_id"];
    }
    return -1;
  }

  static Future<List<Massege>> getBookedAppointment(
      int chatId, int page) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/messages',
      queryParameters: {"chat_id": chatId, "page": page},
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      List d = response.data;
      List<Massege> dataList = d.map((e) => Massege.fromJson(e)).toList();
      return dataList;
    }
    return [];
  }

  static Future<String> deletePhone(int phoneId) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.delete(
      '/phone_number/$phoneId',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return '1';
    } else if (response.statusCode == 403 &&
        response.data['message'] ==
            "You should have at least one phone number") {
      return "2";
    } else {
      return "3";
    }
  }

  static Future<String> editPhone(int phoneId, int number) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.put(
      '/phone_number/$phoneId',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
      data: {"phone_number": number},
    );
    if (response.statusCode == 200) {
      return '1';
    } else if (response.statusCode == 422) {
      return '2';
    } else {
      return '3';
    }
  }

  static Future<String> deleteCons(int consId) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.delete(
      '/consulting/$consId',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return '1';
    } else if (response.statusCode == 403 &&
        response.data['message'] == "You should have at least one consulting") {
      return "2";
    } else {
      return "3";
    }
  }

  static Future<String> editCons(int consId, String name) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.put(
      '/consulting/$consId',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
      data: {"consulting_name": name},
    );
    if (response.statusCode == 200) {
      return '1';
    } else {
      return '2';
    }
  }

  static Future<String> addNewNumbers(List<int> phone) async {
    String token = CacheHelper.getToken()!;
    FormData postData = FormData.fromMap({
      "phone_number[]": phone,
    });
    Response res = await dio.post(
      '/phone_numbers',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: postData,
    );
    if (res.statusCode == 200) {
      return '1';
    } else if (res.statusCode == 422) {
      return '2';
    }
    return '3';
  }

  static Future<String> addNewCons(List<String> cons) async {
    String token = CacheHelper.getToken()!;
    FormData postData = FormData.fromMap({
      "consulting_name[]": cons,
    });
    Response res = await dio.post(
      '/consultings',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: postData,
    );
    if (res.statusCode == 200) {
      return '1';
    } else if (res.statusCode == 422) {
      return '2';
    }
    return '3';
  }

  static Future<String> updateInfo(
    List<String?> expName,
    List<String?> expDesc,
    List<String?> data,
    File? image,
    String password,
  ) async {
    String token = CacheHelper.getToken()!;
    FormData postData = FormData.fromMap({
      if (image != null) "image": await MultipartFile.fromFile(image.path),
      "password": password,
      "experience_name[]": expName,
      "experience_description[]": expDesc,
      "cost": data[0],
      "country": data[1],
      "city": data[2],
      "street": data[3],
    });
    Response res = await dio.post(
      '/update_expert',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: postData,
    );
    if (res.statusCode == 200) {
      return '1';
    } else if (res.statusCode == 403) {
      return '2';
    }
    return '3';
  }

  static Future<Map<String, dynamic>> getExpertsByName(String name) async {
    String token = CacheHelper.getToken()!;

    var response = await dio.get(
      '/search/expert_name/$name',
      options: Options(
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data[1];
    }
    return {};
  }

  static Future<String> addTimes(
    List<List> startTimes,
    List<List> endTimes,
  ) async {
    String token = CacheHelper.getToken()!;

    List<int> sec = [];
    int y = 0;
    int i = 1;
    for (var elm in startTimes) {
      while (i != elm[0]) {
        y = 0;
        i += 1;
      }
      sec.add(y++);
    }
    i = 0;
    y = 0;
    FormData postData = FormData.fromMap({
      for (var elm in startTimes) "start_time[${elm[0]}][${sec[i++]}]": elm[1],
      for (var elm in endTimes) "end_time[${elm[0]}][${sec[y++]}]": elm[1],
    });
    Response response = await dio.post(
      '/free_times',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            "Authorization": 'Bearer $token',
          }),
      data: postData,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "1";
    } else if (response.data["message"]
        .contains("You can not add the same free time twice")) {
      return "2";
    } else if (response.data["message"]
        .contains("The phone number has already been taken")) {
      return "3";
    } else if (response.data["message"]
        .contains("Times should be inserted in order")) {
      return "4";
    } else if (response.data["message"]
        .contains("Start time and end time should start at the same minute")) {
      return "5";
    } else if (response.data["message"].contains("does not match the format")) {
      return "6";
    }
    return "7";
  }

  static Future<DataProfile> userProfile() async {
    String token = CacheHelper.getToken()!;
    Response response = await dio.get(
      '/user_profile',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    return DataProfile.fromJson(response.data["data"]);
  }
}
