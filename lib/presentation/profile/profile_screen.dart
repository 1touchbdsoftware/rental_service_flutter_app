import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';

import '../dashboard/bloc/user_info_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<UserInfoCubit>().loadUserInfo();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<UserInfoCubit, UserInfoModel>(
        builder: (context, userInfo) {
          if (_isLoading && userInfo.userName == 'Loading...') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return _buildProfileContent(context, userInfo);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserInfoModel userInfo) {
    return RefreshIndicator(
      onRefresh: _loadUserInfo,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(context, userInfo),
              const SizedBox(height: 24),

              // User Type Badge
              _buildUserTypeBadge(context, userInfo),
              const SizedBox(height: 24),

              // Contact Information
              _buildContactSection(context, userInfo),
              const SizedBox(height: 24),

              // Role-specific Information
              _buildRoleSpecificSection(context, userInfo),
              const SizedBox(height: 24),

              // Additional Information
              _buildAdditionalInfoSection(context, userInfo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserInfoModel userInfo) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              userInfo.userName.isNotEmpty ? userInfo.userName[0].toUpperCase() : '?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      userInfo.isActive ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: userInfo.isActive
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userInfo.isActive ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeBadge(BuildContext context, UserInfoModel userInfo) {
    final isLandlord = userInfo.userType?.toUpperCase() == 'LANDLORD';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLandlord
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLandlord ? Icons.business : Icons.home,
            size: 16,
            color: isLandlord
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            userInfo.userType!.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isLandlord
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, UserInfoModel userInfo) {
    return _buildSection(
      context,
      title: 'Contact Information',
      icon: Icons.contact_phone,
      children: [
        _buildInfoTile(
          context,
          icon: Icons.email,
          title: 'Email',
          subtitle: userInfo.emailAddress,
        ),
        _buildInfoTile(
          context,
          icon: Icons.phone,
          title: 'Phone',
          subtitle: userInfo.contactNumber,
        ),
      ],
    );
  }

  Widget _buildRoleSpecificSection(BuildContext context, UserInfoModel userInfo) {
    final isLandlord = userInfo.userType?.toUpperCase() == 'LANDLORD';

    if (isLandlord) {
      return _buildSection(
        context,
        title: 'Landlord Information',
        icon: Icons.business,
        children: [
          if (userInfo.landlordID != null && userInfo.landlordID!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.badge,
              title: 'Landlord ID',
              subtitle: userInfo.landlordID!,
            ),
          if (userInfo.landlordName != null && userInfo.landlordName!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.person,
              title: 'Landlord Name',
              subtitle: userInfo.landlordName!,
            ),
        ],
      );
    } else {
      return _buildSection(
        context,
        title: 'Tenant Information',
        icon: Icons.home,
        children: [
          if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.badge,
              title: 'Tenant ID',
              subtitle: userInfo.tenantID!,
            ),
          if (userInfo.tenantName != null && userInfo.tenantName!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.person,
              title: 'Tenant Name',
              subtitle: userInfo.tenantName!,
            ),
          if (userInfo.propertyID != null && userInfo.propertyID!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.location_on,
              title: 'Property ID',
              subtitle: userInfo.propertyID!,
            ),
          if (userInfo.propertyName != null && userInfo.propertyName!.isNotEmpty)
            _buildInfoTile(
              context,
              icon: Icons.apartment,
              title: 'Property Name',
              subtitle: userInfo.propertyName!,
            ),
        ],
      );
    }
  }

  Widget _buildAdditionalInfoSection(BuildContext context, UserInfoModel userInfo) {
    return _buildSection(
      context,
      title: 'Additional Information',
      icon: Icons.info,
      children: [
        _buildInfoTile(
          context,
          icon: Icons.business_center,
          title: 'Agency ID',
          subtitle: userInfo.agencyID,
        ),
        // _buildInfoTile(
        //   context,
        //   icon: Icons.how_to_reg,
        //   title: 'Registration Type',
        //   subtitle: userInfo.registrationType,
        // ),
        if (userInfo.tenantInfoID != null && userInfo.tenantInfoID!.isNotEmpty)
          _buildInfoTile(
            context,
            icon: Icons.assignment,
            title: 'Tenant Info ID',
            subtitle: userInfo.tenantInfoID!,
          ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle.isEmpty ? 'Not provided' : subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: subtitle.isEmpty
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : Theme.of(context).colorScheme.onSurface,
          fontStyle: subtitle.isEmpty ? FontStyle.italic : null,
        ),
      ),
    );
  }
}