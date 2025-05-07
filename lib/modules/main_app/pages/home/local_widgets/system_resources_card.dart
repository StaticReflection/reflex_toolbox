import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/home/controller.dart';

class _Resource extends StatelessWidget {
  final String title;
  final double? total;
  final double? used;

  const _Resource({required this.title, required this.total, this.used});

  @override
  Widget build(BuildContext context) {
    final percentage = (total == null || used == null) ? null : used! / total!;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${used}G / ${total}G',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 8,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
            Text(
              percentage == null
                  ? 'unknown'.tr
                  : '${(percentage * 100).toStringAsFixed(1)}%',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ],
    );
  }
}

class SystemResourcesCard extends GetView<HomePageController> {
  const SystemResourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => _Resource(
                title: 'storage'.tr,
                total:
                    controller.currentSelectedDevice.value?.storageInfo?.total,
                used: controller.currentSelectedDevice.value?.storageInfo?.used,
              ),
            ),
            Obx(
              () => _Resource(
                title: 'ram'.tr,
                total:
                    controller.currentSelectedDevice.value?.memoryInfo?.total,
                used: controller.currentSelectedDevice.value?.memoryInfo?.used,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
