// lib/presentation/widgets/notification_icon_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const NotificationIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationCubit, NotificationState, int>(
      selector: (s) => s.unreadCount,
      builder: (context, unread) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: onPressed ??
                      () {
                    // open notifications screen/page
                  },
            ),
            if (unread > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
