// complain_entity.dart
import 'complain_image_entity.dart';

class ComplainEntity {
  final int id;
  final String complainInfoID;
  final String complainID;
  final String complainName;
  final String? segmentID;
  final String? segmentName;
  final String? segmentLength;
  final String? segmentWidth;
  final String? agencyID;
  final String? description;
  final String? itemID;
  final String? itemName;
  final String? propertyID;
  final String? propertyName;
  final String? landlordID;
  final String? landlordName;
  final String? tenantID;
  final String? tenantName;
  final String? comments;
  final String? lastComments;
  final String? currentComments;
  final String? feedback;
  final String? ticketNo;
  final bool? isResubmitted;
  final int? countOfRecomplained;
  final bool? isSentToLandlord;
  final bool? isAssignedTechnician;
  final bool? isRejected;
  final bool? isSolved;
  final bool? isCompleted;
  final bool? isNotCompleted;
  final bool? isDone;
  final bool? isAccepted;
  final String? rejectedBy;
  final String? rejectedDate;
  final int? imageCount;
  final List<ComplainImageEntity>? images;

  ComplainEntity({
    required this.id,
    required this.complainInfoID,
    required this.complainID,
    required this.complainName,
     this.segmentID,
     this.segmentName,
     this.segmentLength,
     this.segmentWidth,
     this.agencyID,
     this.description,
     this.itemID,
     this.itemName,
     this.propertyID,
     this.propertyName,
     this.landlordID,
     this.landlordName,
     this.tenantID,
     this.tenantName,
     this.comments,
     this.lastComments,
     this.currentComments,
     this.feedback,
     this.ticketNo,
     this.isResubmitted,
     this.countOfRecomplained,
     this.isSentToLandlord,
     this.isAssignedTechnician,
     this.isRejected,
     this.isSolved,
     this.isCompleted,
     this.isNotCompleted,
     this.isDone,
     this.rejectedBy,
     this.rejectedDate,
     this.imageCount,
     this.images,
    this.isAccepted,
  });
}


