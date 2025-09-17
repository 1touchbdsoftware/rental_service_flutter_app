

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/notifications/notifications_cubit.dart';
import '../../common/bloc/notifications/notifications_state.dart';
import '../../data/model/notifications/get_user_notifs_params.dart';
import '../../data/model/notifications/mark_as_read_all_req.dart';
import '../../data/model/notifications/mark_as_read_single_request.dart';
import '../../data/model/notifications/notifications_entity.dart';
import '../../data/model/pagination_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.markAllLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: state.items.isNotEmpty && state.unreadCount > 0
                    ? () => context.read<NotificationCubit>().markAllRead(
                  MarkAllAsReadRequest(userId: 'current-user-id'),
                )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.listLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.listError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.listError}'),
                  ElevatedButton(
                    onPressed: () => context.read<NotificationCubit>().fetchFirstPage(
                      GetUserNotificationsParams(
                        userId: 'current-user-id',
                        pageNumber: 1,
                        pageSize: 20,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          return ListView.builder(
            itemCount: state.items.length + (_hasNextPage(state.page) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.items.length) {
                return _buildLoadMoreButton(context, state);
              }

              final notification = state.items[index];
              return _buildNotificationItem(context, notification, state);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, NotificationState state) {
    if (state.loadMoreLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          final nextPage = state.page?.pageNumber != null ? state.page!.pageNumber + 1 : 2;
          context.read<NotificationCubit>().loadMore(
            GetUserNotificationsParams(
              userId: 'current-user-id',
              pageNumber: nextPage,
              pageSize: 20,
            ),
          );
        },
        child: const Text('Load More'),
      ),
    );
  }
// this helper method to check if there's a next page
  bool _hasNextPage(Pagination? page) {
    if (page == null) return false;
    return page.pageNumber < page.totalPages;
  }
  Widget _buildNotificationItem(
      BuildContext context,
      UserNotificationEntity notification,
      NotificationState state,
      ) {
    return ListTile(
      leading: Icon(
        notification.isRead ? Icons.notifications : Icons.notifications_active,
        color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
      ),
      title: Text(notification.title),
      subtitle: Text(notification.body),
      trailing: state.markingIds.contains(notification.userNotificationId.toString())
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : null,
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationCubit>().markSingleRead(
            MarkAsReadSingleRequest(
              userNotificationId: notification.userNotificationId,
              userId: 'current-user-id',
            ),
          );
        }
        // Handle notification tap (navigate to relevant screen)
      },
    );
  }
}