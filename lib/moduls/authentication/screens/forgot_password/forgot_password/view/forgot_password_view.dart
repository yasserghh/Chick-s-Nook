import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:foodapp/core/common/public_widgets.dart/custom_button.dart';
import 'package:foodapp/core/common/public_widgets.dart/custom_phone_input.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/common/validator/validator_inputs.dart';
import 'package:foodapp/core/resources/Strings_manager.dart';
import 'package:foodapp/core/resources/color_manager.dart';
import 'package:foodapp/core/resources/values_manager.dart';
import 'package:foodapp/moduls/authentication/screens/forgot_password/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../otp/view/otp_forgot_view.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordViewModel _forgotPasswordViewModel =
      inectance<ForgotPasswordViewModel>();

String removeLeadingZero(String input) {
  if (input.startsWith('0') && input.length > 1) {
    return input.substring(1);
  }
  return input;
}

      

  bind() {
    _forgotPasswordViewModel.isValidToGo.stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (event) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OtpForgotPasswordScreen(
                    phone: _forgotPasswordViewModel.phone!,
                    credincialID: _forgotPasswordViewModel.verificationID),
              ));
        }
      });
    });
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
            _getContent(),
    );
  }

  Widget _getContent() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
            right: AppSize.queryMargin, left: AppSize.queryMargin),
        child: Form(
          key: _forgotPasswordViewModel.formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Text(
                "إعادة تعيين كلمة المرور",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23, right: 23),
                child: Text(
                  textAlign: TextAlign.center,
                  "الرجاء إدخال الرقم الخاص بك لتلقي رابط لإنشاء كلمة مرور جديدة عبر رقمك ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              getCustomPhoneInput(
                  hint: StringManager.phoneNumber,
                  validator: (e) => validatorInputs(
                      e?.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                      10,
                      10,
                      "phone"),
                  onInputChanged: (e) {
                     String output = removeLeadingZero(e.phoneNumber.toString());
                                e;
                    _forgotPasswordViewModel.onChangePhoneValue(output
                        ?.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
                  }),
              SizedBox(
                height: 30.h,
              ),

                 Obx(() {
                    return _forgotPasswordViewModel.loading.isTrue
                        ? const CircularProgressIndicator(
                            color: ColorManager.primary,
                          )
                        :  getCustomButton(context, "ارسال", () {
                                    _forgotPasswordViewModel.checkPhone(context);
                                  });
                  }),
             
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _forgotPasswordViewModel.dispose();
    super.dispose();
  }
}
