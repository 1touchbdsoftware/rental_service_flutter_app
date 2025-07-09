
import 'package:flutter/material.dart';

Widget buildWelcomeText() {
  return const Column(
    children: [
      Text(
        'Welcome',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10),
      Text(
        'Sign in to continue',
        style: TextStyle(color: Colors.white70, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ],
  );
}