import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/widgets/drawer.dart';
import 'package:rental_service/common/widgets/center_loader.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/domain/usecases/get_pending_complains_usecase.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../../common/widgets/complain_list_card.dart';
import '../../common/widgets/image_dialog.dart';
import '../../domain/entities/complain_entity.dart';
import '../auth/signin.dart';
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
            await context.read<GetTenantComplainsCubit>().fetchPendingComplains(
                params: params);
          },
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              if (state is GetTenantComplainsInitialState) {
                // Trigger fetch when in initial state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _prepareComplainsParams().then((params) {
                    context.read<GetTenantComplainsCubit>().fetchPendingComplains(
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
                          await context.read<GetTenantComplainsCubit>().fetchPendingComplains(
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
            await context.read<GetTenantComplainsCubit>().fetchPendingComplains(
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
  // Show detailed dialog or screen
}



