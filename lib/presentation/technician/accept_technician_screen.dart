import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import 'package:rental_service/presentation/technician/bloc/technician_accept_post_cubit.dart';
import '../../data/model/technician/post_accept_technician_params.dart';
import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../widgets/center_loader.dart';
import 'bloc/technician_post_state.dart';
import 'build_phone_row.dart';
import 'bloc/get_assigned_technician_cubit.dart';

class AcceptTechnicianScreen extends StatelessWidget {
  final ComplainEntity complaint;

  const AcceptTechnicianScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetAssignedTechnicianCubit()),
        BlocProvider(
          create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
        ),
        BlocProvider(create: (_) => AcceptTechnicianCubit()),
      ],
      child: _AcceptTechnicianScreenContent(complaint: complaint),
    );
  }
}

class _AcceptTechnicianScreenContent extends StatefulWidget {
  final ComplainEntity complaint;

  const _AcceptTechnicianScreenContent({required this.complaint});

  @override
  State<_AcceptTechnicianScreenContent> createState() =>
      _AcceptTechnicianScreenContentState();
}

class _AcceptTechnicianScreenContentState
    extends State<_AcceptTechnicianScreenContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().loadUserInfo().then((_) {
      _fetchTechnician(widget.complaint.complainID);
    });
  }

  void _fetchTechnician(String complainID) {
    final userInfo = context.read<UserInfoCubit>().state;
    final params = _prepareTechnicianParams(userInfo, complainID);
    context.read<GetAssignedTechnicianCubit>().fetchAssignedTechnician(
      params: params,
    );
  }

  TechnicianRequestParams _prepareTechnicianParams(
    UserInfoModel userInfo,
    String complainId,
  ) {
    return TechnicianRequestParams(
      agencyID: userInfo.agencyID,
      propertyID: userInfo.propertyID ?? '',
      tenantID: userInfo.tenantID ?? '',
      complainID: complainId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).acceptTechnician,
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: BlocListener<AcceptTechnicianCubit, TechnicianPostState>(
        listener: (context, state) {
          if (state is TechnicianPostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).technicianAcceptedSuccessfully),
                backgroundColor: colorScheme.primary,
              ),
            );
            // Navigate back after successful acceptance with a result value
            Navigator.pushReplacementNamed(context, '/complain-list-screen');
          } else if (state is TechnicianPostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error Accepting Technician'),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: BlocConsumer<
          GetAssignedTechnicianCubit,
          GetAssignedTechnicianState
        >(
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
              return  CenterLoaderWithText(
                text: S.of(context).gettingTechnicianInfo,
              );
            } else if (state is GetAssignedTechnicianFailureState) {
              return Center(
                child: Text(
                  S.of(context).failedToLoadTechnicianInformation,
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
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).technicianDetails,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              S.of(context).technicianName,
                              tech.technicianName ?? 'N/A',
                            ),
                            _buildDetailRow(
                              S.of(context).scheduleDate,
                              tech.scheduleDate ?? "",
                            ),
                            _buildDetailRow(
                              S.of(context).scheduleTime,
                              _formatTimeString(tech.scheduleTime),
                            ),
                            PhoneUtils.buildEmailRow(
                              S.of(context).email_1,
                              tech.emailAddress ?? 'N/A',
                              context,
                            ),
                            PhoneUtils.buildPhoneRow(
                              S.of(context).phone_1,
                              tech.contactNumber ?? 'N/A',
                              context,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      S.of(context).comment,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                labelText: S.of(context).writeCommentOrInstructions,
                                labelStyle: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colorScheme.outline,
                                  ),
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
                            Row(
                              children: [
                                BlocBuilder<
                                  AcceptTechnicianCubit,
                                  TechnicianPostState
                                >(
                                  builder: (context, acceptState) {
                                    final bool isSubmitting =
                                        acceptState is TechnicianPostLoading;
                                    return Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            isSubmitting
                                                ? null
                                                : () {
                                                  // Get the current user info
                                                  final userInfo =
                                                      context
                                                          .read<UserInfoCubit>()
                                                          .state;

                                                  // Get the technician info from the state
                                                  final technicianState =
                                                      context
                                                          .read<
                                                            GetAssignedTechnicianCubit
                                                          >()
                                                          .state;

                                                  if (technicianState
                                                      is GetAssignedTechnicianSuccessState) {
                                                    final tech =
                                                        technicianState
                                                            .response
                                                            .data
                                                            .list;

                                                    // Create the params directly
                                                    final params =
                                                        AcceptTechnicianParams(
                                                          technicianID:
                                                              tech.technicianID,
                                                          tenantID:
                                                              userInfo
                                                                  .tenantID ??
                                                              '',
                                                          complainID:
                                                              widget
                                                                  .complaint
                                                                  .complainID,
                                                          agencyID:
                                                              userInfo.agencyID,
                                                          currentComments:
                                                              _commentController
                                                                  .text,
                                                        );

                                                    if (_commentController.text.trim().isEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                         SnackBar(content: Text(S.of(context).commentIsRequired)),
                                                      );
                                                      return;
                                                    }
                                                    // Call the accept technician method from the cubit
                                                    context
                                                        .read<
                                                          AcceptTechnicianCubit
                                                        >()
                                                        .acceptTechnician(
                                                          params: params,
                                                        );
                                                  } else {
                                                    // Handle the case where technician data isn't available
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Technician data not available. Please try again.',
                                                        ),
                                                        backgroundColor:
                                                            colorScheme.error,
                                                      ),
                                                    );
                                                  }
                                                },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          foregroundColor:
                                              colorScheme.onPrimary,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child:
                                            isSubmitting
                                                ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                  Platform.isIOS ? CupertinoActivityIndicator(radius:15.0) : CircularProgressIndicator(
                                                      strokeWidth: 4.0,
                                                      valueColor: AlwaysStoppedAnimation<Color>( colorScheme.onPrimary)),
                                            )
                                                : Text(
                                              S.of(context).acceptTechnician,
                                                  style: textTheme.labelLarge?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: colorScheme.onPrimary,
                                                      ),
                                                ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
