import '../../../domain/entities/complain_entity.dart';
import 'complain_image_model.dart';

class ComplainModel {
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
  final String? rejectedBy;
  final String? rejectedDate;
  final int? imageCount;
  final List<ComplainImageModel>? images;

  ComplainModel({
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
      images: images!.map((imageModel) => imageModel.toEntity()).toList(),
    );
  }

  factory ComplainModel.fromEntity(ComplainEntity entity) {
    return ComplainModel(
      id: entity.id,
      complainInfoID: entity.complainInfoID,
      complainID: entity.complainID,
      complainName: entity.complainName,
      segmentID: entity.segmentID,
      segmentName: entity.segmentName,
      segmentLength: entity.segmentLength,
      segmentWidth: entity.segmentWidth,
      agencyID: entity.agencyID,
      description: entity.description,
      itemID: entity.itemID,
      itemName: entity.itemName,
      propertyID: entity.propertyID,
      propertyName: entity.propertyName,
      landlordID: entity.landlordID,
      landlordName: entity.landlordName,
      tenantID: entity.tenantID,
      tenantName: entity.tenantName,
      comments: entity.comments,
      lastComments: entity.lastComments,
      currentComments: entity.currentComments,
      feedback: entity.feedback,
      ticketNo: entity.ticketNo,
      isResubmitted: entity.isResubmitted,
      countOfRecomplained: entity.countOfRecomplained,
      isSentToLandlord: entity.isSentToLandlord,
      isAssignedTechnician: entity.isAssignedTechnician,
      isRejected: entity.isRejected,
      isSolved: entity.isSolved,
      isCompleted: entity.isCompleted,
      isNotCompleted: entity.isNotCompleted,
      isDone: entity.isDone,
      rejectedBy: entity.rejectedBy,
      rejectedDate: entity.rejectedDate,
      imageCount: entity.imageCount,
      images: entity.images?.map((img) => ComplainImageModel.fromEntity(img)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complainInfoID': complainInfoID,
      'complainID': complainID,
      'complainName': complainName,
      'segmentID': segmentID,
      'segmentName': segmentName,
      'segmentLength': segmentLength,
      'segmentWidth': segmentWidth,
      'agencyID': agencyID,
      'description': description,
      'itemID': itemID,
      'itemName': itemName,
      'propertyID': propertyID,
      'propertyName': propertyName,
      'landlordID': landlordID,
      'landlordName': landlordName,
      'tenantID': tenantID,
      'tenantName': tenantName,
      'comments': comments,
      'lastComments': lastComments,
      'currentComments': currentComments,
      'feedback': feedback,
      'ticketNo': ticketNo,
      'isResubmitted': isResubmitted,
      'countOfRecomplained': countOfRecomplained,
      'isSentToLandlord': isSentToLandlord,
      'isAssignedTechnician': isAssignedTechnician,
      'isRejected': isRejected,
      'isSolved': isSolved,
      'isCompleted': isCompleted,
      'isNotCompleted': isNotCompleted,
      'isDone': isDone,
      'rejectedBy': rejectedBy,
      'rejectedDate': rejectedDate,
      'imageCount': imageCount,
      'images': images?.map((img) => img.toJson()).toList(),
    };
  }

}
