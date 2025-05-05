import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveLoading extends StatelessWidget {
  const AdaptiveLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? const CupertinoActivityIndicator(radius: 15)
          : const CircularProgressIndicator(),
    );
  }
}