import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnselectPayloadHint extends StatelessWidget {
  const UnselectPayloadHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${'selectAFile'.tr} (payload.bin)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'youCanDragTheFileIntoThisWindow'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
