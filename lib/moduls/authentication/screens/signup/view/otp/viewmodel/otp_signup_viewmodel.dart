import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodapp/app/shared_preferences.dart';
import 'package:foodapp/core/local_data/remote_local_data.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/moduls/authentication/domain/use_cases/use_cases.dart';
import '../../../../../../../app/dependency_injection.dart';
import '../../../../../../../core/bases/base_viewmodel.dart';
import '../../../../../../../core/common/state_rendrer/state_rendrer_impl.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../../../core/resources/fonts_manager.dart';
import '../../../../../../../core/resources/styles_manager.dart';

class OtpSignupViewModel extends BaseViewModel {
  final SignupUseCases _signupUseCases;
  final RemoteLocalDataSource _dataSource;
  final AppPreferences _preferences = inectance<AppPreferences>();
  OtpSignupViewModel(
    this._signupUseCases,
    this._dataSource,
  );
  
  completSignup(BuildContext context,
      {required String firstName,
      required String lastName,
      required String phone,
      required String password,
      required String token}) async {
    (await _signupUseCases.excute(SignupInput(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            password: password,
            token: token, fcmtoken: '')))
        .fold(
            (faileur) => {
                  dimissDialog(context),
                  showToast("حدث خطأ اثناء التسجيل . يرجى المحاولة لاحقا",
                      duration: const Duration(seconds: 5),
                      context: context,
                      backgroundColor: ColorManager.reed,
                      textStyle: getSemiBoldStyle(
                          14, ColorManager.white, FontsConstants.cairo))
                },
            (success) => {
                  //
                  // print(success.user?.phone),
                  saveUser(
                    success["user_id"],
                    firstName,
                    lastName,
                    phone,
                  ),
                  Navigator.of(context).pushReplacementNamed(Routes.homeScreen),
                });
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

  @override
  dispose() {
    inectance.unregister<OtpSignupViewModel>();
    inectance.unregister<SignupUseCases>();
  }

  @override
  start() {
    // TODO: implement start
    throw UnimplementedError();
  }
}
