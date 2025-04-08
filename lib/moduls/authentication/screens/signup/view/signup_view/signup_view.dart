import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/core/common/public_widgets.dart/custom_button.dart';
import 'package:foodapp/core/common/public_widgets.dart/custom_phone_input.dart';
import 'package:foodapp/core/common/public_widgets.dart/custom_text_form.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/common/validator/validator_inputs.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/core/resources/values_manager.dart';
import 'package:foodapp/moduls/authentication/screens/signup/view/otp/view/otp_signup_view.dart';
import 'package:foodapp/moduls/authentication/screens/signup/view/otp/viewmodel/otp_signup_viewmodel.dart';
import 'package:foodapp/moduls/authentication/screens/signup/viewmodel/signup_viewmodel.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import '../../../../../../app/dependency_injection.dart';
import '../../../../../../core/resources/Strings_manager.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/fonts_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupViewModel _signupViewModel = inectance<SignupViewModel>();





      
  _bind() {
    _signupViewModel.start();
    //_otpSignupViewModel.start();
    _signupViewModel.isGoToLoginPage.stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (event) {
          Navigator.pushReplacementNamed(context, Routes.loginScreen);
        }
      });
    });
    _signupViewModel.isValidToRegister.stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContent(),
    );
  }

  String removeLeadingZero(String input) {
    if (input.startsWith('0') && input.length > 1) {
      return input.substring(1);
    }
    return input;
  }

  Widget _getContent() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppSize.queryMargin, right: AppSize.queryMargin),
            child: Form(
              key: _signupViewModel.formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        StringManager.signup,
                        style: Theme.of(context).textTheme.displayLarge,
                      )),
                  SizedBox(
                    height: 12.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        StringManager.loginBodyText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  SizedBox(
                    height: 40.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 300),
                      child: getCustomTextFormField(
                          StringManager.firstName,
                          _signupViewModel.firstNameController,
                          false,
                          (e) => validatorInputs(e, 20, 3, "username"),
                          TextInputType.text)),
                  SizedBox(
                    height: 20.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 300),
                      child: getCustomTextFormField(
                          StringManager.lastName,
                          _signupViewModel.lastNameController,
                          false,
                          (e) => validatorInputs(e, 20, 3, "username"),
                          TextInputType.text)),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 300),
                      child: getCustomPhoneInput(
                          hint: StringManager.phoneNumber,
                          validator: (e) => validatorInputs(
                              e?.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                              10,
                              9,
                              "phone"),
                          onInputChanged: (e) {
                            String output = removeLeadingZero(e.phoneNumber
                                .toString()
                                .replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                            _signupViewModel.phoneNumber = output;
                          })),
                  SizedBox(
                    height: 20.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 300),
                      child: getCustomTextFormField(
                          StringManager.password,
                          _signupViewModel.password1Controller,
                          true,
                          (e) => validatorInputs(e, 20, 6, "password"),
                          TextInputType.text)),
                  SizedBox(
                    height: 20.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 450),
                      duration: const Duration(milliseconds: 300),
                      child: getCustomTextFormField(
                          StringManager.validPassword,
                          _signupViewModel.password2Controller,
                          true,
                          (e) => validatorInputs(e, 20, 6, "password"),
                          TextInputType.text)),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() {
                    return FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 300),
                        child: _signupViewModel.loading.isTrue
                            ? const CircularProgressIndicator(
                                color: ColorManager.primary,
                              )
                            : getCustomButton(context, StringManager.creat, () {
                               _signupViewModel.completSignup(context,
                                   firstName: _signupViewModel.firstNameController.text,
                    lastName: _signupViewModel.lastNameController.text,
                    phone: _signupViewModel.phoneNumber,
                    password: _signupViewModel.password1Controller.text,
                    token: _signupViewModel.fcmToken!, );
                              }));
                  }),
                  SizedBox(
                    height: 20.h,
                  ),
                  FadeInUp(
                      delay: const Duration(milliseconds: 550),
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(StringManager.haveAcount,
                                style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(
                              width: 4.h,
                            ),
                            InkWell(
                              onTap: () {
                                _signupViewModel.dispose();
                                _signupViewModel.goToLoginPage();
                              },
                              child: Text(StringManager.signin,
                                  style: getMediumStyle(
                                    16,
                                    ColorManager.primary,
                                    FontsConstants.cairo,
                                  )),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signupViewModel.dispose();
    super.dispose();
  }
}
