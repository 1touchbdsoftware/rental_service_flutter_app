import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

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

                // Sort history items by date (newest first)
                historyItems.sort((a, b) {
                  if (a.updatedDate == null || b.updatedDate == null) return 0;
                  return DateTime.parse(b.updatedDate!).compareTo(DateTime.parse(a.updatedDate!));
                });

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      direction: Axis.vertical,
                      connectorTheme: ConnectorThemeData(
                        thickness: 2.5,
                        color: Colors.grey.shade300,
                      ),
                      indicatorTheme: IndicatorThemeData(
                        size: 15,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.before,
                      itemCount: historyItems.length,
                      contentsBuilder: (context, index) {
                        final item = historyItems[index];
                        return HistoryTimelineCard(
                          comments: item.comments ?? 'No comments',
                          stateStatus: item.stateStatus ?? 'Unknown',
                          updatedBy: item.updatedBy ?? 'Unknown',
                          updatedDate: item.updatedDate ?? '',
                        );
                      },
                      indicatorBuilder: (context, index) {
                        final item = historyItems[index];
                        return OutlinedDotIndicator(
                          color: _getStatusColor(item.stateStatus ?? ''),
                          backgroundColor: _getStatusColor(item.stateStatus ?? '').withOpacity(0.2),
                          borderWidth: 2.5,
                        );
                      },
                      connectorBuilder: (context, index, type) {
                        if (index == 0) {
                          return const TransparentConnector();
                        }
                        return SolidLineConnector(
                          color: Colors.grey.shade300,
                        );
                      },
                      nodePositionBuilder: (context, index) => 0.0,
                    ),
                  ),
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

}

class HistoryTimelineCard extends StatelessWidget {
  final String comments;
  final String stateStatus;
  final String updatedBy;
  final String updatedDate;

  const HistoryTimelineCard({
    super.key,
    required this.comments,
    required this.stateStatus,
    required this.updatedBy,
    required this.updatedDate,
  });

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Format as "19 July 12:30pm"
      return DateFormat('d MMMM h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and time
          Text(
            _formatDate(updatedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),

          // Content card
          Card(
            margin: EdgeInsets.zero,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comments
                  Text(
                    comments,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer with status and updatedBy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

                      // Updated by
                      Row(
                        children: [
                          Icon(
                            _getUpdaterIcon(updatedBy),
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "by $updatedBy",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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


// Create a custom transparent connector that implements ConnectorWidget
// class TransparentConnector extends ConnectorWidget {
//   const TransparentConnector({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, Widget? child) {
//     return SolidLineConnector(
//       color: Colors.transparent,
//       thickness: 0,
//     );
//   }
// }