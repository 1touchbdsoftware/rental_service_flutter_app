// Function to convert an image file to base64
import 'dart:convert';
import 'dart:io';

// Function to convert an image file to base64
Future<String> convertImageToBase64(File imageFile) async {
  // Read the file as bytes
  List<int> imageBytes = await imageFile.readAsBytes();

  // Convert bytes to base64 string
  String base64Image = base64Encode(imageBytes);

  // Return base64 string - prefix is added if needed below
  return base64Image;
}

// Example of how to use the above method to convert selected images for your form
Future<List<String>> processSelectedImages(List<File> imageFiles) async {
  List<String> base64Images = [];

  for (var imageFile in imageFiles) {
    // Get base64 string
    String base64String = await convertImageToBase64(imageFile);

    // Add prefix if your API requires it (uncomment if needed)
    // base64String = 'data:image/jpeg;base64,' + base64String;

    base64Images.add(base64String);
  }

  return base64Images;
}
