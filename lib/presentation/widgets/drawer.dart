import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';

import '../../core/localization/language_cubit.dart';
import '../../data/model/user/user_info_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../service_locator.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../profile/profile_screen.dart';

Widget buildAppDrawer(BuildContext context, String username,
    String dashboardTitle, String userType) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Drawer(
    backgroundColor: colorScheme.surface,
    child: Column(
      children: [
        // Enhanced Header with Gradient
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Logo with enhanced styling
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 80,
                      child: Image.asset(
                        'asset/images/pro_matrix_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.business,
                            size: 60,
                            color: Colors.white.withOpacity(0.8),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dashboard Title
                  Text(
                    dashboardTitle,
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userType,
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Menu Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Home
              _buildDrawerItem(
                context: context,
                icon: Icons.home_rounded,
                title: S.of(context).home,
                onTap: () {
                  Navigator.pop(context);
                  if (userType == "LANDLORD") {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/landlord-dashboard', (route) => false);
                  } else if (userType == "TENANT") {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/tenant-dashboard', (route) => false);
                  }
                },
              ),

              // Complaints List
              _buildDrawerItem(
                context: context,
                icon: Icons.assignment_rounded,
                title: S.of(context).complaintsList,
                onTap: () {
                  Navigator.pop(context);
                  if (userType == "LANDLORD") {
                    Navigator.pushNamed(context, '/landlord-issues-screen');
                  } else if (userType == "TENANT") {
                    Navigator.pushNamed(context, '/complain-list-screen');
                  }
                },
              ),

              const SizedBox(height: 8),
              _buildDivider(context),
              const SizedBox(height: 8),

              // Profile Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Profile
              _buildDrawerItem(
                context: context,
                icon: Icons.person_rounded,
                title: username,
                subtitle: 'View Profile',
                onTap: () {
                  // When navigating to the profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => UserInfoCubit(UserInfoModel.empty()),
                        child: const ProfilePage(),
                      ),
                    ),
                  );
                },
              ),

              // Settings
              _buildDrawerItem(
                context: context,
                icon: Icons.settings_rounded,
                title: S.of(context).settings,
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/settings');
                },
              ),

              // Language Selection
              _buildDrawerItem(
                context: context,
                icon: Icons.language_rounded,
                title: S.of(context).language,
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLanguageSelectionDialog(context);

                },
              ),

              const SizedBox(height: 16),
              _buildDivider(context),
              const SizedBox(height: 8),

              // Logout
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is UnAuthenticated) {
                    // Handle navigation if needed
                  } else if (state is AuthErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                  }
                },
                child: _buildDrawerItem(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: S.of(context).logout,
                  isDestructive: true,
                  onTap: () => showLogoutConfirmation(context),
                ),
              ),
            ],
          ),
        ),

        // App Version Footer
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Version 1.0.0',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem({
  required BuildContext context,
  required IconData icon,
  required String title,
  String? subtitle,
  Widget? trailing,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? colorScheme.errorContainer.withOpacity(0.3)
              : colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? colorScheme.error : colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: isDestructive ? colorScheme.error : colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );
}

Widget _buildDivider(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    height: 1,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.outline.withOpacity(0.1),
          Theme.of(context).colorScheme.outline.withOpacity(0.3),
          Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ],
      ),
    ),
  );
}

void _showLanguageSelectionDialog(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  // Get the localized strings before building the dialog
  final localizations = S.of(context);
  final currentLanguage = context.read<LanguageCubit>().state.languageCode;

  final languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'tr', 'name': 'Turkish', 'flag': '🇹🇷'},
    {'code': 'bn', 'name': 'Bengali', 'flag': '🇧🇩'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
  ];

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.language_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              localizations.selectLanguage, // Use the stored localization
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language['code'] == currentLanguage;

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Text(
                    language['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                  )
                      : null,
                  selected: isSelected,
                  selectedTileColor: colorScheme.primaryContainer.withOpacity(0.2),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(language['code']!);
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to ${language['name']}'),
                        backgroundColor: colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localizations.cancel, // Use the stored localization
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      );
    },
  );
}

void showLogoutConfirmation(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              S.of(context).confirmLogout,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          S.of(context).areYouSureYouWantToLogOutOfYourAccount,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cancel",
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
      S.of(context).logout,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().logOut(usecase: sl<LogoutUseCase>());
            },
          ),
        ],
      );
    },
  );
}