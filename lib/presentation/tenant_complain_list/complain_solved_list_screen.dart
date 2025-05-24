import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rental_service/presentation/widgets/no_internet_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../history/complain_history_screen.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/paging_controls.dart';
import 'bloc/get_complains_state.dart';
import 'bloc/get_complains_state_cubit.dart';

class ComplainsCompletedListScreen extends StatelessWidget {
  const ComplainsCompletedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetComplainsCubit()),
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())),
      ],
      child: const ComplainsListContent(),
    );
  }
}

class ComplainsListContent extends StatefulWidget {
  const ComplainsListContent({super.key});

  @override
  State<ComplainsListContent> createState() => _ComplainsListContentState();
}

class _ComplainsListContentState extends State<ComplainsListContent> {
  String _tenantName = "Tenant";

  @override
  void initState() {
    super.initState();
    // Load user info when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoCubit>().loadUserInfo();
    });
  }

  Future<bool> _checkInternetConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
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
      tab: 'SOLVED',
    );
  }

  Future<void> _fetchComplainsWithConnectionCheck(BuildContext context) async {
    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      return;
    }

    final userInfo = context.read<UserInfoCubit>().state;
    _fetchComplaints(userInfo);
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
            'Solved Complaints',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        drawer: buildAppDrawer(
          context,
          _tenantName,
          'Tenant Dashboard',
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
                return const CenterLoaderWithText(text: "Loading Solved Complaints...");
              } else if (state is GetComplainsLoadingState) {
                return const CenterLoaderWithText(text: "Loading Solved Complaints...");
              } else if (state is GetComplainsFailureState) {
                return _buildErrorView(context, state.errorMessage, colorScheme);
              } else if (state is GetComplainsSuccessState) {
                return _buildComplaintsList(context, state, colorScheme, textTheme);
              }

              // Fallback for any unexpected state
              return const CenterLoaderWithText(text: "Loading Solved Complaints...");
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _fetchComplainsWithConnectionCheck(context);
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
              await _fetchComplainsWithConnectionCheck(context);
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
          'No Solved Complaints to Show',
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
            onImagePressed: () {

            },
            // These actions are disabled for solved complaints
            onReschedulePressed: () {},
            onCompletePressed: () {},
            onResubmitPressed: () {},
            onAcceptPressed: () {},
          );
        } else {
          // Pagination widget at the end of the list
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PaginationControls(
              currentPage: pagination.pageNumber,
              totalPages: pagination.totalPages,
              onPageChanged: (page) async {
                final hasConnection = await _checkInternetConnection();
                if (!hasConnection) {
                  return;
                }

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
                  tab: 'SOLVED',
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
    // For solved complaints, editing might not be allowed
    // You can show a message or navigate to a read-only view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cannot edit solved complaints'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleComments(BuildContext context, String? comment) {
    showDialog(
      context: context,
      builder: (context) => SimpleInfoDialog(
        title: 'Last Comment Details',
        bodyText: comment ?? 'No Comments Yet',
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
}