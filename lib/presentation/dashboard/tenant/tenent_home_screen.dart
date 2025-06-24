import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import '../../../data/model/user/user_info_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/drawer.dart';
import '../bloc/user_info_cubit.dart';

class TenantHomeScreen extends StatelessWidget {
  const TenantHomeScreen({super.key});

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

              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: colorScheme.primary,
                  title: Text(
                    S.of(context).tenantDashboard_1,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
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
                      userInfo.tenantName ?? "",
                      'Tenant Dashboard', userInfo.userType ?? ''
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
                                  S.of(context).quickActions,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 1.1,
                              ),
                              delegate: SliverChildListDelegate([
                                _buildActionCard(
                                  context,
                                  icon: Icons.add_circle_outline,
                                  title: S.of(context).createComplaint,
                                  color: Colors.blue,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/create_complain-screen');
                                  },
                                ),
                                _buildActionCard(
                                  context,
                                  icon: Icons.pending_actions,
                                  title: S.of(context).issueList,
                                  color: Colors.orange,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/complain-list-screen');
                                  },
                                ),
                                _buildActionCard(
                                  context,
                                  icon: Icons.check_circle_outline,
                                  title: S.of(context).resolvedList,
                                  color: Colors.green,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/complain-completed-list-screen');
                                  },
                                ),
                                _buildActionCard(
                                  context,
                                  icon: Icons.cancel_outlined,
                                  title: S.of(context).declinedList,
                                  color: Colors.red,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/complain-declined-list-screen');
                                  },
                                ),
                              ]),
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
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    userInfo.tenantName?.isNotEmpty == true
                        ? userInfo.tenantName![0].toUpperCase()
                        : 'T',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
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
                      userInfo.tenantName ?? 'Tenant',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).tenant,
                      style: TextStyle(
                        color: Colors.black54,
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tenant ID: ${userInfo.tenantID ?? 'Not Available'}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14,
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

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).recentActivity,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                title: 'Complaint Created',
                description: 'Water leakage in bathroom',
                dateTime: 'Today, 9:30 AM',
                iconData: Icons.add_circle_outline,
                iconColor: Colors.blue,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                title: 'Complaint Resolved',
                description: 'AC not working properly',
                dateTime: 'Yesterday, 4:15 PM',
                iconData: Icons.check_circle_outline,
                iconColor: Colors.green,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                title: 'Maintenance Scheduled',
                description: 'Kitchen cabinet repair',
                dateTime: '2 days ago',
                iconData: Icons.calendar_today,
                iconColor: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String dateTime,
    required IconData iconData,
    required Color iconColor,
  }) {
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            dateTime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}