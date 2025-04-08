class LoginRequest {
  String phone;
  String password;
  String token;
  String? fcmtoken;
  LoginRequest(
      {required this.phone, required this.password, required this.token,required this.fcmtoken});
}

class SignupRequest {
  String firstName;
  String lastName;
  String? fcmtoken;
  String phone;
  String password;
  String token;
  SignupRequest(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      required this.password,
      required this.token,
      required this.fcmtoken});
}

class Check_email_phone_request {
  String phone;
  Check_email_phone_request({required this.phone});
}

class UpdateUserRequest {
  int id;
  String f_name;
  String l_name;

  String password;
  String token;
  UpdateUserRequest(
      {required this.id,
      required this.f_name,
      required this.l_name,
      required this.password,
      required this.token});
}

class UpdateProfilRequest {
  int id;
  String f_name;
  String l_name;
  String password;
  String token;
  UpdateProfilRequest(
      {required this.id,
      required this.f_name,
      required this.l_name,
      required this.password,
      required this.token});
}

class ChangePasswordRequest {
  String phone;
  String password;
  ChangePasswordRequest(this.phone, this.password);
}
