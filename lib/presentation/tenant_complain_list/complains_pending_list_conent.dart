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
import '../auth/signin.dart';
import '../create_complain/bloc/complain_state.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../resubmit/resubmit_form_screen.dart';
import '../technician/technician_rechedule_screen.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/no_internet_widget.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoCubit>().loadUserInfo();
    });
    // so we can access BLoC properly
  }

  void _fetchComplaints(UserInfoModel userInfo) {
    if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
      final params = _prepareComplainsParams(userInfo);
      context.read<GetComplainsCubit>().fetchComplains(params: params);
    }
  }

  Future<bool> _checkInternetConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }



  GetComplainsParams _prepareComplainsParams(UserInfoModel userInfo) {
    return GetComplainsParams(
      agencyID: userInfo.agencyID,
      tenantID: userInfo.tenantID ?? '',
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      pageNumber: 1,
      pageSize: 2,
      isActive: true,
      flag: 'TENANT',
      tab: 'PROBLEM',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MarkComplainCompletedCubit()),
      ],
      child: Builder(
        builder: (context) => MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  // Navigate to login screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignInPage()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
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
            BlocListener<MarkComplainCompletedCubit, ComplainState>(
              listener: (context, state) {
                if (state is ComplainSuccess) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Complaint marked as complete'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Refresh the complaints list
                  final userInfo = context.read<UserInfoCubit>().state;
                  _fetchComplaints(userInfo);
                } else if (state is ComplainError) {
                  // Show error message
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
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          'Pending Complaints',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      drawer: buildAppDrawer(
          context,
          _tenantName,
          'Tenant Dashboard'
      ),
      body: RefreshIndicator(
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        onRefresh: () async {
          final userInfo = context.read<UserInfoCubit>().state;
          if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
            final params = _prepareComplainsParams(userInfo);
            await context.read<GetComplainsCubit>().fetchComplains(params: params);
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
                  final params = await _prepareComplainsParams(userInfo);
                  context.read<GetComplainsCubit>().fetchComplains(params: params);
                },
              );
            }

            if (state is GetComplainsInitialState) {
              return const CenterLoaderWithText(text: "Loading Complains...");
            } else if (state is GetComplainsLoadingState) {
              return const CenterLoaderWithText(text: "Loading Complains...");
            } else if (state is GetComplainsFailureState) {
              return _buildErrorView(context, state.errorMessage, colorScheme);
            } else if (state is GetComplainsSuccessState) {
              return _buildComplaintsList(context, state, colorScheme, textTheme);
            }
            // Fallback for any unexpected state
            return const CenterLoaderWithText(text: "Loading Complains...");
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userInfo = context.read<UserInfoCubit>().state;
          _fetchComplaints(userInfo);
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        child: const Icon(Icons.refresh),
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
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
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
      TextTheme textTheme
      ) {
    final complaints = state.response.data.list;
    final pagination = state.response.data.pagination;

    if (complaints.isEmpty) {
      return Center(
        child: Text(
          'No complaints to Show',
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
            onImagePressed: (imgIndex) {
              final imageList = complaint.images!.map((img) => img.file).toList();
              showImageDialog(context, imageList, imgIndex);
            },
            onReschedulePressed: () => _handleReschedule(context, complaint),
          );
        } else {
          // Pagination widget at the end of the list
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PaginationControls(
              currentPage: pagination.pageNumber,
              totalPages: pagination.totalPages,
              onPageChanged: (page) {
                final userInfo = context.read<UserInfoCubit>().state;
                final updatedParams = GetComplainsParams(
                  agencyID: userInfo.agencyID,
                  tenantID: userInfo.tenantID ?? '',
                  landlordID: userInfo.landlordID ?? '',
                  propertyID: userInfo.propertyID ?? '',
                  pageNumber: page,
                  pageSize: 2,
                  isActive: true,
                  flag: 'TENANT',
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
            builder: (BuildContext context) => ComplaintHistoryScreen(complainID: complaint.complainID)
        )
    );
  }

  void _handleComplete(BuildContext context, ComplainEntity complain) {
    final TextEditingController completeCommentController = TextEditingController();

    // Create the dialog in a new context that has access to the cubit
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket#'),
            Text(complain.ticketNo!),
            const SizedBox(height: 8),
            const Divider(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide comments before completing the ticket:'),
            const SizedBox(height: 16),
            TextField(
              controller: completeCommentController,
              decoration: const InputDecoration(
                labelText: 'Completion Comments',
                border: OutlineInputBorder(),
                hintText: 'Describe the work done or resolution...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (completeCommentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Please provide comments')),
                );
                return;
              }

              // Call the markAsCompleted functionality - using the original context
              _markTicketAsComplete(
                context, // Use the original context that has the cubit
                complain,
                completeCommentController.text.trim(),
              );

              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Green color for complete action
            ),
            child: const Text('MARK AS COMPLETE'),
          ),
        ],
      ),
    );
  }

  void _markTicketAsComplete(BuildContext context, ComplainEntity complain, String comments) {
    // Get the current user information from the UserInfoCubit
    final userInfo = context.read<UserInfoCubit>().state;

    // Create the request model with the comments for both feedback and lastComments
    final request = ComplainCompletedRequest(
      complainID: complain.complainID,
      isCompleted: true,
      updatedBy: userInfo.tenantID ?? 'Tenant',
      agencyID: userInfo.agencyID,
      feedback: comments,     // Use the same comments for feedback
      currentComments: comments, // Use the same comments for lastComments
    );

    // Use the cubit from context
    context.read<MarkComplainCompletedCubit>().markAsCompleted(request);
  }

  void _handleReschedule(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => AssignedTechnicianScreen(complaint: complaint)
        )
    );
  }

  void _handleAccept(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => AcceptTechnicianScreen(complaint: complaint)
        )
    );
  }

  void _handleResubmit(BuildContext context, ComplainEntity complaint) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => ResubmitFormScreen(complaint: complaint)
        )
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

  void _handleEdit(BuildContext context, ComplainEntity complain) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => EditComplainScreen(existingComplain: complain)
        )
    );
  }
}