import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/history/history_query_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/center_loader.dart';
import '../dashboard/bloc/user_info_cubit.dart';
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
          title:  Text( S.of(context).complaintHistory),
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
                return CenterLoaderWithText(text:S.of(context).holdOnGettingHistory);
              } else if (state is GetHistoryLoadingState) {
                return CenterLoaderWithText(text: S.of(context).holdOnGettingHistory);
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
                  return DateTime.parse(b.updatedDate).compareTo(DateTime.parse(a.updatedDate));
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
                          comments: item.comments,
                          stateStatus: item.stateStatus,
                          updatedBy: item.updatedBy,
                          updatedDate: item.updatedDate
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
              return CenterLoaderWithText(text: S.of(context).loading);
            },
          ),
        ),
        // floatingActionButton: BlocBuilder<GetHistoryCubit, GetHistoryState>(
        //   builder: (context, state) {
        //     if (state is GetHistorySuccessState) {
        //       return FloatingActionButton(
        //         onPressed: () {
        //           final userInfo = context.read<UserInfoCubit>().state;
        //           if (userInfo.agencyID.isNotEmpty) {
        //             final params = HistoryQueryParams(
        //               agencyID: userInfo.agencyID,
        //               complainID: widget.complainID,
        //             );
        //             context.read<GetHistoryCubit>().fetchHistory(params: params);
        //           }
        //         },
        //         child: const Icon(Icons.refresh),
        //       );
        //     }
        //     return const SizedBox.shrink();
        //   },
        // ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return Colors.red;
      case 'completed':
      case 'solved':
      case 'resolved':
      case 'done':
        return Colors.green;
      case 'resubmitted':
        return Colors.orange;
      case 'approved':
      case 'sent to landlord':
        return Colors.blue;
      case 'accepted schedule':
      case 'technician assigned':
      case 'rescheduled':
        return Colors.purple;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

}


class HistoryTimelineCard extends StatefulWidget {
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

  @override
  State<HistoryTimelineCard> createState() => _HistoryTimelineCardState();
}

class _HistoryTimelineCardState extends State<HistoryTimelineCard> {
  bool _expanded = false;
  bool _showReadMore = false;

  @override
  void initState() {
    super.initState();
    // Check if comment needs "Read More" button
    _showReadMore = widget.comments.length > 60;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Format as "19 July 12:30pm"
      return DateFormat('d MMMM h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return Colors.red;
      case 'completed':
      case 'solved':
      case 'resolved':
      case 'done':
        return Colors.green;
      case 'resubmitted':
        return Colors.orange;
      case 'approved':
      case 'sent to landlord':
        return Colors.blue;
      case 'accepted schedule':
      case 'technician assigned':
      case 'rescheduled':
        return Colors.purple;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return S.of(context).rejected;
      case 'done':
        return S.of(context).completed;
      case 'completed':
      case 'solved':
      case 'resolved':
        return S.of(context).resolved;
      case 'resubmitted':
        return S.of(context).resubmitted;
      case 'sent to landlord':
        return S.of(context).sentToLandlord;
      case 'approved':
        return S.of(context).approved;
      case 'accepted schedule':
        return S.of(context).acceptedSchedule;
      case 'technician assigned':
        return S.of(context).technicianAssigned;
      case 'rescheduled':
        return S.of(context).rescheduled;
      case 'pending':
      default:
        return S.of(context).pending;
    }
  }


  Widget _buildStatusIndicator(BuildContext context) {
    // Get theme colors
    final textTheme = Theme.of(context).textTheme;

    // Get status color
    final Color dotColor = _getStatusColor(widget.stateStatus);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          _getStatusText(widget.stateStatus),
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: dotColor, // Make the text color match the dot color
          ),
        ),
      ],
    );
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

  String _getUpdaterName(String updater) {
    switch (updater.toLowerCase()) {
      case 'tenant':
        return S.of(context).tenant;
      case 'agency':
        return S.of(context).agency;
      case 'landlord':
        return S.of(context).landlord;
      case 'technician':
        return 'Technician';
      default:
        return 'Unknown';
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
            _formatDate(widget.updatedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),

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
                  const SizedBox(height: 12),
                  // Status and updated by at the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status indicator
                      _buildStatusIndicator(context),

                      // Updated by
                      Row(
                        children: [
                          Icon(
                            _getUpdaterIcon(widget.updatedBy),
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "by ${_getUpdaterName(widget.updatedBy)}",
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

                  const SizedBox(height: 12),

                  const SizedBox(height: 12),

                  // Comments with Read More functionality
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _expanded ? widget.comments : (_showReadMore ? widget.comments.substring(0, 60) + "..." : widget.comments),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      if (_showReadMore)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _expanded ? S.of(context).readLess : S.of(context).readMore,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
}
