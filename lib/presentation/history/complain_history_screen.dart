import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../data/model/history/history_query_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../service_locator.dart';
import '../widgets/center_loader.dart';
import '../dashboard/bloc/user_cubit.dart';
import 'get_history_cubit.dart';


class ComplaintHistoryScreen extends StatefulWidget {
  final String complainID;

  const ComplaintHistoryScreen({super.key, required this.complainID});

  @override
  State<ComplaintHistoryScreen> createState() => _ComplaintHistoryScreenState();
}

class _ComplaintHistoryScreenState extends State<ComplaintHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo()),
        BlocProvider(create: (context) => GetHistoryCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Complaint History'),
        ),
        body: BlocListener<UserInfoCubit, UserInfoModel>(
          listener: (context, userInfo) {
            if (userInfo.agencyID.isNotEmpty) {
              // Once user info is loaded, fetch history
              final params = HistoryQueryParams(
                agencyID: userInfo.agencyID,
                complainID: widget.complainID,
              );
              context.read<GetHistoryCubit>().fetchHistory(params: params);
            }
          },
          child: BlocBuilder<GetHistoryCubit, GetHistoryState>(
            builder: (context, state) {
              if (state is GetHistoryInitialState) {
                return const CenterLoaderWithText(text: "Preparing...");
              } else if (state is GetHistoryLoadingState) {
                return const CenterLoaderWithText(text: "Hold on, Getting history...");
              } else if (state is GetHistoryFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Reload user info to retry
                          context.read<UserInfoCubit>().loadUserInfo();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetHistorySuccessState) {
                final historyItems = state.historyResponse.data.list ?? [];

                if (historyItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'No history records found',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: historyItems.length,
                  itemBuilder: (context, index) {
                    final item = historyItems[index];
                    return HistoryItemCard(
                      comments: item.comments ?? 'No comments',
                      stateStatus: item.stateStatus ?? 'Unknown',
                      updatedBy: item.updatedBy ?? 'Unknown',
                      updatedDate: item.updatedDate ?? '',
                    );
                  },
                );
              }

              // Fallback
              return const CenterLoaderWithText(text: "Loading...");
            },
          ),
        ),
        floatingActionButton: BlocBuilder<GetHistoryCubit, GetHistoryState>(
          builder: (context, state) {
            if (state is GetHistorySuccessState) {
              return FloatingActionButton(
                onPressed: () {
                  final userInfo = context.read<UserInfoCubit>().state;
                  if (userInfo.agencyID.isNotEmpty) {
                    final params = HistoryQueryParams(
                      agencyID: userInfo.agencyID,
                      complainID: widget.complainID,
                    );
                    context.read<GetHistoryCubit>().fetchHistory(params: params);
                  }
                },
                child: const Icon(Icons.refresh),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class HistoryItemCard extends StatelessWidget {
  final String comments;
  final String stateStatus;
  final String updatedBy;
  final String updatedDate;

  const HistoryItemCard({
    super.key,
    required this.comments,
    required this.stateStatus,
    required this.updatedBy,
    required this.updatedDate,
  });

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMM, yyyy hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(stateStatus),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stateStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  _formatDate(updatedDate),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comments,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  _getUpdaterIcon(updatedBy),
                  size: 16,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text( "by $updatedBy",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
      case 'solved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getUpdaterIcon(String updater) {
    switch (updater.toLowerCase()) {
      case 'tenant':
        return Icons.person;
      case 'agent':
      case 'admin':
        return Icons.business;
      case 'technician':
        return Icons.build;
      default:
        return Icons.person_outline;
    }
  }
}
