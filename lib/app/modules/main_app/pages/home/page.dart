import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/app/global_widgets/device_status_widget.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/controller.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/local_widgets/device_info.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/local_widgets/device_list.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/local_widgets/screen_cast_button.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: DeviceStatusWidget(
            status: [
              DeviceStatus.device,
              DeviceStatus.fastboot,
              DeviceStatus.recovery,
            ],
            child: DeviceInfo(),
          ),
        ),
        SizedBox(
          width: 300,
          child: Column(
            children: [Expanded(child: DeviceListWidget()), ScreenCastButton()],
          ),
        ),
      ],
    );
  }
}
