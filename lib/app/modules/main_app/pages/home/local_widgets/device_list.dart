import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/controller.dart';

class DeviceListWidget extends GetView<HomePageController> {
  const DeviceListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'deviceList'.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Tooltip(
              message: 'reconnectOffline'.tr,
              child: IconButton(
                onPressed: controller.reconnectOffline,
                icon: Icon(Icons.settings_backup_restore),
              ),
            ),
            Tooltip(
              message: 'connectWirelessly'.tr,
              child: IconButton(
                onPressed: controller.openConnectWirelesslyDialog,
                icon: Icon(Icons.phonelink),
              ),
            ),
            Tooltip(
              message: 'refreshDeviceList'.tr,
              child: IconButton(
                onPressed: controller.refreshDeviceList,
                icon: Icon(Icons.refresh),
              ),
            ),
          ],
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Obx(
              () => ListView.separated(
                itemCount: controller.deviceList.length,
                separatorBuilder:
                    (BuildContext context, int index) => Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => RadioListTile(
                      title: Text(
                        controller.deviceList[index].serial,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        controller.deviceList[index].status.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      value: controller.deviceList[index],
                      groupValue: controller.currentSelectedDevice.value,
                      onChanged: controller.changeSelectedDevice,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
