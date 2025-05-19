import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/complain/complain_req_params/get_complain_req_params.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:rental_service/presentation/history/complain_history_screen.dart';
import 'package:rental_service/presentation/technician/accept_technician_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/presentation/widgets/complain_form/edit_complain.dart';
import '../../common/bloc/auth/auth_cubit.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
import '../dashboard/bloc/user_cubit.dart';
import '../resubmit/resubmit_form_screen.dart';
import '../technician/technician_rechedule_screen.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/paging_controls.dart';
import 'bloc/get_complains_state_cubit.dart';
import '../../service_locator.dart';


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

    // Load user info, then fetch complaints when info is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoCubit>().loadUserInfo().then((_) {
        final userInfo = context.read<UserInfoCubit>().state;
        setState(() {
          _tenantName = userInfo.tenantName ?? "Tenant";
        });
        _fetchComplaints(userInfo);
      });
    });
  }

  void _fetchComplaints(UserInfoModel userInfo) {
    if (userInfo.tenantID != null && userInfo.tenantID!.isNotEmpty) {
      final params = _prepareComplainsParams(userInfo);
      context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
    }
  }

  GetComplainsParams _prepareComplainsParams(UserInfoModel userInfo) {
    return GetComplainsParams(
      agencyID: userInfo.agencyID,
      tenantID: userInfo.tenantID ?? '',
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      pageNumber: 1,
      pageSize: 5,
      isActive: true,
      flag: 'TENANT',
      tab: 'PROBLEM',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          // Navigate to login screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
                (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(

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
              await context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
            } else {
              await context.read<UserInfoCubit>().loadUserInfo();
              final updatedUserInfo = context.read<UserInfoCubit>().state;
              _fetchComplaints(updatedUserInfo);
            }
          },
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              if (state is GetTenantComplainsInitialState) {
                return const CenterLoaderWithText(text: "Loading Complains...");
              } else if (state is GetTenantComplainsLoadingState) {
                return const CenterLoaderWithText(text: "Loading Complains...");
              } else if (state is GetTenantComplainsFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.errorMessage}',
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
              } else if (state is GetTenantComplainsSuccessState) {
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
                        onCompletePressed: () => _handleComplete(context, complaint.ticketNo!),
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
                              pageSize: 5,
                              isActive: true,
                              flag: 'TENANT',
                              tab: 'PROBLEM',
                            );
                            context.read<GetTenantComplainsCubit>().fetchComplains(params: updatedParams);
                          },
                        ),
                      );
                    }
                  },
                );
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
      ),
    );
  }
}

// The handler functions remain the same as in my previous response
// They are already updated with theme colors, so I'm not duplicating them here

void _handleDelete(BuildContext context, ComplainEntity complaint) {
  // Implement delete logic
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Deleted: ${complaint.complainName}')),
  );
}

void _handleHistory(BuildContext context, ComplainEntity complaint) {
  Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) => ComplaintHistoryScreen(complainID: complaint.complainID,)));
}

void _handleComplete(BuildContext context, String ticketNo) {
  final TextEditingController _completeCommentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ticket#'),
          Text(ticketNo),
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
            controller: _completeCommentController,
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
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_completeCommentController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please provide comments')),
              );
              return;
            }

            // Call your API or state management to mark as complete
            _markTicketAsComplete(
              context,
              ticketNo,
              _completeCommentController.text.trim(),
            );

            Navigator.pop(context);
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

void _markTicketAsComplete(BuildContext context, String ticketNo, String comments) {
  // Implement your actual completion logic here
  // This might involve calling an API or updating state through a bloc/cubit

  // Example:
  // context.read<ComplaintCubit>().markAsComplete(
  //   ticketNo: ticketNo,
  //   comments: comments,
  // );

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Ticket #$ticketNo marked as complete'),
      backgroundColor: Colors.green,
    ),
  );
}

void _handleReschedule(BuildContext context, ComplainEntity complaint) {
  Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) => AssignedTechnicianScreen(complaint: complaint)));

}

void _handleAccept(BuildContext context, ComplainEntity complaint) {
  Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) => AcceptTechnicianScreen(complaint: complaint)));

}

void _handleResubmit(BuildContext context, ComplainEntity complaint) {
  Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) => ResubmitFormScreen(complaint: complaint)));

}



void _handleComments(BuildContext context, String? comment) {
  // final lastComment = complaint.lastComments;
  showDialog(
    context: context,
    builder: (context) => SimpleInfoDialog(
      title: 'Last Comment Details',
      bodyText: comment?? 'No Comments Yet',
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

  Navigator.push(context,MaterialPageRoute<void>(
  builder: (BuildContext context) => EditComplainScreen(existingComplain: complain)));

}



