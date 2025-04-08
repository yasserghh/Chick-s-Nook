import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodapp/app/shared_preferences.dart';
import 'package:foodapp/core/local_data/remote_local_data.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/resources/image_manager.dart';
import 'package:foodapp/moduls/authentication/domain/use_cases/use_cases.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import '../../../../../app/dependency_injection.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/fonts_manager.dart';
import '../../../../../core/resources/styles_manager.dart';

class SignupViewModel extends BaseViewModel {
  final CheckPhoneUseCase _checkPhoneUseCase;
  final RemoteLocalDataSource _dataSource;

  final SignupUseCases _signupUseCases;

  SignupViewModel(
      this._checkPhoneUseCase, this._dataSource, this._signupUseCases);
  StreamController isValidToRegister = BehaviorSubject<bool>();
  StreamController isGoToLoginPage = BehaviorSubject<bool>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  String phoneNumber = '';
  String verificationID = '';
  String? fcmToken = '';
  int? id;
/*   final _auth = FirebaseAuth.instance;
 */
  RxBool loading = false.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AppPreferences _preferences = inectance<AppPreferences>();

  @override
  dispose() {
    flowStateController.close();
    // inectance.unregister<SignupViewModel>();
    // inectance.unregister<CheckPhoneUseCase>();
  }

  @override
  start() {}
  // methods

  @override
  goToLoginPage() {
    isGoToLoginPage.add(true);
  }

  @override
  signup(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      loading.toggle();
      if (password1Controller.text == password2Controller.text) {
        (await _checkPhoneUseCase.excute(Check_Phone_email_inputs(phoneNumber)))
            .fold(
                (faileur) => {
                      print("$phoneNumber"),
                      showToast(faileur.message, context: context),
                      loading.toggle(),
                    },
                (success) => {
                      print("$phoneNumber"),
                      /*      _auth.verifyPhoneNumber(
                          phoneNumber: "$phoneNumber",
                          verificationCompleted: (e) {},
                          verificationFailed: (e) {
                            showToast(e.message, context: context);
                            loading.toggle();
                          },
                          codeSent: (String verifivationID, int? resendCode) {
                            //flowStateInput.add(ContentState());
                            verificationID = verifivationID;
                            loading.toggle();
                            isValidToRegister.add(true);
                          },
                          codeAutoRetrievalTimeout: (e) {
                            loading.toggle();
                          }) */
                    });
      } else {
        loading.toggle();
        showToast(
          "كلمة المرور غير متطابقة",
          duration: const Duration(seconds: 3),
          position: StyledToastPosition.bottom,
          fullWidth: true,
          context: context,
          animation: StyledToastAnimation.scale,
          backgroundColor: ColorManager.reed,
          textStyle:
              getSemiBoldStyle(14, ColorManager.white, FontsConstants.cairo),
        );
      }
    }
  }

  completSignup(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String token,
  }) async {
    if (formKey.currentState!.validate()) {
      loading.toggle();
      fcmToken = await FirebaseMessaging.instance.getToken();
      print('===========>$fcmToken');
      (await _signupUseCases.excute(SignupInput(
              firstName: firstName,
              lastName: lastName,
              phone: phone,
              password: password,
              token: token,
              fcmtoken: fcmToken!)))
          .fold(
              (faileur) => {
                    loading.toggle(),
                    dimissDialog(context),
                    showToast("حدث خطأ اثناء التسجيل . يرجى المحاولة لاحقا",
                        duration: const Duration(seconds: 5),
                        context: context,
                        backgroundColor: ColorManager.reed,
                        textStyle: getSemiBoldStyle(
                            14, ColorManager.white, FontsConstants.cairo))
                  },
              (success) => {
                    loading.toggle(),
                    //
                    // print(success.user?.phone),
                    saveUser(
                      success["user_id"],
                      firstName,
                      lastName,
                      phone,
                    ),
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.mainScreen),
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
      //isValidToGoHomePageStream.add(true);
    }
    flowStateInput.add(ErrorStatePopUp('حدث خطا في حفظ بيانات التسجيل'));
  }
}

abstract class SignupInputs {
  signup(BuildContext context);
  goToLoginPage();
}

abstract class SignupOutputs {}

Widget showDialogLoading() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.transparent,
    child: Center(
      child: SizedBox(
        height: 120,
        width: 120,
        child: Lottie.asset(
          LottieManager.loading,
        ),
      ),
    ),
  );
}
