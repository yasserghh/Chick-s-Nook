import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodapp/main.dart';
import 'package:foodapp/moduls/main/data/responses/home_responses.dart';
import 'package:foodapp/moduls/main/data/responses/notification_response.dart';
import 'package:foodapp/moduls/main/data/responses/order_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/constants.dart';

abstract class ApiServicesClientMain {
  Future<HomeResponse> getHomeData();
  Future<SearchResponse> search(String title);
  Future<OrderResponse> sendOrder(Map<String, dynamic> order);
  Future<NotificationsResponse> getNotification();
  Future<OrdersDataResponse> getOrders(int id);
  Future<UpdateProfileResponse> updateProfil(
      int id, String f_name, String l_name, String password, String token);
  Future<UpdateProfileResponse> deleteProfil(int id);
}

class ApiServicesClientMainIpml implements ApiServicesClientMain {
  Dio dio = Dio();
  ApiServicesClientMainIpml() {
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      method: 'POST',
      headers: {"Authorization": "Bearer $token"},
      sendTimeout: Constants.timeOut,
      receiveTimeout: Constants.timeOut,
      receiveDataWhenStatusError: true,
      extra: <String, dynamic>{},
      queryParameters: <String, dynamic>{},
    );
  }

  @override
  Future<HomeResponse> getHomeData() async {
    var response = await dio.get('/api/v1/products/all-products');
    return HomeResponse.fromJson(response.data);
  }

  @override
  Future<SearchResponse> search(String title) async {
    var response = await dio.get('/api/v1/products/search?name=$title');
    return SearchResponse.fromJson(response.data);
  }

  Map<String, dynamic>? queryParameters;
  @override
  Future<OrderResponse> sendOrder(Map<String, dynamic> order) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? token = shared.getString("token");
    //print(token);
    //showToast(token);
    dio.options.headers = {"Authorization": "Bearer $token"};
  print(order);    var response = await dio.post(
      '/api/v1/customer/order/place',
      data: order,
    );
   
    var data = OrderResponse.fromJson({'status': response.data['status']});
    return data;
  }

  @override
  Future<NotificationsResponse> getNotification() async {
    var response = await dio.get('/api/v1/notifications');
    return NotificationsResponse.fromJson(response.data);
  }

  @override
  Future<OrdersDataResponse> getOrders(int id) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    print(shared.containsKey("token"));
    String? token = shared.getString("token");
    dio.options.headers = {"Authorization": "Bearer $token"};
    print(token);
    var response = await dio.get('/api/v1/customer/order/list/$id');

    var data = OrdersDataResponse.fromJson(response.data);
    return data;
  }

  @override
  Future<UpdateProfileResponse> updateProfil(int id, String f_name,
      String l_name, String password, String token) async {
    Map<String, dynamic> body = {
      "f_name": f_name,
      "l_name": l_name,
      "password": password,
      "user_id": id
    };

    var data = FormData.fromMap(body);
    // print(body);
    dio.options.headers = {"Authorization": "Bearer $token"};

    var response = await dio.put('/api/v1/customer/update-profile', data: data);

    print(response);
    return UpdateProfileResponse.fromJson(response.data);
  }

  @override
  Future<UpdateProfileResponse> deleteProfil(int id) async {
    var data = FormData.fromMap({"user_id": id});
    SharedPreferences shared = await SharedPreferences.getInstance();

    String token = shared.getString("token") ?? "";

    dio.options.headers = {"Authorization": "Bearer $token"};
    var response =
        await dio.delete("/api/v1/customer/remove-account", data: data);
    print("============>$response");
    return UpdateProfileResponse.fromJson(response.data);
  }
}
