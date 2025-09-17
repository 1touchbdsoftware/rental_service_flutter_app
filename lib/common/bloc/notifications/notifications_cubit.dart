// lib/common/bloc/notification/notification_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rental_service/service_locator.dart';

import '../../../domain/repository/notifications_repository.dart';
import '../../../data/model/notifications/notifications_entity.dart'; // UserNotificationEntity
import '../../../data/model/pagination_model.dart'; // Pagination
import '../../../data/model/notifications/get_user_notifs_params.dart';
import '../../../data/model/notifications/mark_as_read_all_req.dart';
import '../../../data/model/notifications/mark_as_read_single_request.dart';
import 'notifications_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationsRepository _repo;

  NotificationCubit({NotificationsRepository? repo})
      : _repo = repo ?? sl<NotificationsRepository>(),
        super(const NotificationState());

  /// Fetch only the unread count (e.g., app start, pull-to-refresh on badge)
  Future<void> fetchUnreadCount({String? userId}) async {
    emit(state.copyWith(unreadLoading: true, unreadError: null));
    final Either<String, int> res = await _repo.getUnreadCount(userId: userId);
    res.fold(
          (err) => emit(state.copyWith(unreadLoading: false, unreadError: err)),
          (count) => emit(state.copyWith(
        unreadLoading: false,
        unreadCount: count,
        unreadError: null,
      )),
    );
  }

  /// Fetch first page (or refresh list) with given params
  Future<void> fetchFirstPage(GetUserNotificationsParams params) async {
    emit(state.copyWith(listLoading: true, listError: null));
    final res = await _repo.getUserNotifications(params);
    res.fold(
          (err) => emit(state.copyWith(listLoading: false, listError: err)),
          (pageResult) => emit(state.copyWith(
        listLoading: false,
        items: pageResult.items,
        page: pageResult.page,
        listError: null,
      )),
    );
  }

  /// Load more using next params (caller computes next page in params).
  /// This keeps the Cubit decoupled from your Pagination shape.
  Future<void> loadMore(GetUserNotificationsParams nextParams) async {
    if (state.loadMoreLoading) return; // guard
    emit(state.copyWith(loadMoreLoading: true, listError: null));
    final res = await _repo.getUserNotifications(nextParams);
    res.fold(
          (err) => emit(state.copyWith(loadMoreLoading: false, listError: err)),
          (pageResult) {
        final merged = List<UserNotificationEntity>.from(state.items)
          ..addAll(pageResult.items);
        emit(state.copyWith(
          loadMoreLoading: false,
          items: merged,
          page: pageResult.page,
        ));
      },
    );
  }

  /// Mark a single notification as read (optimistic, with rollback on failure)
  Future<void> markSingleRead(MarkAsReadSingleRequest request) async {
    // Already marking this id? avoid duplicate hit
    if (state.markingIds.contains(request.userNotificationId.toString())) return;

    final id = request.userNotificationId;
    final before = state.items;

    // Optimistic UI: set item read=true and decrement unreadCount if applicable
    final updated = before
        .map((n) => n.userNotificationId == id ? _withRead(n, true) : n)
        .toList();

    final dec = _shouldDecrementUnread(before, id) ? 1 : 0;

    emit(state.copyWith(
      items: updated,
      unreadCount: (state.unreadCount - dec).clamp(0, 1 << 31),
      markingIds: {...state.markingIds, id.toString()},
      markSingleError: null,
    ));

    final res = await _repo.markAsReadSingle(request);

    res.fold(
          (err) {
        // Rollback if server failed
        emit(state.copyWith(
          items: before,
          unreadCount: state.unreadCount + dec,
          markingIds: _without(state.markingIds, id.toString()),
          markSingleError: err,
        ));
      },
          (ok) async {
        // If your backend adjusts unread count server-side, optionally re-sync:
        // await fetchUnreadCount();
        emit(state.copyWith(
          markingIds: _without(state.markingIds, id.toString()),
          markSingleError: null,
        ));
      },
    );
  }

  /// Mark all as read (optimistic: clear unread flags and zero badge)
  Future<void> markAllRead(MarkAllAsReadRequest request) async {
    if (state.markAllLoading) return;

    final before = state.items;
    final optimistic = before.map((n) => _withRead(n, true)).toList();

    emit(state.copyWith(
      items: optimistic,
      unreadCount: 0,
      markAllLoading: true,
      markAllError: null,
    ));

    final res = await _repo.markAllAsRead(request);

    res.fold(
          (err) {
        // Rollback
        emit(state.copyWith(
          items: before,
          unreadCount: _recountUnread(before),
          markAllLoading: false,
          markAllError: err,
        ));
      },
          (ok) async {
        // Optionally re-sync from server for absolute truth:
        // await fetchUnreadCount();
        emit(state.copyWith(
          markAllLoading: false,
          markAllError: null,
        ));
      },
    );
  }

  /// Clear everything (e.g., on sign-out)
  void reset() {
    emit(const NotificationState());
  }

  // ---------- helpers ----------
  static int _recountUnread(List<UserNotificationEntity> list) =>
      list.where((n) => !n.isRead).length;

  static bool _shouldDecrementUnread(List<UserNotificationEntity> before, int id) {
    final found = before.firstWhere(
          (e) => e.userNotificationId == id,
      orElse: () => UserNotificationEntity(
        userNotificationId: id,
        title: '',
        body: '',
        isRead: true,
        sentBy: '',
      ),
    );
    // Decrement only if it was previously unread
    return !found.isRead;
  }

  static Set<String> _without(Set<String> s, String id) {
    final copy = Set<String>.from(s);
    copy.remove(id);
    return copy;
  }

  UserNotificationEntity _withRead(UserNotificationEntity n, bool read) {
    return n.withRead(
      isRead: read,
      readAt: read ? DateTime.now() : null,
    );
  }
}