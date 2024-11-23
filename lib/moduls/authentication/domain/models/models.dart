class User {
  int id;
  String firstName;
  String lastName;
  String phone;
  User(this.id, this.firstName, this.lastName,this.phone);
}

class Login {
  User? user;
  Login(this.user);
}
