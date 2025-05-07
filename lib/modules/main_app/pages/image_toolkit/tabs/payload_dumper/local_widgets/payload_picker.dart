import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/controller.dart';

class PayloadPicker extends GetView<PayloadDumperTabController> {
  const PayloadPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            controller: controller.filePathInputController,
            decoration: InputDecoration(labelText: 'filePath'.tr),
          ),
        ),
        FilledButton(
          onPressed: controller.selectFile,
          child: Text('select'.tr),
        ),
      ],
    );
  }
}
