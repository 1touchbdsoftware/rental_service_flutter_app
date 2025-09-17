import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/notifications/notifications_cubit.dart';
import '../../common/bloc/notifications/notifications_state.dart';
import '../../data/model/notifications/notifications_entity.dart';


class NotificationsPage extends StatefulWidget {

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize notifications
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<NotificationCubit>().fetchUnreadCount();
    context.read<NotificationCubit>().fetchFirstPage(

    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<NotificationCubit>().state;
      final page = state.page;

      if (page != null &&
          page.pageNumber < page.totalPages &&
          !state.loadMoreLoading) {
        context.read<NotificationCubit>().loadMore(
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
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
                icon: Icon(Icons.done_all, color: colorScheme.primary),
                onPressed: state.items.isNotEmpty && state.unreadCount > 0
                    ? () {
                  context.read<NotificationCubit>().markAllRead(

                  );
                }
                    : null,
                tooltip: 'Mark all as read',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          // Handle errors
          if (state.listError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.listError!),
                backgroundColor: colorScheme.error,
              ),
            );
          }

          if (state.markAllError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.markAllError!),
                backgroundColor: colorScheme.error,
              ),
            );
          }

          if (state.markSingleError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.markSingleError!),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.listLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadInitialData();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.items.length + (state.loadMoreLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final notification = state.items[index];
                return _NotificationItem(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      context.read<NotificationCubit>().markSingleRead(
                    notification.userNotificationId,
                      );
                    }

                    // Handle notification tap (navigate to relevant screen)
                    if (notification.redirectEndpoint != null) {
                      // Navigate to the redirect endpoint
                    }
                  },
                  onMarkAsRead: () {
                    // Call mark as read when the icon is pressed
                    context.read<NotificationCubit>().markSingleRead(
                      notification.userNotificationId,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final UserNotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final bool isMarking;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    this.isMarking = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: notification.isRead
          ? colorScheme.surface
          : colorScheme.primary.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                notification.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: notification.isRead
                      ? colorScheme.onSurface
                      : colorScheme.primary,
                ),
              ),

              const SizedBox(height: 8),

              // Body
              Text(
                notification.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 12),

              // Metadata row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sent by
                  if (notification.sentBy != null && notification.sentBy!.isNotEmpty)
                    Text(
                      'From: ${notification.sentBy}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                  // Delivered at or created at
                  if (notification.deliveredAt != null || notification.createdAt != null)
                    Text(
                      _formatDate(notification.deliveredAt ?? notification.createdAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                  if (!notification.isRead)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: isMarking
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : IconButton(
                        icon: Icon(
                          Icons.mark_email_read,
                          color: colorScheme.primary,
                        ),
                        onPressed: onMarkAsRead,
                        tooltip: 'Mark as read',
                        iconSize: 24,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}