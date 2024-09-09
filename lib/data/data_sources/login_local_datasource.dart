import 'dart:developer';

import 'package:fic11_jilid1/data/models/response/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLocalDatasource {
  Future<bool> saveAuthData(LoginResponseModel model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await pref.setString('auth', model.toRawJson());
    log('Login Token Saved');
    return res;
  }

  Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('auth') ?? '';
    final authData = LoginResponseModel.fromRawJson(jsonString);
    return authData.jwtToken;
  }

  Future<bool> removeToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await pref.remove('auth');
    return res;
  }

  Future<bool> isLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    return authJson.isNotEmpty;
  }

  Future<LoginResponseModel> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('auth') ?? '';
    final authData = LoginResponseModel.fromRawJson(jsonString);
    return authData;
  }

  Future<int> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = LoginResponseModel.fromRawJson(authJson);
    return authData.id;
  }
}
