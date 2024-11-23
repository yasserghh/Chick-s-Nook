import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/moduls/authentication/domain/use_cases/use_cases.dart';
import 'package:foodapp/moduls/authentication/screens/forgot_password/otp/view/otp_forgot_view.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final StreamController isValidToGo = BehaviorSubject<bool>();
  final ForgoutPasswordUseCase _useCase;
  final _auth = FirebaseAuth.instance;
  ForgotPasswordViewModel(this._useCase);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? phone;
  String verificationID = '';

  RxBool loading = false.obs;

  onChangePhoneValue(String? e) {
    phone = e;
    print(phone);
  }

  checkPhone(BuildContext context) async {
    if (formKey.currentState!.validate()) {
       loading.toggle();
      (await _useCase.excute(ForGoutInputs(phone!))).fold(
          (l) => {
                 loading.toggle(),
              },
          (r) => {
                _auth.verifyPhoneNumber(
                    phoneNumber: "$phone",
                    verificationCompleted: (e) {},
                    verificationFailed: (e) {
                       loading.toggle();
                    },
                    codeSent: (String verifivationID, int? resendCode) {
                      print('succceeees');
                       loading.toggle();
                      verificationID = verifivationID;
                      isValidToGo.add(true);
                    },
                    codeAutoRetrievalTimeout: (e) {
                       loading.toggle();
                    })
              });
    }
  }

  @override
  dispose() {
    flowStateController.close();
  }

  @override
  start() {}
}
