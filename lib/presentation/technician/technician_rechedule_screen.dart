import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/technician/post_reschedule_technician_params.dart';
import '../../data/model/technician/technician_get_params.dart';

import '../../data/model/user/user_info_model.dart';

import '../dashboard/bloc/user_info_cubit.dart';
import '../widgets/center_loader.dart';
import 'bloc/reschedule_technician_cubit.dart';

import 'bloc/technician_post_state.dart';
import 'build_phone_row.dart';
import 'get_assigned_technician_cubit.dart';

class AssignedTechnicianScreen extends StatelessWidget {
  final ComplainEntity complaint;

  const AssignedTechnicianScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetAssignedTechnicianCubit()),
        BlocProvider(
          create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
        ),
        BlocProvider(create: (_) => RescheduleTechnicianCubit()),
      ],
      child: _AssignedTechnicianScreenContent(complaint: complaint),
    );
  }
}

class _AssignedTechnicianScreenContent extends StatefulWidget {
  final ComplainEntity complaint;

  const _AssignedTechnicianScreenContent({required this.complaint});

  @override
  State<_AssignedTechnicianScreenContent> createState() =>
      _AssignedTechnicianScreenContentState();
}

class _AssignedTechnicianScreenContentState
    extends State<_AssignedTechnicianScreenContent> {
  late DateTime _rescheduleDate;
  late TimeOfDay _rescheduleTime;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rescheduleDate = DateTime.now();
    _rescheduleTime = TimeOfDay.now();
    context.read<UserInfoCubit>().loadUserInfo().then((_) {
      _fetchTechnician(widget.complaint.complainID);
    });
  }

  void _fetchTechnician(String complainID) {
    final userInfo = context.read<UserInfoCubit>().state;
    final params = _prepareTechnicianParams(userInfo, complainID);
    context.read<GetAssignedTechnicianCubit>().fetchAssignedTechnician(
        params: params
    );
  }

  TechnicianRequestParams _prepareTechnicianParams(UserInfoModel userInfo, String complainId) {
    return TechnicianRequestParams(
      agencyID: userInfo.agencyID,
      propertyID: userInfo.propertyID ?? '',
      tenantID: userInfo.tenantID ?? '',
      complainID: complainId,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _rescheduleDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _rescheduleDate) {
      setState(() {
        _rescheduleDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _rescheduleTime,
    );
    if (picked != null && picked != _rescheduleTime) {
      setState(() {
        _rescheduleTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          'Assigned Technician',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: BlocListener<RescheduleTechnicianCubit, TechnicianPostState>(
        listener: (context, state) {
          if (state is TechnicianPostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Technician rescheduled successfully'),
                backgroundColor: colorScheme.primary,
              ),
            );
            // Navigate back after successful rescheduling with result
            Navigator.of(context).pop(true);
          } else if (state is TechnicianPostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error Rescheduling Technician: ${state.message}'),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: BlocConsumer<GetAssignedTechnicianCubit, GetAssignedTechnicianState>(
          listener: (context, state) {
            if (state is GetAssignedTechnicianFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is GetAssignedTechnicianLoadingState) {
              return const CenterLoaderWithText(
                text: 'Getting Technician Info...',
              );
            } else if (state is GetAssignedTechnicianFailureState) {
              return Center(
                child: Text(
                  'Failed to load technician information',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              );
            } else if (state is GetAssignedTechnicianSuccessState) {
              final tech = state.response.data.list;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Technician Details',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Technician Name:', tech.technicianName ?? 'N/A'),
                            _buildDetailRow('Type:', tech.technicianCategoryName ?? 'N/A'),
                            _buildDetailRow(
                                'Schedule Date:',tech.scheduleDate ?? ""),
                            _buildDetailRow(
                                'Schedule Time:',
                                _formatTimeString(tech.scheduleTime)
                            ),
                            PhoneUtils.buildEmailRow('Email:', tech.emailAddress?? 'N/A', context),
                            PhoneUtils.buildPhoneRow('Phone:', tech.contactNumber ?? '', context),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Reschedule Request',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDatePickerField(context),
                            const SizedBox(height: 16),
                            _buildTimePickerField(context),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                labelText: 'Comment',
                                labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: colorScheme.outline),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: colorScheme.primary),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: colorScheme.outline),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerLow,
                              ),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<RescheduleTechnicianCubit, TechnicianPostState>(
                              builder: (context, rescheduleState) {
                                final bool isSubmitting = rescheduleState is TechnicianPostLoading;

                                return ElevatedButton(
                                  onPressed: isSubmitting
                                      ? null
                                      : () => _submitRescheduleRequest(tech.technicianID),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isSubmitting
                                      ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: colorScheme.onPrimary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    'Submit Reschedule Request',
                                    style: textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Reschedule Date',
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd MMM, yyyy').format(_rescheduleDate),
              style: TextStyle(color: colorScheme.onSurface),
            ),
            Icon(Icons.calendar_today, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Reschedule Time',
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _rescheduleTime.format(context),
              style: TextStyle(color: colorScheme.onSurface),
            ),
            Icon(Icons.access_time, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }

  void _submitRescheduleRequest(String technicianID) {
    // Create a DateTime combining the selected date and time
    final rescheduleDateTime = DateTime(
      _rescheduleDate.year,
      _rescheduleDate.month,
      _rescheduleDate.day,
      _rescheduleTime.hour,
      _rescheduleTime.minute,
    );

    final comment = _commentController.text.trim();

    // Get user info
    final userInfo = context.read<UserInfoCubit>().state;

    // Get technician info from the state
    final technicianState = context.read<GetAssignedTechnicianCubit>().state;
    if (technicianState is! GetAssignedTechnicianSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Technician data not available. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final tech = technicianState.response.data.list;

    // Format the dates and times according to API requirements
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat formattedTimeFormatter = DateFormat('hh:mm a');

    // Original schedule date and time from technician data
    String originalScheduleDate = tech.scheduleDate ?? '';
    String originalScheduleTime = tech.scheduleTime ?? '';
    String originalFormattedTime = tech.formattedScheduleTime ?? '';

    // If the original date is in "18-May-2025" format, convert it to "2025-05-18"
    if (originalScheduleDate.isNotEmpty && originalScheduleDate.contains('-')) {
      try {
        final parts = originalScheduleDate.split('-');
        if (parts.length == 3) {
          final monthMap = {
            'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
            'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
          };

          final day = parts[0].padLeft(2, '0');
          final month = monthMap[parts[1]] ?? '01';
          final year = parts[2];

          originalScheduleDate = '$year-$month-$day';
        }
      } catch (e) {
        print('Error formatting original date: $e');
      }
    }

    // Create reschedule params
    final params = TechnicianRescheduleParams(
      technicianID: tech.technicianID,
      technicianCategoryID: tech.technicianCategoryID ?? '',
      technicianAssignID: tech.technicianAssignID,
      tenantID: userInfo.tenantID ?? '',
      complainID: widget.complaint.complainID,
      agencyID: userInfo.agencyID,
      currentComments: comment,
      rescheduleDate: dateFormatter.format(rescheduleDateTime),
      rescheduleTime: timeFormatter.format(rescheduleDateTime),
      formattedRescheduleTime: formattedTimeFormatter.format(rescheduleDateTime),
      scheduleDate: originalScheduleDate,
      scheduleTime: originalScheduleTime,
      formattedScheduleTime: originalFormattedTime,
    );

    // Debug prints for parameter validation
    print('========== RESCHEDULE PARAMS DEBUG ==========');
    print('technicianID: ${params.technicianID}');
    print('technicianCategoryID: ${params.technicianCategoryID}');
    print('technicianAssignID: ${params.technicianAssignID}');
    print('tenantID: ${params.tenantID}');
    print('complainID: ${params.complainID}');
    print('agencyID: ${params.agencyID}');
    print('currentComments: ${params.currentComments}');
    print('rescheduleDate: ${params.rescheduleDate}');
    print('rescheduleTime: ${params.rescheduleTime}');
    print('formattedRescheduleTime: ${params.formattedRescheduleTime}');
    print('scheduleDate: ${params.scheduleDate}');
    print('scheduleTime: ${params.scheduleTime}');
    print('formattedScheduleTime: ${params.formattedScheduleTime}');
    print('============================================');

    // Call the cubit to reschedule
    context.read<RescheduleTechnicianCubit>().rescheduleTechnician(params: params);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatTimeString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return 'N/A';

    try {
      final timeParts = timeString.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final time = TimeOfDay(hour: hour, minute: minute);
        return time.format(context);
      }
      return 'Invalid Time';
    } catch (e) {
      return 'Invalid Time';
    }
  }
}