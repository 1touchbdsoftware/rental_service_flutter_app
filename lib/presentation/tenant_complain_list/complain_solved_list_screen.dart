import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rental_service/presentation/widgets/no_internet_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';

import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
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
    return BlocProvider(
      create: (context) => GetTenantComplainsCubit(),
      child: const ComplainsListContent(),
    );
  }
}


class ComplainsListContent extends StatelessWidget {
  const ComplainsListContent({super.key});

  Future<bool> _checkInternetConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }

  Future<void> _fetchComplainsWithConnectionCheck(BuildContext context) async {
    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      return;
    }

    final params = await _prepareComplainsParams();
    await context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
  }

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
      pageSize: 10,
      isActive: true,
      flag: 'TENANT',
      tab: 'SOLVED',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
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
            'Solved Complaints',
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Tenant Dashboard'),
        body: RefreshIndicator(
          onRefresh: () async {
            await _fetchComplainsWithConnectionCheck(context);
          },
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              // Handle no internet state first
              if (state is GetTenantComplainsNoInternetState) {
                return NoInternetWidget(
                  onRetry: () async {
                    final params = await _prepareComplainsParams();
                    context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
                  },
                );
              }
              if (state is GetTenantComplainsInitialState) {
                // Trigger fetch when in initial state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _prepareComplainsParams().then((params) {
                    context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
                  });
                });
                return const CenterLoaderWithText(text: "Loading Complains...");
              }
              else if (state is GetTenantComplainsLoadingState) {
                return const CenterLoaderWithText(text: "Loading Complains...");
              } else if (state is GetTenantComplainsFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _fetchComplainsWithConnectionCheck(context);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetTenantComplainsSuccessState) {
                final complaints = state.response.data.list;
                final pagination = state.response.data.pagination;

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Solved Complaints to Show',
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: complaints.length + 1,
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
                        onReschedulePressed: () {},
                        onCompletePressed: () {},
                        onResubmitPressed: () {},
                        onAcceptPressed: () {},
                      );
                    } else {
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

                            final prefs = await SharedPreferences.getInstance();
                            final params = GetComplainsParams(
                              agencyID: prefs.getString('agencyID') ?? '',
                              tenantID: prefs.getString('tenantID') ?? '',
                              landlordID: prefs.getString('landlordID') ?? '',
                              propertyID: prefs.getString('propertyID') ?? '',
                              pageNumber: page,
                              pageSize: 10,
                              isActive: true,
                              flag: 'TENANT',
                              tab: 'SOLVED',
                            );
                            context.read<GetTenantComplainsCubit>().fetchComplains(params: params);
                          },
                        ),
                      );
                    }
                  },
                );
              }
              return const CenterLoaderWithText(text: "Loading Complains...");
            },
          ),
        ),
      ),
    );
  }
}


void _handleHistory(BuildContext context, ComplainEntity complaint) {
  Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => ComplaintHistoryScreen(complainID: complaint.complainID)
      )
  );
}


void _handleEdit(BuildContext context, ComplainEntity complaint) {
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


