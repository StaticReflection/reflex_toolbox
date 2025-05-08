import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/services/platform_tools/service.dart';

class DeviceStatusWidget extends StatelessWidget {
  final List<DeviceStatus> status;
  final Widget child;

  const DeviceStatusWidget({
    required this.status,
    required this.child,
    super.key,
  });

  Rxn<DeviceInfo> get currentSelectedDevice =>
      Get.find<PlatformToolsService>().currentSelectedDevice;

  @override
  Widget build(BuildContext context) {
    Widget buildErrorText(String text) => Center(
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );

    return Obx(() {
      final device = currentSelectedDevice.value;
      if (device == null) {
        return buildErrorText('pleaseSelectTheDevice'.tr);
      }

      if (status.contains(device.status)) {
        return child;
      }

      switch (device.status) {
        case DeviceStatus.offline:
          return buildErrorText('deviceOffline'.tr);
        case DeviceStatus.recovery:
        case DeviceStatus.system:
          return buildErrorText('youNeedToRebootToFastboot'.tr);
        case DeviceStatus.unknown:
        default:
          return buildErrorText('unknownDeviceStatus'.tr);
      }
    });
  }
}
