import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:rental_service/data/model/technician/assigned_task_model.dart';
import 'package:rental_service/presentation/dashboard/technicians/bloc/assigned_tasks_cubit.dart';
import 'package:rental_service/presentation/technician/build_phone_row.dart';
import 'package:rental_service/presentation/image_gallery/get_image_state_cubit.dart';
import 'package:rental_service/presentation/image_gallery/get_image_state.dart';
import 'package:rental_service/presentation/widgets/image_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/drawer.dart';
import '../../widgets/notification_icon_button.dart';
import '../bloc/user_info_cubit.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _expandedComplaints = {}; // Track expanded state for each complaint

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<AssignedTasksCubit>().state;
      if (state is AssignedTasksLoadedState && state.hasMore && !state.isLoadingMore) {
        context.read<AssignedTasksCubit>().loadMoreTasks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo()),
        BlocProvider(create: (context) => AssignedTasksCubit()..loadInitialTasks()),
        BlocProvider(create: (context) => GetComplainImagesCubit()),
      ],
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
                        userInfo.employeeName ?? "",
                        userInfo.employeeName ?? '', userInfo.userType ?? ''
                    );
                  },
                ),
                body: SafeArea(
                  child: BlocBuilder<UserInfoCubit, UserInfoModel>(
                    builder: (context, userInfo) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<AssignedTasksCubit>().loadInitialTasks();
                        },
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: _buildProfileSection(context, userInfo),
                            ),
                            SliverToBoxAdapter(
                              child: _buildTasksList(context),
                            ),
                          ],
                        ),
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
                      userInfo.employeeName ?? 'Technician',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Verified Technician",
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
                    'Technician ID: ${userInfo.technicianID ?? 'Not Available'}',
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

  Widget _buildTasksList(BuildContext context) {
    return BlocBuilder<AssignedTasksCubit, AssignedTasksState>(
      builder: (context, state) {
        if (state is AssignedTasksLoadingState) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AssignedTasksErrorState) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AssignedTasksCubit>().loadInitialTasks();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AssignedTasksLoadedState) {
          if (state.tasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No assigned tasks found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                child: Text(
                  'Assigned Tasks',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.tasks.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.tasks.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final task = state.tasks[index];
                  return _buildTaskCard(context, task);
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, AssignedTaskModel task) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Name
            if (task.propertyName != null && task.propertyName!.isNotEmpty)
              Text(
                task.propertyName!,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 8),
            // Property Address
            if (task.propertyAddress != null && task.propertyAddress!.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      task.propertyAddress!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            // Complaint
            if (task.complainName != null && task.complainName!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.description, size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.complainName!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          maxLines: _expandedComplaints[task.complainID ?? ''] == true ? null : 2,
                          overflow: _expandedComplaints[task.complainID ?? ''] == true
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (task.complainName!.length > 100) // Only show button if text is long
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 20.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            final key = task.complainID ?? '';
                            _expandedComplaints[key] = !(_expandedComplaints[key] ?? false);
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          _expandedComplaints[task.complainID ?? ''] == true
                              ? 'View Less'
                              : 'View More',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 8),
            // Contact Number
            if (task.propertyContact != null && task.propertyContact!.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    task.propertyContact!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Image Button
                if (task.imageCount != null && task.imageCount! > 0)
                  IconButton(
                    icon: const Icon(Icons.image),
                    color: colorScheme.primary,
                    onPressed: () => _handleImage(context, task),
                    tooltip: 'View Images',
                  ),
                // Call Button
                if (task.propertyContact != null && task.propertyContact!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone),
                    color: colorScheme.primary,
                    onPressed: () => PhoneUtils.makePhoneCall(task.propertyContact!, context),
                    tooltip: 'Call',
                  ),
                // Email Button
                if (task.emailAddress != null && task.emailAddress!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.email),
                    color: colorScheme.primary,
                    onPressed: () => PhoneUtils.sendEmail(task.emailAddress!, context),
                    tooltip: 'Email',
                  ),
                // Resolve Button (Placeholder)
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement resolve functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resolve functionality will be implemented later')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Resolve',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleImage(BuildContext context, AssignedTaskModel task) {
    // Get the cubit instance
    final imagesCubit = context.read<GetComplainImagesCubit>();

    // Reset state BEFORE starting new fetch to ensure clean slate
    imagesCubit.resetState();

    late StreamSubscription subscription;

    // Show loading indicator with text and cancel button
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Platform.isIOS
                ? const CupertinoActivityIndicator(radius: 15.0)
                : const CircularProgressIndicator(
                    strokeWidth: 4.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
            const SizedBox(height: 16),
            Text(
              S.of(context).loadingImages,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Cancel the subscription and close dialog
                subscription.cancel();
                Navigator.of(context).pop();

                // Reset state after cancellation to clean up any partial data
                imagesCubit.resetState();

                // Optionally show a cancellation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image loading cancelled'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );

    // Fetch images
    if (task.complainID != null && task.agencyID.isNotEmpty) {
      imagesCubit.fetchComplainImages(
        complainID: task.complainID!,
        agencyID: task.agencyID,
      );

      subscription = imagesCubit.stream.listen((state) {
        // Always dismiss loading dialog first
        Navigator.of(context).pop();

        if (state is GetComplainImagesSuccessState) {
          // Pass the ComplainImageModel list directly
          showImageDialog(context, state.images);

          // Cancel subscription after successful completion
          subscription.cancel();
        } else if (state is GetComplainImagesFailureState) {
          // Reset state on error to clean up
          imagesCubit.resetState();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
          // Cancel subscription after error
          subscription.cancel();
        }
      }, cancelOnError: true);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint ID or Agency ID not available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}