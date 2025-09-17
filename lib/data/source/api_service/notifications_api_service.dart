import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/notifications/get_user_notifs_params.dart';
import '../../model/notifications/mark_as_read_all_req.dart';
import '../../model/notifications/mark_as_read_single_request.dart';

/// ---------- Service Abstraction ----------
abstract class NotificationApiService {
  /// GET: /Notifications/GetUnreadNotificationsCount?userId={uuid}
  Future<Either<ApiFailure, Response>> getUnreadCount({String? userId});

  /// GET: /Notifications/GetUserNotifications?userId={uuid}&PageNumber=&PageSize=
  Future<Either<ApiFailure, Response>> getUserNotifications(
      GetUserNotificationsParams params);

  /// POST: /Notifications/MarkAsReadSingle
  /// body: { "userNotificationId": 0, "userId": "string" }
  Future<Either<ApiFailure, Response>> markAsReadSingle(
      MarkAsReadSingleRequest request);

  /// POST: /Notifications/MarkAllAsRead
  /// body: { "userId": "uuid" }
  Future<Either<ApiFailure, Response>> markAllAsRead(
      MarkAllAsReadRequest request);
}

/// ---------- Service Implementation ----------
class NotificationApiServiceImpl implements NotificationApiService {
  NotificationApiServiceImpl();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('userId');
  }

  Options _authHeader(String token) => Options(headers: {
    'Authorization': 'Bearer $token',
  });

  @override
  Future<Either<ApiFailure, Response>> getUnreadCount({String? userId}) async {
    try {
      final token = await _getToken();
      final resolvedUserId = await _getUserId();

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }
      if (resolvedUserId == null) {
        return Left(ApiFailure('User id not found'));
      }

      final response = await sl<DioClient>().get(
        ApiUrls.getUnreadNotificationsCount, // e.g. '/Notifications/GetUnreadNotificationsCount'
        queryParameters: {'userId': resolvedUserId},
        options: _authHeader(token),
      );

      return Right(response);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, Response>> getUserNotifications(
      GetUserNotificationsParams params) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().get(
        ApiUrls.getUserNotifications, // e.g. '/Notifications/GetUserNotifications'
        queryParameters: params.toQuery(),
        options: _authHeader(token),
      );

      return Right(response);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, Response>> markAsReadSingle(
      MarkAsReadSingleRequest request) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().post(
        ApiUrls.markNotificationReadSingle, // e.g. '/Notifications/MarkAsReadSingle'
        data: request.toJson(),
        options: _authHeader(token).copyWith(
          contentType: 'application/json',
        ),
      );

      return Right(response);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, Response>> markAllAsRead(
      MarkAllAsReadRequest request) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().post(
        ApiUrls.markAllNotificationsRead, // e.g. '/Notifications/MarkAllAsRead'
        data: request.toJson(),
        options: _authHeader(token).copyWith(
          contentType: 'application/json',
        ),
      );

      return Right(response);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
