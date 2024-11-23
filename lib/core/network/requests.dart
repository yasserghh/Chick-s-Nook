class LoginRequest {
  String phone;
  String password;
  String token;
  LoginRequest(
      {required this.phone, required this.password, required this.token});
}

class SignupRequest {
  String firstName;
  String lastName;

  String phone;
  String password;
  String token;
  SignupRequest(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      required this.password,
      required this.token});
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
