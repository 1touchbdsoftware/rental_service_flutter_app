import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/complain/complain_req_params/get_complain_req_params.dart';
import 'package:rental_service/presentation/history/complain_history_screen.dart';
import 'package:rental_service/presentation/technician/accept_technician_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/presentation/widgets/complain_form/edit_complain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/bloc/auth/auth_cubit.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
import '../resubmit/resubmit_form_screen.dart';
import '../technician/technician_rechedule_screen.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_list_card.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/paging_controls.dart';
import 'bloc/get_complains_state_cubit.dart';

class ComplainsListContent extends StatelessWidget {
  const ComplainsListContent({super.key});

  Future<GetComplainsParams> _prepareComplainsParams() async {
    final prefs = await SharedPreferences.getInstance();

    final agencyID = prefs.getString('agencyID') ?? '';
    final tenantID = prefs.getString('tenantID') ?? '';
    final landlordID = prefs.getString('landlordID') ?? '';
    final propertyID = prefs.getString('propertyID') ?? '';

    return GetComplainsParams(
      agencyID: agencyID,
      tenantID: tenantID,
      landlordID: landlordID,
      propertyID: propertyID,
      pageNumber: 1,
      pageSize: 5,
      isActive: true,
      flag: 'TENANT',
      tab: 'PROBLEM',
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Pending Complaints',
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Tenant Dashboard'),
        body: RefreshIndicator(
          onRefresh: () async {
            final params = await _prepareComplainsParams();
            await context.read<GetTenantComplainsCubit>().fetchComplains(
                params: params);
          },
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              if (state is GetTenantComplainsInitialState) {
                // Trigger fetch when in initial state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _prepareComplainsParams().then((params) {
                    context.read<GetTenantComplainsCubit>().fetchComplains(
                        params: params);
                  });
                });
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
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final params = await _prepareComplainsParams();
                          await context.read<GetTenantComplainsCubit>().fetchComplains(
                              params: params);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetTenantComplainsSuccessState) {
                final complaints = state.response.data.list;
                final pagination = state.response.data.pagination;

                //use this to show page number and pagination

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      'No complaints to Show',
                      style: TextStyle(color: Colors.blue),
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
                        onImagePressed: (imgIndex) {
                          final imageList = complaint.images!.map((img) => img.file).toList();
                          showImageDialog(context, imageList, imgIndex);
                        },
                        onReschedulePressed: () => _handleReschedule(context, complaint),
                        onAcceptPressed: () => _handleAccept(context, complaint),
                      );
                    } else {
                      // pagination widget at the end of the list
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: PaginationControls(
                          currentPage: pagination.pageNumber,
                          totalPages: pagination.totalPages,
                          onPageChanged: (page) async {
                            final prefs = await SharedPreferences.getInstance();
                            final params = GetComplainsParams(
                              agencyID: prefs.getString('agencyID') ?? '',
                              tenantID: prefs.getString('tenantID') ?? '',
                              landlordID: prefs.getString('landlordID') ?? '',
                              propertyID: prefs.getString('propertyID') ?? '',
                              pageNumber: page,
                              pageSize: 5,
                              isActive: true,
                              flag: 'TENANT',
                              tab: 'PROBLEM',
                            );
                            context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
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
          onPressed: () async {
            final params = await _prepareComplainsParams();
            await context.read<GetTenantComplainsCubit>().fetchComplains(
                params: params);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}


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



