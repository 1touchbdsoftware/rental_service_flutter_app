class ChangePasswordRequest {
  final String userName;
  final String currentPassword;
  final String password;

  ChangePasswordRequest({
    required this.userName,
    required this.currentPassword,
    required this.password,
  });

  // Convert the object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'currentPassword': currentPassword,
      'password': password,
    };
  }
}
