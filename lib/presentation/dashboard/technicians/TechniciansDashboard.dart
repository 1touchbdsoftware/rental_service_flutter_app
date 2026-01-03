import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/drawer.dart';
import '../../widgets/notification_icon_button.dart';
import '../bloc/user_info_cubit.dart';

class TechnicianDashboard extends StatelessWidget {
  const TechnicianDashboard({super.key});

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
                        "Technician Dashboard",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  actions: [
                    NotificationIconButton(),
                  ],
                ),
                drawer: BlocBuilder<UserInfoCubit, UserInfoModel>(
                  builder: (context, userInfo) {
                    return buildAppDrawer(
                        context,
                        userInfo.landlordName ?? "",
                        S.of(context).landlordDashboard_1, userInfo.userType ?? ''
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
                          // All other content below has been removed
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
                    userInfo.employeeName?.isNotEmpty == true
                        ? userInfo.employeeName![0].toUpperCase()
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
                      S.of(context).propertyOwner,
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
                    'Landlord ID: ${userInfo.technicianID ?? 'Not Available'}',
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
}