abstract class UserRepository {
  Future<String?> getSavedUsername(); // just the interface

  Future<String?> getUserType();
// ... other methods (login, etc.)
}