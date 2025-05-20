// lib/data/model/complain/complain_edit_post_params.dart

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ComplainEditPostParams {
  final String propertyID;
  final String complainID;
  final String agencyID;
  final String segmentID;
  final String complainName;
  final String updatedBy;
  final List<File>? images;

  ComplainEditPostParams({
    required this.propertyID,
    required this.agencyID,
    required this.complainID,
    required this.segmentID,
    required this.complainName,
    required this.updatedBy,
    this.images,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Add text fields
    formData.fields.add(MapEntry('propertyID', propertyID));
    formData.fields.add(MapEntry('agencyID', agencyID));
    formData.fields.add(MapEntry('segmentID', segmentID));
    formData.fields.add(MapEntry('complainName', complainName));
    formData.fields.add(MapEntry('updatedBy', updatedBy));
    formData.fields.add(MapEntry('complainID', complainID));

    // Add image files if available
    if (images != null && images!.isNotEmpty) {
      for (int i = 0; i < images!.length; i++) {
        final file = images![i];
        final fileName = file.path.split('/').last;

        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'), // Adjust according to your file type
          ),
        ));
      }
    }

    return formData;
  }
}