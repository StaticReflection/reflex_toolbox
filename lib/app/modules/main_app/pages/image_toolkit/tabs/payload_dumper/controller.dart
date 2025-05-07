import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/model/partition.dart';
import 'package:reflex_toolbox/app/global_widgets/prompt_dialog.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/image_toolkit/tabs/payload_dumper/local_widgets/dumping_dialog.dart';
import 'package:reflex_toolbox/app/services/payload_dumper/service.dart';

class PayloadDumperTabController extends GetxController {
  late final PayloadDumperService _payloadDumperService;

  final filePathInputController = TextEditingController();
  final partitions = <Partition>[].obs;
  final selectedPartitions = <Partition>[].obs;

  final RxString filePath = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    _payloadDumperService = Get.find<PayloadDumperService>();
    super.onInit();
  }

  void onDragDone(DropDoneDetails details) {
    final file = details.files.first;
    if (!file.path.endsWith('.bin')) {
      Get.dialog(PromptDialog('limitedFormatPrompt'.tr));
      return;
    }
    _updateFile(file.path);
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['bin'],
    );
    if (result != null) {
      _updateFile(result.files.single.path ?? '');
    }
  }

  Future<void> _updateFile(String path) async {
    filePath.value = path;
    filePathInputController.text = path;

    partitions.assignAll(await _payloadDumperService.getPartitionList(path));
    selectedPartitions.clear();
  }

  void toggleAll() {
    if (isAllSelected) {
      selectedPartitions.clear();
    } else {
      selectedPartitions.assignAll(partitions);
    }
  }

  void togglePartition(Partition partition) {
    if (selectedPartitions.contains(partition)) {
      selectedPartitions.remove(partition);
    } else {
      selectedPartitions.add(partition);
    }
  }

  bool get isAllSelected => selectedPartitions.length == partitions.length;

  Future<void> dumpPartitions(List<Partition> partitionList) async {
    final outputPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'selectOutputDirectory'.tr,
      lockParentWindow: true,
    );
    if (outputPath == null) return;

    Get.dialog(DumpingDialog(partitionList), barrierDismissible: false);

    try {
      if (partitionList.length == partitions.length) {
        await _payloadDumperService.dumpAllPartitions(
          filePath: filePath.value,
          outputPath: outputPath,
        );
      } else {
        await _payloadDumperService.dumpPartitions(
          filePath: filePath.value,
          partitionList: partitionList,
          outputPath: outputPath,
        );
      }
    } finally {
      Get.back();
    }
  }

  Future<void> dumpSelectedPartitions() async {
    await dumpPartitions(selectedPartitions.toList());
  }
}
