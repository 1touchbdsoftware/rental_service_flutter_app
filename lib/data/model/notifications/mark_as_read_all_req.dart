class MarkAllAsReadRequest {
  final String userId;

  MarkAllAsReadRequest({required this.userId});

  Map<String, dynamic> toJson() => {
    'userId': userId,
  };
}
