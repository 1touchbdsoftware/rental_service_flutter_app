// lib/domain/repository/notifications_repository.dart
import 'package:dartz/dartz.dart';
import '../../data/model/notifications/get_user_notifs_params.dart';
import '../../data/model/notifications/mark_as_read_all_req.dart';
import '../../data/model/notifications/mark_as_read_single_request.dart';
import '../../data/model/notifications/notifications_entity.dart';

abstract class NotificationsRepository {
  Future<Either<String, int>> getUnreadCount({String? userId});

  Future<Either<String, NotificationsPageResult>> getUserNotifications(
      GetUserNotificationsParams params,
      );

  Future<Either<String, bool>> markAsReadSingle(
      MarkAsReadSingleRequest request,
      );

  Future<Either<String, bool>> markAllAsRead(
      MarkAllAsReadRequest request,
      );
}
