import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/app/constants.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/local_data/remote_local_data.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/moduls/main/domain/models/order_model.dart';
import 'package:foodapp/moduls/main/domain/use_cases/use_caces.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import '../../../../../app/shared_preferences.dart';

class OrderTrackerViewModel extends BaseViewModel {
  final OrderDataUseCase _useCase;
  final RemoteLocalDataSource _dataSource;
  AppPreferences _preferences;
  OrderTrackerViewModel(this._useCase, this._dataSource, this._preferences);
  final StreamController _ordersStream = BehaviorSubject<OrdersData>();
  int? id;
  bool? isLogin;
  @override
  dispose() {}

  @override
  start() {
    isLogin = _preferences.getIsLogin() ?? false;
    flowStateInput.add(LoadingStateFullScreen(''));
    getOrderData();
  }

  @override
  getOrderData() async {
    if (isLogin != null && isLogin != false) {
      List<Map>? data = await _dataSource.onReedDbUser();
      id = data?[0]['id'];
      print("$id******");
      if (id != null) {
        print('not null');
        (await _useCase.excute(OrderDataInput(id!))).fold(
            (l) => {print('failleur'), flowStateInput.add(ContentState())},
            (r) => {
                  print('success'),
                  orderInput.add(r),
                  flowStateInput.add(ContentState())
                });
      }
    }
  }

  @override
  Sink get orderInput => _ordersStream.sink;

  @override
  Stream<OrdersData> get orderOutput =>
      _ordersStream.stream.map((event) => event);
}

abstract class OrderViewTrackerInputs {
  getOrderData();
  Sink get orderInput;
}

abstract class OrderViewTrackerOutputs {
  Stream<OrdersData> get orderOutput;
}

deleteOrder(String orderId) async {

  try {
    var respone = await http
        .post(Uri.parse(Constants.deleteOrder), body: {'orderId': orderId});
    Navigator.of(Get.context!)
        .pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
  } catch (e) {
    Get.snackbar(
      "خطأ",
      "خطأ في الغاء طلب",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
