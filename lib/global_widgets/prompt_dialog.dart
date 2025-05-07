import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromptDialog extends StatelessWidget {
  final String content;

  const PromptDialog(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('prompt'.tr),
      content: SelectableText(content),
      actions: [FilledButton(onPressed: Get.back, child: Text('ok'.tr))],
    );
  }
}
