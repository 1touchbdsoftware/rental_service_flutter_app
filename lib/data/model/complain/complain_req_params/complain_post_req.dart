
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ComplainInfo {
  final String agencyID;
  final String propertyID;
  final String tenantID;

  ComplainInfo({required this.agencyID, required this.propertyID, required this.tenantID});

  Map<String, dynamic> toJson() => {
    'agencyID': agencyID,
    'propertyID': propertyID,
    'tenantID': tenantID
  };
}


class Complain {
  final String tenantID;
  final String propertyID;
  final String agencyID;
  final String segmentID;
  final String complainName;
  final List<File>? imageFiles;

  Complain({
    required this.tenantID,
    required this.propertyID,
    required this.agencyID,
    required this.segmentID,
    required this.complainName,
    this.imageFiles,
  });

  //only for testing purpose
  Map<String, dynamic> toJson() => {
    'tenantID': tenantID,
    'propertyID': propertyID,
    'agencyID': agencyID,
    'segmentID': segmentID,
    'complainName': complainName,
  };

  @override
  String toString() {
    return 'Complain(propertyID: $propertyID, agencyID: $agencyID, segmentID: $segmentID, complainName: $complainName, images: ${imageFiles?.length ?? 0})';
  }
}


class ComplainPostModel {
  final ComplainInfo complainInfo;
  final List<Complain> complains;

  ComplainPostModel({
    required this.complainInfo,
    required this.complains,
  });

  Map<String, dynamic> toJson() {
    return {
      'complainInfo': complainInfo.toJson(),
      'complains': complains.map((e) => e.toJson()).toList(),
    };
  }

  // No longer need FormData since we're sending everything as JSON
  // Convert the entire model to JSON directly
  String toJsonString() {
    return jsonEncode(toJson());
  }


  Future<FormData> toFormData() async {
    final formData = FormData();

    // Add complainInfo fields
    formData.fields.add(MapEntry('complainInfo.agencyID', complainInfo.agencyID));
    formData.fields.add(MapEntry('complainInfo.propertyID', complainInfo.propertyID));
    formData.fields.add(MapEntry('complainInfo.tenantID', complainInfo.tenantID));
    // Add any other complainInfo fields that might be required
    formData.fields.add(MapEntry('complainInfo.id', '0'));
    formData.fields.add(MapEntry('complainInfo.stateStatus', 'Pending'));

    // Add complain fields for each complain
    for (int i = 0; i < complains.length; i++) {
      final complain = complains[i];

      // Add basic complain fields with correct bracket notation
      formData.fields.add(MapEntry('complains[$i].tenantID', complain.tenantID));
      formData.fields.add(MapEntry('complains[$i].propertyID', complain.propertyID));
      formData.fields.add(MapEntry('complains[$i].agencyID', complain.agencyID));
      formData.fields.add(MapEntry('complains[$i].segmentID', complain.segmentID));
      formData.fields.add(MapEntry('complains[$i].complainName', complain.complainName));

      // Add additional fields to match Angular component
      formData.fields.add(MapEntry('complains[$i].description', 'description'));
      formData.fields.add(MapEntry('complains[$i].isActive', 'true'));
      formData.fields.add(MapEntry('complains[$i].isApproved', 'false'));
      formData.fields.add(MapEntry('complains[$i].isSolved', 'false'));
      formData.fields.add(MapEntry('complains[$i].stateStatus', 'Pending'));
      formData.fields.add(MapEntry('complains[$i].activationStatus', 'Active'));

      // Add images with the correct naming convention
      if (complain.imageFiles != null && complain.imageFiles!.isNotEmpty) {
        for (final file in complain.imageFiles!) {
          final fileName = file.path.split('/').last;

          // This is the key difference: Angular sends images as 'complains[index].images' without additional indices
          formData.files.add(MapEntry(
            'complains[$i].images',  // Remove the [j] index as per Angular implementation
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: MediaType.parse(_getMediaType(fileName)),
            ),
          ));
        }
      }
    }

    return formData;
  }

// Helper function to determine media type from filename
  String _getMediaType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg'; // default
    }
  }


  @override
  String toString() {
    return 'ComplainPostModel(complainInfo: $complainInfo, complains: $complains)';
  }
}