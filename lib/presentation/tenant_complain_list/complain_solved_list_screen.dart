// lib/presentation/dashboard/complains_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../../common/widgets/center_loader.dart';
import '../../common/widgets/complain_list_card.dart';
import '../../common/widgets/drawer.dart';
import '../../common/widgets/image_dialog.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/get_complain_req_params.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
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
      pageSize: 20,
      isActive: true,
      flag: 'TENANT',
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
            'Solved Complaints',
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Tenant Dashboard'),
        body: RefreshIndicator(
          onRefresh: () async {
            final params = await _prepareComplainsParams();
            await context.read<GetTenantComplainsCubit>().fetchCompletedComplains(
                params: params);
          },
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              if (state is GetTenantComplainsInitialState) {
                // Trigger fetch when in initial state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _prepareComplainsParams().then((params) {
                    context.read<GetTenantComplainsCubit>().fetchCompletedComplains(
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
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final params = await _prepareComplainsParams();
                          await context.read<GetTenantComplainsCubit>().fetchCompletedComplains(
                              params: params);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetTenantComplainsSuccessState) {
                final complaints = state.response.data.list;

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      'No complaints found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return ComplainCard(
                      complaint: complaint,
                      onEdit: () => _handleDelete(context, complaint),
                      onHistoryPressed: () => _handleHistory(context, complaint),
                      onCommentsPressed: () => _handleComments(context, complaint),
                      onReadMorePressed: () => _handleReadMore(context, complaint),
                      onImagePressed: (index) {
                        final imageList = complaint.images!.map((img) => img.file).toList();
                        showImageDialog(context, imageList, index);
                      },
                    );
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
            await context.read<GetTenantComplainsCubit>().fetchCompletedComplains(
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

void _handleComments(BuildContext context, ComplainEntity complaint) {
  final lastComment = complaint.lastComments;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.primary,
        titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Center(
              child: Text(
                "Last Comment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Divider(thickness: 1, color: Colors.black),
          ],
        ),
        content: lastComment != null
            ? Text(lastComment, style: TextStyle(color: Colors.black))
            : const Text('No comments yet.', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.black)),
          ),
        ],
      );

    },
  );
}

void _handleReadMore(BuildContext context, ComplainEntity complaint) {
  showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Complaint Details'),
          content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: complaint.complainName,
                      ),
                    ],
                  ),
                ),
              )
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',  style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
  );
}



