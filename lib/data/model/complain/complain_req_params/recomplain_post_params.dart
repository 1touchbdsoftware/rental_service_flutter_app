import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ReComplainParams {
  final String complainID;
  final String feedback;
  final List<File>? images;

  ReComplainParams({
    required this.complainID,
    required this.feedback,
    this.images,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Add text fields
    formData.fields.add(MapEntry('ComplainID', complainID));
    formData.fields.add(MapEntry('Feedback', feedback));

    // Add image files if available
    if (images != null && images!.isNotEmpty) {
      for (int i = 0; i < images!.length; i++) {
        final file = images![i];
        final fileName = file.path.split('/').last;

        formData.files.add(MapEntry(
          'Images',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'), // Adjust based on your file type
          ),
        ));
      }
    }

    return formData;
  }
}