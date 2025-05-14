
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

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
  final List<MultipartFile>? images;

  Complain({
    required this.tenantID,
    required this.propertyID,
    required this.agencyID,
    required this.segmentID,
    required this.complainName,
    this.images,
  });

  //only for testing purpose
  Map<String, dynamic> toJson() => {
    'tenantID': tenantID,
    'propertyID': propertyID,
    'agencyID': agencyID,
    'segmentID': segmentID,
    'complainName': complainName,
    'images': [],

  };

  @override
  String toString() {
    return 'Complain(propertyID: $propertyID, agencyID: $agencyID, segmentID: $segmentID, complainName: $complainName, images: ${images?.length ?? 0})';
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


  Future<FormData> toFormData() async {
    final formData = FormData();

    // Add complainInfo fields
    formData.fields.add(MapEntry('complainInfo[agencyID]', complainInfo.agencyID));
    formData.fields.add(MapEntry('complainInfo[propertyID]', complainInfo.propertyID));
    formData.fields.add(MapEntry('complainInfo[tenantID]', complainInfo.tenantID));

    // Add complains as fields
    for (int i = 0; i < complains.length; i++) {
      final complain = complains[i];
      formData.fields.add(MapEntry('complains[$i][tenantID]', complain.tenantID));
      formData.fields.add(MapEntry('complains[$i][propertyID]', complain.propertyID));
      formData.fields.add(MapEntry('complains[$i][agencyID]', complain.agencyID));
      formData.fields.add(MapEntry('complains[$i][segmentID]', complain.segmentID));
      formData.fields.add(MapEntry('complains[$i][complainName]', complain.complainName));



      // Add images
      if (complain.images != null && complain.images!.isNotEmpty) {
        for (int j = 0; j < complain.images!.length; j++) {
          final image = complain.images![j];
          formData.files.add(MapEntry(
            'complains[$i][images][$j]', // Adjust path format as needed by your API
            image,
          ));
        }
      }
    }

    // Also add the complete JSON as a separate field in case the API expects it that way
    formData.fields.add(MapEntry(
      'json',
      jsonEncode(toJson()),
    ));

    return formData;
  }


  @override
  String toString() {
    return 'ComplainPostModel(complainInfo: $complainInfo, complains: $complains)';
  }
}