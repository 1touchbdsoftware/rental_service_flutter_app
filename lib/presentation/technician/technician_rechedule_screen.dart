import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';

import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/user/user_info_model.dart';

import '../dashboard/bloc/user_cubit.dart';
import '../widgets/center_loader.dart';
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
      landlordID: userInfo.landlordID!,
      isActive: 'true',
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
        title: Text('Assigned Technician',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimary,
        ), ), ),
      body: BlocConsumer<GetAssignedTechnicianCubit, GetAssignedTechnicianState>(
        listener: (context, state) {
          if (state is GetAssignedTechnicianFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          if (state is GetAssignedTechnicianLoadingState) {
            return const CenterLoaderWithText(
              text: 'Fetching assigned technician...',
            );
          } else if (state is GetAssignedTechnicianFailureState) {
            return const Center(
              child: Text('Failed to load technician information'),
            );
          } else if (state is GetAssignedTechnicianSuccessState) {
            final tech = state.response.data.list[0];
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
                          const Text(
                            'Technician Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Technician Name:', tech.technicianName ?? 'N/A'),
                          _buildDetailRow('Type:', tech.technicianCategoryName ?? 'N/A'),
                          _buildDetailRow('Email:', tech.emailAddress ?? 'N/A'),
                          _buildDetailRow('Phone:', tech.contactNumber ?? 'N/A'),
                          _buildDetailRow(
                              'Schedule Date:',
                              _formatDateString(tech.scheduleDate)
                          ),
                          _buildDetailRow(
                              'Schedule Time:',
                              _formatTimeString(tech.scheduleTime)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Reschedule Request',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                            decoration: const InputDecoration(
                              labelText: 'Comment',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Handle reschedule submission
                              _submitRescheduleRequest();
                            },
                            child: const Text('Submit Reschedule Request'),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reschedule Date',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_rescheduleDate.day}-${_rescheduleDate.month}-${_rescheduleDate.year}',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerField(BuildContext context) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reschedule Time',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_rescheduleTime.format(context)),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  void _submitRescheduleRequest() {
    // Implement your reschedule submission logic here
    final rescheduleDateTime = DateTime(
      _rescheduleDate.year,
      _rescheduleDate.month,
      _rescheduleDate.day,
      _rescheduleTime.hour,
      _rescheduleTime.minute,
    );

    final comment = _commentController.text.trim();

    // You can add your API call or state management logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reschedule request submitted for $rescheduleDateTime'),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
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

