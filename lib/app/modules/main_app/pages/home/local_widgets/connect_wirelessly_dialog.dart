import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/controller.dart';

class ConnectWirelesslyList extends GetView<HomePageController> {
  const ConnectWirelesslyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(right: 12),
          title: Text(
            'history'.tr,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
          trailing: Tooltip(
            message: 'removeAll'.tr,
            child: IconButton(
              onPressed: controller.clearWirelessConnectionHistory,
              icon: Icon(Icons.delete),
            ),
          ),
        ),
        Divider(),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                children:
                    controller.wirelessConnectionHistory
                        .map(
                          (ipAddress) => ListTile(
                            onTap:
                                () =>
                                    controller.connectWirelessly(ipAddress, ''),
                            contentPadding: EdgeInsets.only(right: 12),
                            dense: true,
                            title: Text(ipAddress),
                            trailing: IconButton(
                              onPressed:
                                  () => controller
                                      .deleteWirelessConnectionHistory(
                                        ipAddress,
                                      ),
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConnectWirelesslyDialog extends GetView<HomePageController> {
  const ConnectWirelesslyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController ipAddressTextEditController = TextEditingController();
    TextEditingController portTextEditController = TextEditingController();

    return AlertDialog(
      title: Text('connectWirelessly'.tr),
      content: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'connectWirelesslyPrompt'.tr,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Flexible(
                flex: 3,
                child: TextField(
                  controller: ipAddressTextEditController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.:]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${'ipAddress'.tr}:${'port'.tr}',
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  controller: portTextEditController,

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'pairingCode'.tr,
                  ),
                ),
              ),
            ],
          ),
          ConnectWirelesslyList(),
        ],
      ),
      actions: [
        FilledButton(
          onPressed:
              () => controller.connectWirelessly(
                ipAddressTextEditController.text,
                portTextEditController.text,
              ),
          child: Text('connect'.tr),
        ),
        ElevatedButton(onPressed: Get.back, child: Text('cancel'.tr)),
      ],
    );
  }
}
