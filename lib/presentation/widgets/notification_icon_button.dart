// lib/presentation/widgets/notification_icon_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../common/bloc/notifications/notifications_cubit.dart';
import '../../common/bloc/notifications/notifications_state.dart';
import '../notifications/notifications_screen.dart';

class NotificationIconButton extends StatelessWidget {
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? iconSize;

  const NotificationIconButton({
    super.key,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        // Handle any state changes if needed
        if (state.unreadError != null) {
          // Show error snackbar for unread count fetch errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.unreadError!)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: iconColor,
                size: iconSize,
              ),
              onPressed: () => _openNotificationsScreen(context),
            ),
            if (state.unreadCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
                    style: TextStyle(
                      color: badgeTextColor ?? Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (state.unreadLoading)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: const EdgeInsets.all(2),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(badgeColor ?? Colors.red),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _openNotificationsScreen(BuildContext context) {
    final cubit = context.read<NotificationCubit>();

    // Refresh unread count when opening notifications
    cubit.fetchUnreadCount();

    // Navigate to notifications screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: const NotificationsScreen(),
        ),
      ),
    );
  }
}

