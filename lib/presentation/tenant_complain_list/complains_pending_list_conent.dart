import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rental_service/data/model/complain/complain_req_params/get_complain_req_params.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:rental_service/presentation/history/complain_history_screen.dart';
import 'package:rental_service/presentation/technician/accept_technician_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/presentation/edit_complain/edit_complain_screen.dart';
import '../../common/bloc/auth/auth_cubit.dart';
import '../../data/model/complain/complain_req_params/completed_post_req.dart';
import '../../domain/entities/complain_entity.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/signin.dart';
import '../budget/budget_details.dart';
import '../create_complain/bloc/complain_state.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../image_gallery/get_image_state.dart';
import '../image_gallery/get_image_state_cubit.dart';
import '../resubmit/resubmit_form_screen.dart';
import '../technician/technician_rechedule_screen.dart';
import '../widgets/center_loader.dart';
import '../widgets/comment_and_accept_dialog.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/notification_icon_button.dart';
import '../widgets/paging_controls.dart';
import 'bloc/get_complains_state_cubit.dart';
import '../../service_locator.dart';
import 'bloc/mark_as_complete_state_cubit.dart';

class ComplainsListContent extends StatefulWidget {
  const ComplainsListContent({super.key});

  @override
  State<ComplainsListContent> createState() => _ComplainsListContentState();
}

class _ComplainsListContentState extends State<ComplainsListContent> {
  String _tenantName = "Tenant";
  String _userType = '';
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Load user info immediately when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfoAndFetchComplaints();
    });
  }

  Future<void> _loadUserInfoAndFetchComplaints() async {
    try {
      // Load user info first
      await context.read<UserInfoCubit>().loadUserInfo();

      // The BlocListener will handle fetching complaints once user info is loaded
    } catch (e) {
      print('Error loading user info: $e');
      // Handle error if needed
    }
  }

  void _fetchComplaints(UserInfoModel userInfo, {int pageNumber = 1}) {
    if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
      final params = _prepareComplainsParams(userInfo, pageNumber: pageNumber);
      print('Fetching complaints for tenant: ${userInfo.tenantID}, page: $pageNumber');
      context.read<GetComplainsCubit>().fetchComplains(params: params);
    } else {
      print('Cannot fetch complaints: tenantID is null or empty');
    }
  }

  GetComplainsParams _prepareComplainsParams(UserInfoModel userInfo, {int pageNumber = 1}) {
    return GetComplainsParams(
      agencyID: userInfo.agencyID,
      tenantID: userInfo.tenantID ?? '',
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      pageNumber: pageNumber,
      pageSize: 10,
      isActive: true,
      flag: 'TENANT',
      tab: 'PROBLEM',
    );
  }

  Future<void> _handleRefresh() async {
    final userInfo = context.read<UserInfoCubit>().state;

    // Check if user info is properly loaded
    if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
      _fetchComplaints(userInfo);
    } else {
      // If user info is not available, reload it first
      await _loadUserInfoAndFetchComplaints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MarkComplainCompletedCubit()),
        BlocProvider(create: (_) => GetComplainImagesCubit()),
      ],
      child: Builder(
        builder: (context) => MultiBlocListener(
          listeners: [
            // Authentication listener
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

            // User info listener - improved logic
            BlocListener<UserInfoCubit, UserInfoModel>(
              listenWhen: (previous, current) {
                // Listen to any meaningful change in user info
                return (previous.tenantID != current.tenantID ||
                    previous.tenantName != current.tenantName ||
                    previous.agencyID != current.agencyID) &&
                    current.tenantID != null &&
                    current.tenantID!.isNotEmpty;
              },
              listener: (context, userInfo) {
                print('User info updated: TenantID: ${userInfo.tenantID}, TenantName: ${userInfo.tenantName}');

                setState(() {
                  _tenantName = userInfo.tenantName ?? "Tenant";
                  _userType = userInfo.userType ?? '';
                });

                // Fetch complaints when user info is loaded
                if (_isInitialLoad || userInfo.tenantID != null) {
                  _fetchComplaints(userInfo);
                  _isInitialLoad = false;
                }
              },
            ),

            // Mark complete listener
            BlocListener<MarkComplainCompletedCubit, ComplainState>(
              listener: (context, state) {
                if (state is ComplainSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Complaint marked as complete'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Refresh the complaints list
                  _handleRefresh();
                } else if (state is ComplainError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: _buildScaffold(context),
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          S.of(context).pendingComplaints,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          NotificationIconButton(),
        ],
      ),
      drawer: buildAppDrawer(
        context,
        _tenantName,
          S.of(context).tenantDashboard_1, _userType
      ),
      body: RefreshIndicator(
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        onRefresh: _handleRefresh,
        child: _buildBody(context, colorScheme, textTheme),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleRefresh,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return BlocBuilder<UserInfoCubit, UserInfoModel>(
      builder: (context, userInfoState) {
        // Show loading if user info is not loaded yet
        if (userInfoState.tenantID == null || userInfoState.tenantID!.isEmpty) {
          return const CenterLoaderWithText(text: "Loading User Info...");
        }

        // Once user info is loaded, show complaints
        return BlocBuilder<GetComplainsCubit, GetComplainsState>(
          builder: (context, complainsState) {
            // Handle no internet state
            if (complainsState is GetComplainsNoInternetState) {
              return NoInternetWidget(
                onRetry: () => _fetchComplaints(userInfoState),
              );
            }

            // Handle different complaint states
            if (complainsState is GetComplainsInitialState) {
              return CenterLoaderWithText(text: S.of(context).loadingComplaints);
            } else if (complainsState is GetComplainsLoadingState) {
              return CenterLoaderWithText(text: S.of(context).loadingComplaints);
            } else if (complainsState is GetComplainsFailureState) {
              return _buildErrorView(context, complainsState.errorMessage, colorScheme, userInfoState);
            } else if (complainsState is GetComplainsSuccessState) {
              return _buildComplaintsList(context, complainsState, colorScheme, textTheme, userInfoState);
            }

            // Fallback
            return CenterLoaderWithText(text: S.of(context).loadingComplaints);
          },
        );
      },
    );
  }

  Widget _buildErrorView(
      BuildContext context,
      String errorMessage,
      ColorScheme colorScheme,
      UserInfoModel userInfo,
      ) {
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
            onPressed: () => _fetchComplaints(userInfo),
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
      UserInfoModel userInfo,
      ) {
    final complaints = state.response.data.list;
    final pagination = state.response.data.pagination;

    if (complaints.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noComplaintsToShow,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.primary,
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
            onCompletePressed: () => _handleComplete(context, complaint),
            onResubmitPressed: () => _handleResubmit(context, complaint),
            onAcceptPressed: () => _handleAccept(context, complaint),
            onImagePressed: () => handleImage(context, complaint),
            onReschedulePressed: () => _handleReschedule(context, complaint),
            onBudgetPressed: ()=> _handleBudgetClick(context, complaint),
            userType: _userType, onApprovePressed: () {  }, onDeclinePressed: () {  },
          );
        } else {
          // Pagination widget at the end of the list
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PaginationControls(
              currentPage: pagination.pageNumber,
              totalPages: pagination.totalPages,
              onPageChanged: (page) => _fetchComplaints(userInfo, pageNumber: page),
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

  // Handler functions remain the same
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


  // Handler for budget
  void _handleBudgetClick(BuildContext context, ComplainEntity complain) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => EstimatedBudgetScreen( complain: complain,
        ),
      ),
    );
  }

  void _handleComplete(BuildContext context, ComplainEntity complain) {

    CommentDialog.show(
      context: context,
      title: 'Ticket#',
      ticketNo: complain.ticketNo!,
      labelText:  S.of(context).pleaseWriteAComment,
      hintText:  S.of(context).commentText,
      actionButtonText:  S.of(context).markAsComplete,
      actionButtonColor: Colors.greenAccent,
      onSubmitted: (comment) async {
        _markTicketAsComplete(
          context,
          complain,
          comment
        );
      },
    );
  }

  void _markTicketAsComplete(BuildContext context, ComplainEntity complain, String comments) {
    final userInfo = context.read<UserInfoCubit>().state;

    final request = ComplainCompletedRequest(
      complainID: complain.complainID,
      isCompleted: true,
      updatedBy: userInfo.tenantID ?? 'Tenant',
      agencyID: userInfo.agencyID,
      feedback: comments,
      currentComments: comments,
    );

    context.read<MarkComplainCompletedCubit>().markAsCompleted(request);
  }

  void _handleReschedule(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AssignedTechnicianScreen(complaint: complaint),
      ),
    );
  }

  void _handleAccept(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AcceptTechnicianScreen(complaint: complaint),
      ),
    );
  }

  void _handleResubmit(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ResubmitFormScreen(complaint: complaint),
      ),
    );
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

  void _handleEdit(BuildContext context, ComplainEntity complain) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => EditComplainScreen(existingComplain: complain),
      ),
    );
  }
}