

class SignInReqParams{

  final String userName;
  final String password;

  SignInReqParams({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    return {"userName": userName, "password": password,};
  }



}