
class GetUserNotificationsParams {
  final String userId;
  final int pageNumber;
  final int pageSize;

  GetUserNotificationsParams({
    required this.userId,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toQuery() => {
    'userId': userId,
    'PageNumber': pageNumber,
    'PageSize': pageSize,
  };
}
