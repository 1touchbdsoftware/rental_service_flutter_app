import 'package:flutter/material.dart';
import '../../domain/entities/complain_entity.dart';
import '../../l10n/generated/app_localizations.dart';

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
  final VoidCallback onApprovePressed;
  final VoidCallback onDeclinePressed;
  final VoidCallback onBudgetPressed;
  final String userType;

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
    required this.onApprovePressed,
    required this.onDeclinePressed,
    required this.onBudgetPressed,

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
      color: colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  S.of(context).ticket(complaint.ticketNo!),
                  style: textTheme.labelMedium?.copyWith(
                    // Use secondary color instead of hardcoded orange
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Spacer(),
                _buildStatusIndicator(context),
              ],
            ),
            const SizedBox(height: 14),
            // Title row with status and delete
            Row(
              children: [
                Expanded(
                  child: Text(
                    complaint.segmentName ?? S.of(context).noSegment,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Complaint description with read more
            // Complaint section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "COMPLAINT:",
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[800],
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),

                      // This Row puts complain text and Read More in same line
                      Row(
                        children: [
                          // Complaint text with ellipsis
                          Expanded(
                            child: Text(
                              complaint.complainName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Read More button only if text is long
                          if (complaint.complainName.length > 45)
                            TextButton(
                              onPressed: onReadMorePressed,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                S.of(context).readMore,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (complaint.lastComments != null) ...[
              Divider(height: 24, thickness: 1),
              // Last comment section with rounded white background
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.comment, size: 18, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                "LAST COMMENT:",
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  color: Colors.grey[800],
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  complaint.lastComments!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (complaint.lastComments!.length > 45)
                                TextButton(
                                  onPressed: onCommentsPressed,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    S.of(context).readMore,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],


            const SizedBox(height: 12),

            // History and Comments buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: onHistoryPressed,
                    icon: Icon(Icons.history, size: 16),
                    label: Text(
                      S.of(context).history,
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

                  // ElevatedButton.icon(
                  //   onPressed: onCommentsPressed,
                  //   icon: Icon(Icons.comment, size: 16),
                  //   label: Text(
                  //     S.of(context).lastComment,
                  //     style: textTheme.labelMedium?.copyWith(
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: colorScheme.surfaceContainerLow,
                  //     foregroundColor: colorScheme.onSurface,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8,
                  //       vertical: 4,
                  //     ),
                  //     minimumSize: const Size(0, 30),
                  //   ),
                  // ),
                  const SizedBox(width: 8),

                  //landlord button
                  if (complaint.isSentToLandlord! &&
                      !complaint.isApproved! &&
                      !complaint.isRejected! &&
                      userType == "LANDLORD")
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: onApprovePressed,
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
                            S.of(context).approve,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: onDeclinePressed,
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
                            S.of(context).decline,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                  //edit button
                  if (!complaint.isAssignedTechnician! &&
                      !complaint.isSentToLandlord! &&
                      !complaint.isRejected! &&
                      !complaint.isResubmitted! &&
                      !complaint.isRescheduled! &&
                      !complaint.isDone! &&
                  !complaint.isBudget! &&
                  !complaint.isPaid!
                  )
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
                        S.of(context).edit,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  //reschedule button
                  if ((complaint.isReassignedTechnician! ||
                          complaint.isAssignedTechnician!) &&
                      !complaint.isSolved! &&
                      !complaint.isResubmitted! &&
                      !complaint.isAccepted! &&
                      userType == "TENANT")
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
                            S.of(context).reschedule,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
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
                            S.of(context).accept,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
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
                            S.of(context).complete,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
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
                            S.of(context).resubmit,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (complaint.isBudget! && !complaint.isPaid! && !complaint.isApprovedBudget!)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: onBudgetPressed,
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
                            complaint.isBudgetReviewRequested! ? "View New Budget": "View Budget",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // image gallery
            if (complaint.imageCount! > 0)
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton.icon(
                  onPressed: onImagePressed,
                  icon: const Icon(Icons.photo_library, size: 20),
                  label: Text(
                    S.of(context)
                        .imageGalleryComplaintImagecount(
                          complaint.imageCount.toString(),
                        ),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
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
   /*

   status color convention:
   if any Warning/Todo for tenant: show Orange or Red color
   for all others: purple, blue
   for indicating success: green
   */


    Color dotColor;
    String statusText;

    if (complaint.isRejected!) {
      dotColor = Colors.red;
      statusText = S.of(context).rejected;
    } else if (complaint.isSolved! && complaint.isCompleted!) {
      dotColor = Colors.green;
      statusText = S.of(context).completed;
    } else if (complaint.isSolved!) {
      dotColor = Colors.green;
      statusText = S.of(context).resolved;
    } else if (complaint.isResubmitted!) {
      dotColor = Colors.orange;
      statusText = S.of(context).resubmitted;
    } else if (complaint.isSentToLandlord! && complaint.isApproved!) {
      dotColor = Colors.purple;
      statusText = S.of(context).approved;
    } else if (complaint.isSentToLandlord!) {
      dotColor = Colors.blue;
      statusText = S.of(context).sentToLandlord;
    } else if (complaint.isAssignedTechnician! && complaint.isAccepted!) {
      dotColor = Colors.purple;
      statusText = S.of(context).acceptedSchedule;
    } else if (complaint.isAssignedTechnician!) {
      dotColor = Colors.orange;
      statusText = S.of(context).technicianAssigned;
    }else if (complaint.isBudget! && !complaint.isPaid! && !complaint.isApprovedBudget!) {
      dotColor = Colors.orange;
      statusText = "Budget Provided";
    }else if (complaint.isBudget! && !complaint.isPaid! && complaint.isBudgetReviewRequested!) {
      dotColor = Colors.orange;
      statusText = "Budget Review Requested";
    } else if (complaint.isBudget! && !complaint.isPaid! && complaint.isApprovedBudget!) {
      dotColor = Colors.purple;
      statusText = "Budget Approved";
    } else {
      dotColor = Colors.grey;
      statusText = S.of(context).pending;
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
