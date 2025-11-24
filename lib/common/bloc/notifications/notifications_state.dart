// lib/common/bloc/notification/notification_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/model/notifications/notifications_entity.dart'; // UserNotificationEntity
import '../../../data/model/pagination_model.dart'; // Pagination

class NotificationState extends Equatable {
  // Badge
  final int unreadCount;
  final bool unreadLoading;
  final String? unreadError;

  // List + pagination
  final List<UserNotificationEntity> items;
  final Pagination? page;
  final bool listLoading;
  final bool loadMoreLoading;
  final String? listError;

  // Mark operations
  final bool markAllLoading;
  final String? markAllError;

  final Set<String> markingIds; // ids currently being marked as read
  final String? markSingleError;

  final List<UserNotificationEntity>? recentActivityItems;


  const NotificationState({
    this.unreadCount = 0,
    this.unreadLoading = false,
    this.unreadError,
    this.items = const [],
    this.page,
    this.listLoading = false,
    this.loadMoreLoading = false,
    this.listError,
    this.markAllLoading = false,
    this.markAllError,
    this.markingIds = const {},
    this.markSingleError,

    this.recentActivityItems = const [],
  });

  NotificationState copyWith({
    int? unreadCount,
    bool? unreadLoading,
    String? unreadError,

    List<UserNotificationEntity>? items,
    Pagination? page,
    bool? listLoading,
    bool? loadMoreLoading,
    String? listError,

    bool? markAllLoading,
    String? markAllError,

    Set<String>? markingIds,
    String? markSingleError,
    List<UserNotificationEntity>? recentActivityItems,
  }) {
    return NotificationState(
      unreadCount: unreadCount ?? this.unreadCount,
      unreadLoading: unreadLoading ?? this.unreadLoading,
      unreadError: unreadError,
      items: items ?? this.items,
      page: page ?? this.page,
      listLoading: listLoading ?? this.listLoading,
      loadMoreLoading: loadMoreLoading ?? this.loadMoreLoading,
      listError: listError,
      markAllLoading: markAllLoading ?? this.markAllLoading,
      markAllError: markAllError,
      markingIds: markingIds ?? this.markingIds,
      markSingleError: markSingleError,
      recentActivityItems: recentActivityItems ?? this.recentActivityItems,
    );
  }

  @override
  List<Object?> get props => [
    unreadCount,
    unreadLoading,
    unreadError,
    items,
    page,
    listLoading,
    loadMoreLoading,
    listError,
    markAllLoading,
    markAllError,
    markingIds,
    markSingleError,
  ];
}
