import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/local_widgets/partition_list.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/local_widgets/payload_picker.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/local_widgets/unselect_payload_hint.dart';

class PayloadDumperTab extends GetView<PayloadDumperTabController> {
  const PayloadDumperTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: controller.onDragDone,
      child: Column(
        children: [
          PayloadPicker(),
          Expanded(
            child: SizedBox.expand(
              child: Obx(
                () =>
                    controller.filePath.value.isEmpty
                        ? UnselectPayloadHint()
                        : PartitionList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
