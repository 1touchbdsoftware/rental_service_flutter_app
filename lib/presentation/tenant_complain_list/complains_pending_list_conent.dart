import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/bloc/auth/auth_cubit.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
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
      pageSize: 15,
      isActive: true,
      flag: 'TENANT',
      tab: 'PENDING',
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
                return const CenterLoader();
              } else if (state is GetTenantComplainsLoadingState) {
                return const CenterLoader();
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
                        onEdit: () => _handleDelete(context, complaint),
                        onHistoryPressed: () => _handleHistory(context, complaint),
                        onCommentsPressed: () => _handleComments(context, complaint.lastComments),
                        onReadMorePressed: () => _handleReadMore(context, complaint.complainName),
                        onImagePressed: (imgIndex) {
                          final imageList = complaint.images!.map((img) => img.file).toList();
                          showImageDialog(context, imageList, imgIndex);
                        },
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
                              pageSize: 15,
                              isActive: true,
                              flag: 'TENANT',
                              tab: 'PENDING',
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
              return const CenterLoader();
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
  // Navigate or show history
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



