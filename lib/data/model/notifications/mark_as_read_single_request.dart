class MarkAsReadSingleRequest {
  final int userNotificationId;
  final String userId;

  MarkAsReadSingleRequest({
    required this.userNotificationId,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'userNotificationId': userNotificationId,
    'userId': userId,
  };
}
