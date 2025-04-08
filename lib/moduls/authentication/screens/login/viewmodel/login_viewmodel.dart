import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/local_data/remote_local_data.dart';
import 'package:foodapp/moduls/authentication/domain/use_cases/use_cases.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/dependency_injection.dart';
import '../../../../../app/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  final LoginUseCases _loginUseCases;
  final RemoteLocalDataSource _dataSource;
  final AppPreferences _preferences = inectance<AppPreferences>();
  LoginViewModel(this._loginUseCases, this._dataSource);

  //streams
  final StreamController isValidToGoHomePageStream = StreamController<bool>();
  final StreamController isGoToForgotPageStream = BehaviorSubject<bool>();
  final StreamController isGoToSignupPageStream = StreamController<bool>();
  // text form controllers
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phoneNumber = '';

  RxBool loading = false.obs;

  @override
  dispose() {
    isGoToForgotPageStream.close();
    isGoToSignupPageStream.close();
    isValidToGoHomePageStream.close();
  }

  @override
  start() {
    isValidToGoHomePageStream.sink;
    isGoToForgotPageStream.sink;
    isGoToSignupPageStream.sink;
  }

  // methods

  @override
  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      loading.toggle();
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      (await _loginUseCases.excute(LoginInput(
              phone: "$phoneNumber",
              password: passwordController.text,
              token: "",
              fcmtoken: fcmToken ?? null)))
          .fold(
              (faileur) => {
                    loading.toggle(),
                    showToast(faileur.message, context: context),
                  },
              (success) => {
                    loading.toggle(),
                    print("=============>${success.user!.id}"),
                    saveUser(
                      success.user!.id,
                      success.user!.firstName,
                      success.user!.lastName,
                      success.user!.phone,
                    )
                  });
    }
  }

  saveUser(
    int id,
    String firstName,
    String lastName,
    String phone,
  ) async {
    int response = await _dataSource.onInsertUser(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
    if (response > 0) {
      _preferences.addIsLogin(true);
      isValidToGoHomePageStream.add(true);
    }
    flowStateInput.add(ErrorStatePopUp('حدث خطا في حفظ بيانات التسجيل'));
  }

  @override
  loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  goToForgotPage() {
    isGoToForgotPageStream.add(true);
  }

  @override
  goToSignupPage() async {
    isGoToSignupPageStream.add(true);
  }
}

abstract class LoginInputs {
  login();
  loginWithFacebook();
  loginWithGoogle();
  goToForgotPage();
  goToSignupPage();
}

abstract class LoginOutputs {}
