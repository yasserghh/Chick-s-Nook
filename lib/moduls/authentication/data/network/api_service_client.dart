import 'package:dio/dio.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:foodapp/main.dart';
import 'package:foodapp/moduls/authentication/data/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/constants.dart';

abstract class ApiServiceClientAuth {
  Future<SignupResponse> login(
      {required String phone,
      required String password,
      required String token,
      required String? fcmtoken});
  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String token,
    required String? fcmtoken,
  });
  Future<SignupResponse> check_Phone_email({
    required String phone,
  });
  Future<SignupResponse> updateUser(
      {required int id,
      required String f_name,
      required String l_name,
      required String password});
  Future<ForgotPasswordResponse> checkPhoneForgout(String phone);
  Future<ForgotPasswordResponse> changePassword(String phone, String password);
}

class ApiServiceClientAuthImpl implements ApiServiceClientAuth {
  Dio dio = Dio();
  ApiServiceClientAuthImpl() {
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      method: 'POST',
      sendTimeout: Constants.timeOut,
      receiveTimeout: Constants.timeOut,
      receiveDataWhenStatusError: true,
      extra: <String, dynamic>{},
      headers: {
        "Authorization": "Bearer $token",
      },
      queryParameters: <String, dynamic>{},
    );
  }

  @override
  Future<SignupResponse> login(
      {required String phone,
      required String password,
      required String token,
      required String? fcmtoken}) async {
    var data = FormData.fromMap({
      'phone': phone,
      'password': password,
      'token': token,
      if (fcmtoken != null) 'cm_firebase_token': fcmtoken
    });

    var response = await dio.post('/api/v1/auth/login', data: data);

    if (response.data["status"] == "ok") {
      SharedPreferences shared = await SharedPreferences.getInstance();
      await shared.setString("token", response.data["token"]);

      dio.options.headers = {
        "Authorization": "Bearer ${response.data["token"]}"
      };
    }

    return SignupResponse.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> signup(
      {required String firstName,
      required String lastName,
      required String phone,
      required String password,
      required String token,
      required String? fcmtoken}) async {
    var data = FormData.fromMap({
      'f_name': firstName,
      'l_name': lastName,
      'phone': phone,
      'password': password,
      'cm_firebase_token': fcmtoken??""
    });
  print("${
{
      'f_name': firstName,
      'l_name': lastName,
      'phone': phone,
      'password': password,
      'cm_firebase_token': fcmtoken??""
    }
  }");
    var response = await dio.post('/api/v1/auth/registration', data: data);
      print("-----#$response");
    try{
      if (response.data["token"].toString().isNotEmpty) {
      print(response.data["token"]);
      SharedPreferences shared = await SharedPreferences.getInstance();

      await shared.setString("token", response.data["token"]);

      dio.options.headers = {
        "Authorization": "Bearer ${response.data["token"]}"
      };
    }
    }catch(e){
      print("------------erorrrrr$e");
    }

    //print(response.data);

    return response.data;
  }

  @override
  Future<SignupResponse> check_Phone_email({
    required String phone,
  }) async {
    var data = FormData.fromMap({
      'phone': phone,
    });
    var response =
        await dio.post('/api/v1/auth/verify-email-phone', data: data);
    return SignupResponse.fromJson(response.data);
  }

  @override
  Future<SignupResponse> updateUser(
      {required int id,
      required String f_name,
      required String l_name,
      required String password}) async {
    var data = FormData.fromMap({
      'f_name': f_name,
      'l_name': l_name,
      'password': password,
      'user_id': id
    });
    print(dio.options.headers);
    var response = await dio.put('/api/v1/customer/update-profile', data: data);
    return SignupResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> checkPhoneForgout(String phone) async {
    var data = FormData.fromMap({
      'phone': phone,
    });
    var response =
        await dio.post('/api/v1/auth/forgot-password-change', data: data);

    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> changePassword(
      String phone, String password) async {
    var data = FormData.fromMap({'phone': phone, 'password': password});
    var response =
        await dio.post('/api/v1/auth/new-reset-password', data: data);
    return ForgotPasswordResponse.fromJson(response.data);
  }
}
