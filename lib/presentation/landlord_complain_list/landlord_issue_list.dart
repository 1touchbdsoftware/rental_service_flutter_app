import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../history/complain_history_screen.dart';
import '../tenant_complain_list/bloc/get_complains_state.dart';
import '../tenant_complain_list/bloc/get_complains_state_cubit.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/paging_controls.dart';

class LandlordIssueListScreen extends StatelessWidget {
  const LandlordIssueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetComplainsCubit()),
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())),
      ],
      child: const LandlordIssueListContent(),
    );
  }
}

class LandlordIssueListContent extends StatefulWidget {
  const LandlordIssueListContent({super.key});

  @override
  State<LandlordIssueListContent> createState() => _LandlordIssueListContentState();
}

class _LandlordIssueListContentState extends State<LandlordIssueListContent> {
  String _landlordName = "Landlord";

  @override
  void initState() {
    super.initState();
    // Load user info when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoCubit>().loadUserInfo();
    });
  }

  void _fetchComplaints(UserInfoModel userInfo) {
    // Check if landlordID exists before fetching
    if (userInfo.landlordID != null && userInfo.landlordID!.isNotEmpty) {
      final params = _prepareComplainsParams(userInfo);
      print("Fetching complaints with params: AgencyID: ${params.agencyID}, LandlordID: ${params.landlordID}, Flag: ${params.flag}");
      context.read<GetComplainsCubit>().fetchComplains(params: params);
    } else {
      print("LandlordID is null or empty, cannot fetch complaints");
    }
  }

  GetComplainsParams _prepareComplainsParams(UserInfoModel userInfo) {
    return GetComplainsParams(
      agencyID: userInfo.agencyID,
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      pageNumber: 1,
      pageSize: 10,
      isActive: true, // Add this as it might be required
      flag: 'LANDLORD',
      tab: 'PROBLEM',
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
            // Fixed: Check landlordID instead of tenantID for landlord screen
            return previous.landlordID != current.landlordID &&
                current.landlordID != null &&
                current.landlordID!.isNotEmpty;
          },
          listener: (context, userInfo) {
            print("User info loaded: LandlordID: ${userInfo.landlordID}, LandlordName: ${userInfo.landlordName}");
            setState(() {
              _landlordName = userInfo.landlordName ?? "Landlord";
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
            'Pending Complaints',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        drawer: buildAppDrawer(
          context,
          _landlordName,
          'Landlord Dashboard',
        ),
        body: RefreshIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          onRefresh: () async {
            final userInfo = context.read<UserInfoCubit>().state;
            if (userInfo.landlordID != null && userInfo.landlordID!.isNotEmpty) {
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
                return const CenterLoaderWithText(text: "Loading Pending Complaints...");
              } else if (state is GetComplainsLoadingState) {
                return const CenterLoaderWithText(text: "Loading Pending Complaints...");
              } else if (state is GetComplainsFailureState) {
                return _buildErrorView(context, state.errorMessage, colorScheme);
              } else if (state is GetComplainsSuccessState) {
                return _buildComplaintsList(context, state, colorScheme, textTheme);
              }

              // Fallback for any unexpected state
              return const CenterLoaderWithText(text: "Loading Pending Complaints...");
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
          'No Pending Complaints to Show',
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
            onImagePressed: (imgIndex) {
              final imageList = complaint.images!.map((img) => img.file).toList();
              showImageDialog(context, imageList, imgIndex);
            },
            // Landlord actions - you may want to enable some of these
            onReschedulePressed: () => _handleReschedule(context, complaint),
            onCompletePressed: () => _handleComplete(context, complaint),
            onResubmitPressed: () => _handleResubmit(context, complaint),
            onAcceptPressed: () => _handleAccept(context, complaint),
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
                  landlordID: userInfo.landlordID ?? '',
                  propertyID: userInfo.propertyID ?? '',
                  pageNumber: page, // Fixed: Use the actual page parameter
                  pageSize: 10,
                  isActive: true,
                  flag: 'LANDLORD',
                  tab: 'PROBLEM',
                );
                context.read<GetComplainsCubit>().fetchComplains(params: updatedParams);
              },
            ),
          );
        }
      },
    );
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
    // Landlord edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality for landlord coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleComments(BuildContext context, String? comment) {
    showDialog(
      context: context,
      builder: (context) => SimpleInfoDialog(
        title: 'Last Comments',
        bodyText: comment ?? 'No comments available',
      ),
    );
  }

  void _handleReadMore(BuildContext context, String? complainName) {
    showDialog(
      context: context,
      builder: (context) => SimpleInfoDialog(
        title: 'Complaint Details',
        bodyText: complainName ?? 'No details provided.',
      ),
    );
  }

  void _handleReschedule(BuildContext context, ComplainEntity complaint) {
    // Landlord reschedule functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reschedule functionality coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleComplete(BuildContext context, ComplainEntity complaint) {
    // Landlord complete functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete functionality coming soon'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleResubmit(BuildContext context, ComplainEntity complaint) {
    // Landlord resubmit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resubmit functionality coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleAccept(BuildContext context, ComplainEntity complaint) {
    // Landlord accept functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accept functionality coming soon'),
        backgroundColor: Colors.green,
      ),
    );
  }
}