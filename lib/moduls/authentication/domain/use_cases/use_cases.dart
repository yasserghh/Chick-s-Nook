import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:foodapp/core/bases/base_usecase.dart';
import 'package:foodapp/core/network/faileur.dart';
import 'package:foodapp/core/network/requests.dart';
import 'package:foodapp/moduls/authentication/domain/models/models.dart';
import 'package:foodapp/moduls/authentication/domain/repository/repository.dart';

// login

class LoginUseCases extends BaseUseCase<LoginInput, Login> {
  AuthenticationRepository _authenticationRepository;
  LoginUseCases(this._authenticationRepository);
  @override
  Future<Either<Faileur, Login>> excute(LoginInput loginInputs) async {
    return await _authenticationRepository.login(LoginRequest(
        phone: loginInputs.phone,
        password: loginInputs.password,
        token: loginInputs.token));
  }
}

// signup

class SignupUseCases extends BaseUseCase<SignupInput, Map<String,dynamic>> {
  final AuthenticationRepository _authenticationRepository;
  SignupUseCases(this._authenticationRepository);
  @override
  Future<Either<Faileur, Map<String,dynamic>>> excute(SignupInput signupInputs) async {
    return await _authenticationRepository.signup(SignupRequest(
        firstName: signupInputs.firstName,
        lastName: signupInputs.lastName,
        phone: signupInputs.phone,
        password: signupInputs.password,
        token: signupInputs.token));
  }
}

class CheckPhoneUseCase extends BaseUseCase<Check_Phone_email_inputs, Login> {
  final AuthenticationRepository _authenticationRepository;
  CheckPhoneUseCase(this._authenticationRepository);
  @override
  Future<Either<Faileur, Login>> excute(
      Check_Phone_email_inputs checkInputs) async {
    return await _authenticationRepository.check_email_phone(
        Check_email_phone_request(
             phone: checkInputs.phone));
  }
}

class ForgoutPasswordUseCase extends BaseUseCase<ForGoutInputs, String> {
  final AuthenticationRepository _authenticationRepository;
  ForgoutPasswordUseCase(this._authenticationRepository);
  @override
  Future<Either<Faileur, String>> excute(ForGoutInputs checkInputs) async {
    return await _authenticationRepository.checkPhoneForgout(checkInputs.phone);
  }
}

class ChangePasswordUseCase extends BaseUseCase<ChangePasswordInputs, String> {
  final AuthenticationRepository _authenticationRepository;
  ChangePasswordUseCase(this._authenticationRepository);
  @override
  Future<Either<Faileur, String>> excute(
      ChangePasswordInputs changePasswordInputs) async {
    return await _authenticationRepository.changePassword(ChangePasswordRequest(
        changePasswordInputs.phone, changePasswordInputs.password));
  }
}

// use cases inputs
class ForGoutInputs {
  String phone;
  ForGoutInputs(this.phone);
}

class ChangePasswordInputs {
  String phone;
  String password;
  ChangePasswordInputs(this.phone, this.password);
}

class LoginInput {
  String phone;
  String password;
  String token;
  LoginInput(
      {required this.phone, required this.password, required this.token});
}

class SignupInput {
  String firstName;
  String lastName;

  String phone;
  String password;
  String token;
  SignupInput(
      {required this.firstName,
      required this.lastName,
     
      required this.phone,
      required this.password,
      required this.token});
}

class Check_Phone_email_inputs {
  String phone;
  Check_Phone_email_inputs(this.phone);
}
