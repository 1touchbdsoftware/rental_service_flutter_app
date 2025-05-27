import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/model/complain/complain_image_model.dart';


void showImageDialog(BuildContext context, List<ComplainImageModel> images) {
  int currentIndex = 0;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8), // Optional outer spacing
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Slightly rounded corners
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),


              // Fullscreen image viewer
              Expanded(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Image.memory(
                    base64Decode(images[currentIndex].file!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Caption
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _generateCaption(images[currentIndex].imageGroupKey!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              // Grouped thumbnail list
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildGroupedThumbnails(images, currentIndex, (newIndex) {
                    setState(() => currentIndex = newIndex);
                  }),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

String _generateCaption(int imageGroupKey) {
  if (imageGroupKey == 100) {
    return 'Initial images';
  } else if (imageGroupKey % 200 == 0 && imageGroupKey >= 200) {
    int attempt = imageGroupKey ~/ 200;
    return 'Resolved at ${_getOrdinal(attempt)} attempt';
  } else if ((imageGroupKey - 100) % 200 == 0 && imageGroupKey >= 300) {
    int attempt = (imageGroupKey - 100) ~/ 200;
    return 'Resubmitted at ${_getOrdinal(attempt)} attempt';
  } else {
    return 'Unknown';
  }
}

String _getOrdinal(int number) {
  if (number >= 11 && number <= 13) {
    return '${number}th';
  }

  switch (number % 10) {
    case 1:
      return '${number}st';
    case 2:
      return '${number}nd';
    case 3:
      return '${number}rd';
    default:
      return '${number}th';
  }
}

List<Widget> _buildGroupedThumbnails(List<ComplainImageModel> images, int currentIndex, Function(int) onTap) {
  // Group images by caption
  Map<String, List<int>> groupedIndexes = {};

  for (int i = 0; i < images.length; i++) {
    String caption = _generateCaption(images[i].imageGroupKey!);
    if (!groupedIndexes.containsKey(caption)) {
      groupedIndexes[caption] = [];
    }
    groupedIndexes[caption]!.add(i);
  }

  List<Widget> groupWidgets = [];

  groupedIndexes.forEach((caption, indexes) {
    groupWidgets.add(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Group caption
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                caption,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Thumbnails for this group
            SizedBox(
              height: 70,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: indexes.map((index) {
                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: EdgeInsets.all(currentIndex == index ? 2 : 0),
                      decoration: BoxDecoration(
                        border: currentIndex == index
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.memory(
                          base64Decode(images[index].file!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  });

  return groupWidgets;
}