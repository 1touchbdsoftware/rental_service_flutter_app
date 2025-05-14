
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ComplainInfo {
  final String agencyID;
  final String propertyID;

  ComplainInfo({required this.agencyID, required this.propertyID});

  Map<String, dynamic> toJson() => {
    'agencyID': agencyID,
    'propertyID': propertyID,
  };
}


class Complain {
  final String propertyID;
  final String agencyID;
  final String segmentID;
  final String itemID;
  final String complainName;
  final String description;

  Complain({
    required this.propertyID,
    required this.agencyID,
    required this.segmentID,
    required this.itemID,
    required this.complainName,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'propertyID': propertyID,
    'agencyID': agencyID,
    'segmentID': segmentID,
    'itemID': itemID,
    'complainName': complainName,
    'description': description,
  };
}

class ComplainPostModel {
  final ComplainInfo complainInfo;
  final List<Complain> complains;
  final List<MultipartFile>? images;

  ComplainPostModel({
    required this.complainInfo,
    required this.complains,
    this.images,
  });

  Future<FormData> toFormData() async {
    final formMap = {
      'complainInfo': complainInfo.toJson(),
      'complains': complains.map((e) => e.toJson()).toList(),
    };

    final formDataMap = <String, dynamic>{
      'json': MultipartFile.fromString(
        jsonEncode(formMap),
        filename: 'data.json',
        contentType: MediaType('application', 'json'),
      )
    };

    if (images != null && images!.isNotEmpty) {
      for (int i = 0; i < images!.length; i++) {
        formDataMap['images[$i]'] = images![i];
      }
    }

    return FormData.fromMap(formDataMap);
  }
}

