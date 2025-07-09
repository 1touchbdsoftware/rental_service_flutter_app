
import 'package:flutter/material.dart';

Widget buildBackground(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('asset/images/building.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black87,
          BlendMode.darken,
        ),
      ),
    ),
  );
}
