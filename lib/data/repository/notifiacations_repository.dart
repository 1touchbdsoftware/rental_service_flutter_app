// lib/data/repository/notifications_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/notifications_repository.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/notifications/notifications_entity.dart';
import '../model/pagination_model.dart';
import '../source/api_service/notifications_api_service.dart';
import '../model/notifications/get_user_notifs_params.dart';
import '../model/notifications/mark_as_read_all_req.dart';
import '../model/notifications/mark_as_read_single_request.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl();

  // --------- GET: Unread Count ----------
  @override
  Future<Either<String, int>> getUnreadCount({String? userId}) async {
    final Either<ApiFailure, Response> result =
    await sl<NotificationApiService>().getUnreadCount(userId: userId);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          if (response.data is! Map<String, dynamic>) {
            return Left('Invalid response format');
          }
          final root = response.data as Map<String, dynamic>;
          final data = root['data'];
          if (data is! Map<String, dynamic>) {
            return Left('Invalid response: data not found');
          }
          final unread = data['unreadCount'];
          if (unread is! int) {
            return Left('Invalid response: unreadCount not found');
          }
          return Right(unread);
        } catch (e) {
          return Left('Failed to parse unread count: ${e.toString()}');
        }
      },
    );
  }

  // --------- GET: User Notifications (paged) ----------
  @override
  Future<Either<String, NotificationsPageResult>> getUserNotifications(
      GetUserNotificationsParams params,
      ) async {
    final Either<ApiFailure, Response> result =
    await sl<NotificationApiService>().getUserNotifications(params);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          if (response.data is! Map<String, dynamic>) {
            return Left('Invalid response format');
          }

          final root = response.data as Map<String, dynamic>;
          final data = root['data'];
          if (data is! Map<String, dynamic>) {
            return Left('Invalid response: data not found');
          }

          // listOfObject
          final listRaw = data['listOfObject'];
          if (listRaw is! List) {
            return Left('Invalid response: listOfObject not found');
          }
          final items = listRaw
              .whereType<Map<String, dynamic>>()
              .map(UserNotificationEntity.fromJson)
              .toList();

          // pageparam
          final pageRaw = data['pageparam'];
          if (pageRaw is! Map<String, dynamic>) {
            return Left('Invalid response: pageparam not found');
          }
          final page = Pagination.fromJson(pageRaw);

          return Right(NotificationsPageResult(items: items, page: page));
        } catch (e) {
          return Left('Failed to parse notifications: ${e.toString()}');
        }
      },
    );
  }

  // --------- POST: Mark single as read ----------
  @override
  Future<Either<String, bool>> markAsReadSingle(
      MarkAsReadSingleRequest request,
      ) async {
    final Either<ApiFailure, Response> result =
    await sl<NotificationApiService>().markAsReadSingle(request);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          final status = response.statusCode ?? 0;
          final ok = status >= 200 && status < 300;
          return Right(ok);
        } catch (e) {
          return Left('Failed to mark notification as read: ${e.toString()}');
        }
      },
    );
  }

  // --------- POST: Mark all as read ----------
  @override
  Future<Either<String, bool>> markAllAsRead(
      MarkAllAsReadRequest request,
      ) async {
    final Either<ApiFailure, Response> result =
    await sl<NotificationApiService>().markAllAsRead(request);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          final status = response.statusCode ?? 0;
          final ok = status >= 200 && status < 300;
          return Right(ok);
        } catch (e) {
          return Left('Failed to mark all as read: ${e.toString()}');
        }
      },
    );
  }
}
