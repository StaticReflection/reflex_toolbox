import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/extensions/device_status.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/controller.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/local_widgets/battery_level_card.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/local_widgets/system_resources_card.dart';

class _DetailRow extends StatelessWidget {
  final String title;
  final String? value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          title: SelectableText(
            title,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
          trailing: SelectableText(
            value ?? 'unknown'.tr,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _AdbInfo extends GetView<HomePageController> {
  const _AdbInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        IntrinsicHeight(
          child: Row(
            spacing: 12,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: BatteryLevelCard(
                  controller.currentSelectedDevice.value?.batteryLevel,
                ),
              ),
              Expanded(child: SystemResourcesCard()),
            ],
          ),
        ),
        Divider(height: 1),
        Expanded(
          child: ListView(
            children: [
              _DetailRow(
                title: 'deviceBand'.tr,
                value: controller.currentSelectedDevice.value?.band,
              ),
              _DetailRow(
                title: 'deviceSerial'.tr,
                value: controller.currentSelectedDevice.value?.serial,
              ),
              _DetailRow(
                title: 'deviceModel'.tr,
                value: controller.currentSelectedDevice.value?.model,
              ),
              _DetailRow(
                title: 'deviceBuildVersion'.tr,
                value: controller.currentSelectedDevice.value?.buildVersion,
              ),
              _DetailRow(
                title: 'deviceAbi'.tr,
                value: controller.currentSelectedDevice.value?.abi,
              ),
              _DetailRow(
                title: 'selinux'.tr,
                value: controller.currentSelectedDevice.value?.selinuxMode,
              ),
              _DetailRow(
                title: 'deviceCodeName'.tr,
                value: controller.currentSelectedDevice.value?.codeName,
              ),
              _DetailRow(
                title: 'deviceAndroidVersion'.tr,
                value: controller.currentSelectedDevice.value?.androidVersion,
              ),
              _DetailRow(
                title: 'deviceKernelVersion'.tr,
                value: controller.currentSelectedDevice.value?.kernelVersion,
              ),
              _DetailRow(
                title: 'deviceSlot'.tr,
                value: controller.currentSelectedDevice.value?.slot,
              ),
              _DetailRow(
                title: 'deviceVndk'.tr,
                value: controller.currentSelectedDevice.value?.vndk,
              ),
              _DetailRow(
                title: 'cpu'.tr,
                value: controller.currentSelectedDevice.value?.cpu,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FastbootInfo extends GetView<HomePageController> {
  const _FastbootInfo();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.currentSelectedDevice.value?.fastbootInfo == null
          ? Center(child: Text("noFastbootInfoAvailable".tr))
          : ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount:
                controller.currentSelectedDevice.value?.fastbootInfo?.length,
            itemBuilder: (BuildContext context, int index) {
              return _DetailRow(
                title:
                    controller
                        .currentSelectedDevice
                        .value
                        ?.fastbootInfo?[index]
                        .name
                        .tr ??
                    'unknown'.tr,
                value:
                    controller
                        .currentSelectedDevice
                        .value
                        ?.fastbootInfo?[index]
                        .value,
              );
            },
          );
    });
  }
}

class _DeviceInfoHeader extends GetView<HomePageController> {
  const _DeviceInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  controller.currentSelectedDevice.value?.marketName ??
                      controller.currentSelectedDevice.value?.model ??
                      controller.currentSelectedDevice.value?.serial ??
                      'unknown'.tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Row(
              children: [
                PopupMenuButton(
                  tooltip: 'powerActions'.tr,
                  icon: Icon(Icons.power_settings_new),
                  onSelected: controller.powerAction,
                  itemBuilder: (context) {
                    return controller.powerActions
                        .map(
                          (powerAction) => PopupMenuItem(
                            value: powerAction,
                            child: Text(powerAction.name.tr),
                          ),
                        )
                        .toList();
                  },
                ),
                Tooltip(
                  message: 'refreshDeviceInfo'.tr,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: controller.getCurrentDeviceInfo,
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DeviceInfo extends GetView<HomePageController> {
  const DeviceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DeviceInfoHeader(),
        Divider(height: 1),
        Expanded(
          child: Obx(
            () =>
                controller.currentSelectedDevice.value?.status.isAdbMode == true
                    ? _AdbInfo()
                    : _FastbootInfo(),
          ),
        ),
      ],
    );
  }
}
