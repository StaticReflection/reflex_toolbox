import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/settings/controller.dart';

class DarkModeSetting extends GetView<SettingsPageController> {
  const DarkModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SwitchListTile(
        title: Text('darkMode'.tr),
        value: controller.isDarkMode.value,
        onChanged: controller.toggleDarkMode,
      ),
    );
  }
}
