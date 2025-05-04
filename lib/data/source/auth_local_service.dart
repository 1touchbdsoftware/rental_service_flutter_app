




//we will call the api from here
abstract class AuthLocalService{

  Future<bool> isLoggedIn();



}

class AuthLocalServiceImpl extends AuthLocalService{

  @override
  Future<bool> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }


}