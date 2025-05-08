import '../../domain/entities/complain_entity.dart';

class ComplainModel {
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
  final String itemID;
  final String itemName;
  final String propertyID;
  final String propertyName;
  final String landlordID;
  final String landlordName;
  final String tenantID;
  final String tenantName;
  final String comments;
  final String lastComments;
  final String currentComments;
  final String feedback;
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
  final String rejectedBy;
  final String rejectedDate;
  final int imageCount;
  final List<ComplainImageModel> images;

  ComplainModel({
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

  factory ComplainModel.fromJson(Map<String, dynamic> json) {
    return ComplainModel(
      id: json['id'],
      complainInfoID: json['complainInfoID'],
      complainID: json['complainID'],
      complainName: json['complainName'],
      segmentID: json['segmentID'],
      segmentName: json['segmentName'],
      segmentLength: json['segmentLength'],
      segmentWidth: json['segmentWidth'],
      agencyID: json['agencyID'],
      description: json['description'],
      itemID: json['itemID'],
      itemName: json['itemName'],
      propertyID: json['propertyID'],
      propertyName: json['propertyName'],
      landlordID: json['landlordID'],
      landlordName: json['landlordName'],
      tenantID: json['tenantID'],
      tenantName: json['tenantName'],
      comments: json['comments'],
      lastComments: json['lastComments'],
      currentComments: json['currentComments'],
      feedback: json['feedback'],
      ticketNo: json['ticketNo'],
      isResubmitted: json['isResubmitted'],
      countOfRecomplained: json['countOfRecomplained'],
      isSentToLandlord: json['isSentToLandlord'],
      isAssignedTechnician: json['isAssignedTechnician'],
      isRejected: json['isRejected'],
      isSolved: json['isSolved'],
      isCompleted: json['isCompleted'],
      isNotCompleted: json['isNotCompleted'],
      isDone: json['isDone'],
      rejectedBy: json['rejectedBy'],
      rejectedDate: json['rejectedDate'],
      imageCount: json['imageCount'],
      images: (json['images'] as List)
          .map((e) => ComplainImageModel.fromJson(e))
          .toList(),
    );
  }

  ComplainEntity toEntity() {
    return ComplainEntity(
      id: id,
      complainInfoID: complainInfoID,
      complainID: complainID,
      complainName: complainName,
      segmentID: segmentID,
      segmentName: segmentName,
      segmentLength: segmentLength,
      segmentWidth: segmentWidth,
      agencyID: agencyID,
      description: description,
      itemID: itemID,
      itemName: itemName,
      propertyID: propertyID,
      propertyName: propertyName,
      landlordID: landlordID,
      landlordName: landlordName,
      tenantID: tenantID,
      tenantName: tenantName,
      comments: comments,
      lastComments: lastComments,
      currentComments: currentComments,
      feedback: feedback,
      ticketNo: ticketNo,
      isResubmitted: isResubmitted,
      countOfRecomplained: countOfRecomplained,
      isSentToLandlord: isSentToLandlord,
      isAssignedTechnician: isAssignedTechnician,
      isRejected: isRejected,
      isSolved: isSolved,
      isCompleted: isCompleted,
      isNotCompleted: isNotCompleted,
      isDone: isDone,
      rejectedBy: rejectedBy,
      rejectedDate: rejectedDate,
      imageCount: imageCount,
      images: images.map((imageModel) => imageModel.toEntity()).toList(),
    );
  }
}

class ComplainImageModel {
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
  final String updatedBy;
  final String updatedDate;
  final String file;

  ComplainImageModel({
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

  factory ComplainImageModel.fromJson(Map<String, dynamic> json) {
    return ComplainImageModel(
      id: json['id'],
      fileName: json['fileName'],
      actualFileName: json['actualFileName'],
      fileSize: json['fileSize'],
      filePath: json['filePath'],
      fileType: json['fileType'],
      complainID: json['complainID'],
      complainInfoID: json['complainInfoID'],
      agencyID: json['agencyID'],
      propertyID: json['propertyID'],
      createdBy: json['createdBy'],
      flag: json['flag'],
      imageGroupKey: json['imageGroupKey'],
      createdDate: json['createdDate'],
      updatedBy: json['updatedBy'],
      updatedDate: json['updatedDate'],
      file: json['file'],
    );
  }

  ComplainImageEntity toEntity() {
    return ComplainImageEntity(
      id: id,
      fileName: fileName,
      actualFileName: actualFileName,
      fileSize: fileSize,
      filePath: filePath,
      fileType: fileType,
      complainID: complainID,
      complainInfoID: complainInfoID,
      agencyID: agencyID,
      propertyID: propertyID,
      createdBy: createdBy,
      flag: flag,
      imageGroupKey: imageGroupKey,
      createdDate: createdDate,
      updatedBy: updatedBy,
      updatedDate: updatedDate,
      file: file,
    );
  }
}
