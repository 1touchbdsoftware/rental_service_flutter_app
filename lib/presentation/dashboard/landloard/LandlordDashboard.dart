import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import '../../widgets/drawer.dart';
import '../bloc/user_cubit.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignInPage()),
                  (Route<dynamic> route) => false,
            );
          }
        },
        child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final textTheme = theme.textTheme;

              return Scaffold(
                backgroundColor: colorScheme.surfaceContainer,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  title: BlocBuilder<UserInfoCubit, UserInfoModel>(
                    builder: (context, userInfo) {
                      return Text(
                        "Landlord Dashboard",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined, color: colorScheme.primary),
                      onPressed: () {
                        // Handle notifications
                      },
                    ),
                  ],
                ),
                drawer: BlocBuilder<UserInfoCubit, UserInfoModel>(
                  builder: (context, userInfo) {
                    return buildAppDrawer(
                      context,
                      userInfo.landlordName ?? "",
                      'Landlord Dashboard',
                    );
                  },
                ),
                body: SafeArea(
                  child: BlocBuilder<UserInfoCubit, UserInfoModel>(
                    builder: (context, userInfo) {
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: _buildProfileSection(context, userInfo),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            sliver: SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                                child: Text(
                                  'Quick Actions',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  _buildActionButton(
                                    context,
                                    icon: Icons.pending_actions,
                                    text: 'Issue List',
                                    color: colorScheme.secondary,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/landlord-issues-screen');
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildActionButton(
                                    context,
                                    icon: Icons.check_circle_outline,
                                    text: 'Resolved',
                                    color: colorScheme.tertiary,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/landlord-resolved-screen');
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildActionButton(
                                    context,
                                    icon: Icons.cancel_outlined,
                                    text: 'Declined',
                                    color: colorScheme.error,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/landlord-declined-screen');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _buildRecentActivity(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserInfoModel userInfo) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    userInfo.landlordName?.isNotEmpty == true
                        ? userInfo.landlordName![0].toUpperCase()
                        : 'L',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo.landlordName ?? 'Landlord',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Property Owner',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Landlord ID: ${userInfo.landlordID ?? 'Not Available'}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
        required VoidCallback onPressed,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 2,
          shadowColor: colorScheme.shadow.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                context,
                title: 'New Complaint',
                description: 'Unit 304: Plumbing issue',
                dateTime: 'Today, 10:45 AM',
                iconData: Icons.add_circle_outline,
                iconColor: colorScheme.secondary,
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              _buildActivityItem(
                context,
                title: 'Complaint Resolved',
                description: 'Unit 201: Window repair',
                dateTime: 'Yesterday, 2:30 PM',
                iconData: Icons.check_circle_outline,
                iconColor: colorScheme.tertiary,
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              _buildActivityItem(
                context,
                title: 'Complaint Declined',
                description: 'Unit 105: Paint request',
                dateTime: '3 days ago',
                iconData: Icons.cancel_outlined,
                iconColor: colorScheme.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      BuildContext context, {
        required String title,
        required String description,
        required String dateTime,
        required IconData iconData,
        required Color iconColor,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            dateTime,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}