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
                right: 8,
                top: 8,
                child: Text(
                  state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
                  style: TextStyle(
                    color: badgeColor ?? Colors.red, // Changed to use badgeColor for text color
                    fontSize: 12, // Slightly larger font size
                    fontWeight: FontWeight.bold,
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
          child: const NotificationsPage(),
        ),
      ),
    );
  }
}

