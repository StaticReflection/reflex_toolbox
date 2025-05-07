import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/model/partition.dart';

class DumpingDialog extends StatelessWidget {
  final List<Partition> partitionList;

  const DumpingDialog(this.partitionList, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Center(
        child: Text(
          'dumpPartition'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: IntrinsicHeight(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320),
              child: Text(
                '${'partitionName'.tr}: ${partitionList.map((partition) => partition.name).toList().join(', ')}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
