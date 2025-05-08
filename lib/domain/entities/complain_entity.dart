// complain_entity.dart
class ComplainEntity {
  final int id;
  final String complainInfoID;
  final String complainID;
  final String complainName;
  final String segmentID;
  final String segmentName;
  final String segmentLength;
  final String segmentWidth;
  final String agencyID;
  final String description;
  final String? itemID;
  final String? itemName;
  final String propertyID;
  final String propertyName;
  final String landlordID;
  final String landlordName;
  final String tenantID;
  final String tenantName;
  final String? comments;
  final String? lastComments;
  final String? currentComments;
  final String? feedback;
  final String ticketNo;
  final bool isResubmitted;
  final int countOfRecomplained;
  final bool isSentToLandlord;
  final bool isAssignedTechnician;
  final bool isRejected;
  final bool isSolved;
  final bool isCompleted;
  final bool isNotCompleted;
  final bool isDone;
  final String? rejectedBy;
  final String rejectedDate;
  final int imageCount;
  final List<ComplainImageEntity> images;

  ComplainEntity({
    required this.id,
    required this.complainInfoID,
    required this.complainID,
    required this.complainName,
    required this.segmentID,
    required this.segmentName,
    required this.segmentLength,
    required this.segmentWidth,
    required this.agencyID,
    required this.description,
    required this.itemID,
    required this.itemName,
    required this.propertyID,
    required this.propertyName,
    required this.landlordID,
    required this.landlordName,
    required this.tenantID,
    required this.tenantName,
    required this.comments,
    required this.lastComments,
    required this.currentComments,
    required this.feedback,
    required this.ticketNo,
    required this.isResubmitted,
    required this.countOfRecomplained,
    required this.isSentToLandlord,
    required this.isAssignedTechnician,
    required this.isRejected,
    required this.isSolved,
    required this.isCompleted,
    required this.isNotCompleted,
    required this.isDone,
    required this.rejectedBy,
    required this.rejectedDate,
    required this.imageCount,
    required this.images,
  });
}

class ComplainImageEntity {
  final int id;
  final String fileName;
  final String actualFileName;
  final String fileSize;
  final String filePath;
  final String fileType;
  final String complainID;
  final String complainInfoID;
  final String agencyID;
  final String propertyID;
  final String createdBy;
  final String flag;
  final int imageGroupKey;
  final String createdDate;
  final String? updatedBy;
  final String updatedDate;
  final String? file; // Base64

  ComplainImageEntity({
    required this.id,
    required this.fileName,
    required this.actualFileName,
    required this.fileSize,
    required this.filePath,
    required this.fileType,
    required this.complainID,
    required this.complainInfoID,
    required this.agencyID,
    required this.propertyID,
    required this.createdBy,
    required this.flag,
    required this.imageGroupKey,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.file,
  });


}
