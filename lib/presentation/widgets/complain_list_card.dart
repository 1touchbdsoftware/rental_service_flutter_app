import 'package:flutter/material.dart';

import '../../domain/entities/complain_entity.dart';
import 'image_handler.dart';

class ComplainCard extends StatelessWidget {
  final ComplainEntity complaint;

  final VoidCallback onEditPressed;
  final VoidCallback onHistoryPressed;
  final VoidCallback onCommentsPressed;
  final VoidCallback onReadMorePressed;
  final VoidCallback onReschedulePressed;
  final VoidCallback onCompletePressed;
  final VoidCallback onResubmitPressed;
  final VoidCallback onAcceptPressed;
  final VoidCallback onImagePressed;
  final String userType ;

  const ComplainCard({
    required this.complaint,
    required this.onEditPressed,
    required this.onHistoryPressed,
    required this.onCommentsPressed,
    required this.onReadMorePressed,
    required this.onImagePressed,
    required this.onReschedulePressed,
    required this.onCompletePressed,
    required this.onResubmitPressed,
    required this.onAcceptPressed,
    required this.userType,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      // Use surface color from theme instead of hardcoded white
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Ticket# ${complaint.ticketNo}",
                  style: textTheme.labelMedium?.copyWith(
                    // Use secondary color instead of hardcoded orange
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Title row with status and delete
            Row(
              children: [
                Expanded(
                  child: Text(
                    complaint.segmentName ?? 'No Segment',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusIndicator(context),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 20),

            // Complaint description with read more
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint.complainName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                if (complaint.complainName.length > 45)
                  TextButton(
                    onPressed: onReadMorePressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Use primary color instead of hardcoded blue
                      foregroundColor: colorScheme.primary,
                    ),
                    child: Text(
                      'Read More',
                      style: TextStyle(fontSize: 12, color: Colors.blue)
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),

            // History and Comments buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: onHistoryPressed,
                    icon: Icon(Icons.history, size: 16),
                    label: Text(
                      'History',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      // Use surfaceContainerLow instead of hardcoded grey
                      backgroundColor: colorScheme.surfaceContainerLow,
                      foregroundColor: colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onCommentsPressed,
                    icon: Icon(Icons.comment, size: 16),
                    label: Text(
                      'Last Comment',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerLow,
                      foregroundColor: colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                  ),
                  const SizedBox(width: 8),


                  //landlord button
                  if (complaint.isSentToLandlord! && userType == "LANDLORD")
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: onEditPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            // Use primary color instead of hardcoded blue
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Approve',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                          ),
                        ),

                        const SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: onEditPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            // Use primary color instead of hardcoded blue
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Decline',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                  //edit button
                  if (!complaint.isAssignedTechnician! &&
                      !complaint.isSentToLandlord! &&
                      !complaint.isRejected! &&
                      !complaint.isResubmitted! &&
                      !complaint.isDone!)
                    ElevatedButton(
                      onPressed: onEditPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerLow,
                        // Use primary color instead of hardcoded blue
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 30),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                      ),
                    ),

                  //reschedule button
                  if (complaint.isAssignedTechnician! &&
                      !complaint.isSolved! &&
                      !complaint.isResubmitted! && !complaint.isAccepted!)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: onReschedulePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Reschedule',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onAcceptPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Accept',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  if (complaint.isSolved! && !complaint.isCompleted!)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: onCompletePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Complete',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),

                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onResubmitPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          child: Text(
                            'Resubmit',
                            style: TextStyle( fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // image gallery

            if (complaint.imageCount! > 0)
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton.icon(
                  onPressed: onImagePressed,
                  icon: const Icon(Icons.photo_library, size: 20),
                  label: Text(
                    'Image Gallery (${complaint.imageCount})',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    // Get theme colors
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Status colors using semantically appropriate theme colors
    Color dotColor;
    String statusText;

    if (complaint.isRejected!) {
      dotColor = Colors.red;
      statusText = 'Rejected';
    } else if (complaint.isSolved! && complaint.isCompleted!) {
      dotColor = Colors.green;
      statusText = 'Completed';
    } else if (complaint.isSolved!) {
      dotColor = Colors.green;
      statusText = 'Resolved';
    } else if (complaint.isResubmitted!) {
      dotColor = Colors.orange;
      statusText = 'Resubmitted';
    } else if (complaint.isSentToLandlord!) {
      dotColor = Colors.blue;
      statusText = 'Sent to Landlord';
    }else if (complaint.isAssignedTechnician! && complaint.isAccepted!) {
      dotColor = Colors.purple;
      statusText = 'Accepted Schedule';
    } else if (complaint.isAssignedTechnician!) {
      dotColor = Colors.purple;
      statusText = 'Technician Assigned';
    } else {
      dotColor = Colors.grey;
      statusText = 'Pending';
    }

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
          statusText,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}