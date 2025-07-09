import 'package:flutter/cupertino.dart';

Widget buildLogo() {
  return Container(
    height: 70,
    width: 100,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('asset/images/pro_matrix_logo.png'),
        fit: BoxFit.contain,
      ),
    ),
  );
}
