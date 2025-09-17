import '../pagination_model.dart';

class UserNotificationEntity {
  final int userNotificationId;
  final String? userId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? deliveredAt;
  final int? notificationId;
  final String title;
  final String body;
  final String? redirectEndpoint;
  final DateTime? createdAt;
  final String? sentBy;

  UserNotificationEntity({
    required this.userNotificationId,
    this.userId,
    required this.isRead,
    this.readAt,
    this.deliveredAt,
    this.notificationId,
    required this.title,
    required this.body,
    this.redirectEndpoint,
    this.createdAt,
    required this.sentBy,
  });

  factory UserNotificationEntity.fromJson(Map<String, dynamic> json) {
    DateTime? _parseNullable(String? v) {
      if (v == null) return null;
      if (v.isEmpty) return null;
      return DateTime.tryParse(v);
    }

    return UserNotificationEntity(
      userNotificationId: json['userNotificationId'] as int,
      userId: json['userId'] as String?,
      isRead: json['isRead'] as bool,
      readAt: _parseNullable(json['readAt']?.toString()),
      deliveredAt: _parseNullable(json['deliveredAt']?.toString()),
      notificationId: json['notificationId'] as int?,
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      redirectEndpoint: json['redirectEndpoint']?.toString(),
      createdAt: _parseNullable(json['createdAt']?.toString()),
      sentBy: json['sentBy']?.toString(),
    );
  }

  // Add this method to create a copy with read status updated
  UserNotificationEntity withRead({
    bool? isRead,
    DateTime? readAt,
  }) {
    return UserNotificationEntity(
      userNotificationId: userNotificationId,
      userId: userId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      deliveredAt: deliveredAt,
      notificationId: notificationId,
      title: title,
      body: body,
      redirectEndpoint: redirectEndpoint,
      createdAt: createdAt,
      sentBy: sentBy ?? '',
    );
  }
}

class NotificationsPageResult {
  final List<UserNotificationEntity> items;
  final Pagination page;

  NotificationsPageResult({
    required this.items,
    required this.page,
  });
}