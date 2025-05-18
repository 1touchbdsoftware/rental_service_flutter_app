import 'package:flutter/material.dart';

import '../../domain/entities/complain_entity.dart';
import 'image_handler.dart';

class ComplainCard extends StatelessWidget {
  final ComplainEntity complaint;

  final VoidCallback onEdit;
  final VoidCallback onHistoryPressed;
  final VoidCallback onCommentsPressed;
  final VoidCallback onReadMorePressed;
  final void Function(int index) onImagePressed;

  const ComplainCard({
    required this.complaint,
    required this.onEdit,
    required this.onHistoryPressed,
    required this.onCommentsPressed,
    required this.onReadMorePressed,
    required this.onImagePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Ticket# ${complaint.ticketNo}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Title row with status and delete
            Row(
              children: [
                Expanded(
                  child: Text(
                    complaint.segmentName ?? 'No Segment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusIndicator(),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 8),

            // Complaint description with read more
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint.complainName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                if (complaint.complainName.length >
                    50) // Adjust this threshold as needed
                  TextButton(
                    onPressed: onReadMorePressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Read More',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // History and Comments buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onHistoryPressed,
                  icon: const Icon(Icons.history, size: 16),
                  label: const Text(
                    'History',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
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
                  icon: const Icon(Icons.comment, size: 16),
                  label: Text(
                    'Last Comment',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: const Size(0, 30),
                  ),
                ),
                const SizedBox(width: 8),

                //edit button
                if (!complaint.isAssignedTechnician! &&
                    !complaint.isSentToLandlord! &&
                    !complaint.isRejected! &&
                    !complaint.isResubmitted! &&
                    !complaint.isDone!)
                  ElevatedButton(
                    onPressed: onCommentsPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Images row
            if (complaint.imageCount! > 0)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: complaint.images!.length,
                  itemBuilder: (context, index) {
                    final image = complaint.images![index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Base64ImageHandler.buildBase64Image(
                        base64String: image.file, // 'file' is the base64 string
                        onTap: () => onImagePressed(index), //on-press callback
                        width: 80,
                        height: 80,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color dotColor;
    String statusText;

    if (complaint.isRejected!) {
      dotColor = Colors.red;
      statusText = 'Rejected';
    } else if (complaint.isSolved!) {
      dotColor = Colors.green;
      statusText = 'Completed';
    } else if (complaint.isResubmitted!) {
      dotColor = Colors.orange;
      statusText = 'Resubmitted';
    } else if (complaint.isSentToLandlord!) {
      dotColor = Colors.blue;
      statusText = 'Sent to Landlord';
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
