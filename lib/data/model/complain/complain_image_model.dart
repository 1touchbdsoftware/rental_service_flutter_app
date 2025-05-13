
import '../../../domain/entities/complain_entity.dart';

class ComplainImageModel {
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

  ComplainImageModel({
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

  factory ComplainImageModel.fromEntity(ComplainImageEntity entity) {
    return ComplainImageModel(
      id: entity.id,
      fileName: entity.fileName,
      actualFileName: entity.actualFileName,
      fileSize: entity.fileSize,
      filePath: entity.filePath,
      fileType: entity.fileType,
      complainID: entity.complainID,
      complainInfoID: entity.complainInfoID,
      agencyID: entity.agencyID,
      propertyID: entity.propertyID,
      createdBy: entity.createdBy,
      flag: entity.flag,
      imageGroupKey: entity.imageGroupKey,
      createdDate: entity.createdDate,
      updatedBy: entity.updatedBy,
      updatedDate: entity.updatedDate,
      file: entity.file,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'actualFileName': actualFileName,
      'fileSize': fileSize,
      'filePath': filePath,
      'fileType': fileType,
      'complainID': complainID,
      'complainInfoID': complainInfoID,
      'agencyID': agencyID,
      'propertyID': propertyID,
      'createdBy': createdBy,
      'flag': flag,
      'imageGroupKey': imageGroupKey,
      'createdDate': createdDate,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate,
      'file': file,
    };
  }



}
