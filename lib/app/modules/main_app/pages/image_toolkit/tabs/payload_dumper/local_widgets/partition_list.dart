import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/image_toolkit/tabs/payload_dumper/controller.dart';

class _DetailRow extends StatelessWidget {
  final bool checked;
  final String title;
  final String size;
  final VoidCallback action;
  final VoidCallback onCheck;

  const _DetailRow({
    required this.checked,
    required this.title,
    required this.size,
    required this.action,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Checkbox(value: checked, onChanged: (_) => onCheck()),
          Expanded(child: Text(title)),
          SelectableText(size),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: action,
          ),
        ],
      ),
    );
  }
}

class PartitionList extends GetView<PayloadDumperTabController> {
  const PartitionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _DetailRow(
            checked: controller.isAllSelected,
            title: 'partitionName'.tr,
            size: 'size'.tr,
            action: controller.dumpSelectedPartitions,
            onCheck: controller.toggleAll,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Obx(
            () => ListView.separated(
              itemCount: controller.partitions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final partition = controller.partitions[index];
                return Obx(
                  () => _DetailRow(
                    checked: controller.selectedPartitions.contains(partition),
                    title: partition.name,
                    size: partition.size,
                    action: () => controller.dumpPartitions([partition]),
                    onCheck: () => controller.togglePartition(partition),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
