
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