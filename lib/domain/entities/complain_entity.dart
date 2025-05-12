// complain_entity.dart
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
  final bool isResubmitted;
  final int? countOfRecomplained;
  final bool isSentToLandlord;
  final bool isAssignedTechnician;
  final bool isRejected;
  final bool isSolved;
  final bool isCompleted;
  final bool isNotCompleted;
  final bool isDone;
  final String? rejectedBy;
  final String? rejectedDate;
  final int imageCount;
  final List<ComplainImageEntity> images;

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
    required this.isResubmitted,
     this.countOfRecomplained,
    required this.isSentToLandlord,
    required this.isAssignedTechnician,
    required this.isRejected,
    required this.isSolved,
    required this.isCompleted,
    required this.isNotCompleted,
    required this.isDone,
     this.rejectedBy,
     this.rejectedDate,
    required this.imageCount,
    required this.images,
  });
}

class ComplainImageEntity {
  final int id;
  final String fileName;
  final String actualFileName;
  final String? fileSize;
  final String? filePath;
  final String? fileType;
  final String? complainID;
  final String? complainInfoID;
  final String? agencyID;
  final String? propertyID;
  final String? createdBy;
  final String? flag;
  final int? imageGroupKey;
  final String? createdDate;
  final String? updatedBy;
  final String? updatedDate;
  final String? file;

  ComplainImageEntity({
    required this.id,
    required this.fileName,
    required this.actualFileName,
     this.fileSize,
     this.filePath,
     this.fileType,
     this.complainID,
     this.complainInfoID,
     this.agencyID,
     this.propertyID,
     this.createdBy,
     this.flag,
     this.imageGroupKey,
     this.createdDate,
     this.updatedBy,
     this.updatedDate,
     this.file,
  });


}
