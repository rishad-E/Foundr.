import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:founder_app/common/constants/api/apiconfig.dart';
import 'package:founder_app/model/profile/profle_model.dart';

class UserProfileService {
  Dio dio = Dio();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<UserDetails?> getUserDetailes() async {
    String path = ApiConfig().baseUrl + ApiConfig().getUserDetailesapi;
    String? token = await storage.read(key: "token");
    final option = Options(headers: {'Authorization': 'Bearer $token'});
    try {
      Response response = await dio.get(path, options: option); 
      log(response.data.toString(), name: 'getUser');

      //
      if (response.statusCode == 200) {
        final json = response.data["userDetails"];
        final res = UserDetails.fromJson(json);
        return res;
      }
    } catch (e) {
      log(e.toString(), name: 'userCatch');
    }
    return null;
  }

  Future<bool?> profileUpdate(String imagepath) async {
    String path = ApiConfig().baseUrl + ApiConfig().profileUpdateapi;
    String? token = await storage.read(key: "token");

    try {
      Response response = await dio.post(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {"file": imagepath},
      );
      log(response.data.toString());
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
