import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../domain/entities/complain_entity.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/signin.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../history/complain_history_screen.dart';
import '../image_gallery/get_image_state.dart';
import '../image_gallery/get_image_state_cubit.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/paging_controls.dart';
import 'bloc/get_complains_state.dart';
import 'bloc/get_complains_state_cubit.dart';

class ComplainsDeclinedListScreen extends StatelessWidget {
  const ComplainsDeclinedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetComplainsCubit()),
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())),
      ],
      child: const ComplainsDeclinedListContent(),
    );
  }
}

class ComplainsDeclinedListContent extends StatefulWidget {
  const ComplainsDeclinedListContent({super.key});

  @override
  State<ComplainsDeclinedListContent> createState() => _ComplainsDeclinedListContentState();
}

class _ComplainsDeclinedListContentState extends State<ComplainsDeclinedListContent> {
  String _tenantName = "Tenant";
  String _userType = "";

  @override
  void initState() {
    super.initState();
    // Load user info when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoCubit>().loadUserInfo();
    });
  }

  void _fetchComplaints(UserInfoModel userInfo) {
    if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
      final params = _prepareComplainsParams(userInfo);
      context.read<GetComplainsCubit>().fetchComplains(params: params);
    }
  }

  GetComplainsParams _prepareComplainsParams(UserInfoModel userInfo) {
    return GetComplainsParams(
      agencyID: userInfo.agencyID,
      tenantID: userInfo.tenantID ?? '',
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      pageNumber: 1,
      pageSize: 10,
      isActive: true,
      flag: 'TENANT',
      tab: 'DECLINED',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for better theming
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MultiBlocListener(
      listeners: [
        // Listen to authentication state changes
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignInPage()),
                    (Route<dynamic> route) => false,
              );
            }
          },
        ),
        // Listen to user info changes
        BlocListener<UserInfoCubit, UserInfoModel>(
          listenWhen: (previous, current) {
            // Only respond when the tenantID actually changes from empty to non-empty
            return previous.tenantID != current.tenantID &&
                current.tenantID != null &&
                current.tenantID!.isNotEmpty;
          },
          listener: (context, userInfo) {
            setState(() {
              _tenantName = userInfo.tenantName ?? "Tenant";
              _userType = userInfo.userType ?? '';
            });
            _fetchComplaints(userInfo);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            S.of(context).declinedComplaints,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        drawer: buildAppDrawer(
          context,
          _tenantName,
            S.of(context).tenantDashboard_1,
            _userType
        ),
        body: RefreshIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          onRefresh: () async {
            final userInfo = context.read<UserInfoCubit>().state;
            if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
              _fetchComplaints(userInfo);
            } else {
              await context.read<UserInfoCubit>().loadUserInfo();
            }
          },
          child: BlocBuilder<GetComplainsCubit, GetComplainsState>(
            builder: (context, state) {
              // Handle no internet state first
              if (state is GetComplainsNoInternetState) {
                return NoInternetWidget(
                  onRetry: () async {
                    final userInfo = context.read<UserInfoCubit>().state;
                    _fetchComplaints(userInfo);
                  },
                );
              }

              if (state is GetComplainsInitialState) {
                return CenterLoaderWithText(text: S.of(context).loadingDeclinedComplaints);
              } else if (state is GetComplainsLoadingState) {
                return CenterLoaderWithText(text: S.of(context).loadingDeclinedComplaints);
              } else if (state is GetComplainsFailureState) {
                return _buildErrorView(context, state.errorMessage, colorScheme);
              } else if (state is GetComplainsSuccessState) {
                return _buildComplaintsList(context, state, colorScheme, textTheme);
              }

              // Fallback for any unexpected state
              return CenterLoaderWithText(text: S.of(context).loadingDeclinedComplaints);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final userInfo = context.read<UserInfoCubit>().state;
            _fetchComplaints(userInfo);
          },
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $errorMessage',
            style: TextStyle(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final userInfo = context.read<UserInfoCubit>().state;
              _fetchComplaints(userInfo);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsList(
      BuildContext context,
      GetComplainsSuccessState state,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    final complaints = state.response.data.list;
    final pagination = state.response.data.pagination;

    if (complaints.isEmpty) {
      return Center(
        child: Text(
          'No Declined Complaints to Show',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.blue,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: complaints.length + 1, // +1 for pagination
      itemBuilder: (context, index) {
        if (index < complaints.length) {
          final complaint = complaints[index];
          return ComplainCard(
            complaint: complaint,
            onEditPressed: () => _handleEdit(context, complaint),
            onHistoryPressed: () => _handleHistory(context, complaint),
            onCommentsPressed: () => _handleComments(context, complaint.lastComments),
            onReadMorePressed: () => _handleReadMore(context, complaint.complainName),
            onImagePressed: () => handleImage(context, complaint),
            // These actions are disabled for declined complaints
            onReschedulePressed: () {},
            onCompletePressed: () {},
            onResubmitPressed: () {},
            onAcceptPressed: () {},
            userType: _userType, onApprovePressed: () {  }, onDeclinePressed: () {  },
          );
        } else {
          // Pagination widget at the end of the list
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PaginationControls(
              currentPage: pagination.pageNumber,
              totalPages: pagination.totalPages,
              onPageChanged: (page) async {
                final userInfo = context.read<UserInfoCubit>().state;
                final updatedParams = GetComplainsParams(
                  agencyID: userInfo.agencyID,
                  tenantID: userInfo.tenantID ?? '',
                  landlordID: userInfo.landlordID ?? '',
                  propertyID: userInfo.propertyID ?? '',
                  pageNumber: page,
                  pageSize: 10,
                  isActive: true,
                  flag: 'TENANT',
                  tab: 'DECLINED',
                );
                context.read<GetComplainsCubit>().fetchComplains(params: updatedParams);
              },
            ),
          );
        }
      },
    );
  }


  void handleImage(BuildContext context, ComplainEntity complaint) {
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
            Platform.isIOS ? CupertinoActivityIndicator(radius:15.0) : CircularProgressIndicator(
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black,)),
            const SizedBox(height: 16),
            Text(
              S.of(context).loadingImages,
              style: TextStyle(fontSize: 16),
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
    imagesCubit.fetchComplainImages(
      complainID: complaint.complainID,
      agencyID: complaint.agencyID!,
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
  }

  // Handler functions
  void _handleHistory(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ComplaintHistoryScreen(
          complainID: complaint.complainID,
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, ComplainEntity complaint) {
    // For declined complaints, editing might require special handling

  }

  void _handleComments(BuildContext context, String? comment) {
    showDialog(
      context: context,
      builder: (context) => SimpleInfoDialog(
        title: S.of(context).lastComment,
        bodyText: comment ?? S.of(context).noComments,
      ),
    );
  }

  void _handleReadMore(BuildContext context, String? complainName) {
    showDialog(
      context: context,
      builder: (context) => SimpleInfoDialog(
        title: S.of(context).complaintDetails,
        bodyText: complainName ?? S.of(context).noDetailsProvided,
      ),
    );
  }
}