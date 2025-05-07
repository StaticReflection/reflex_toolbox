import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/settings/controller.dart';

class LanguageSetting extends GetView<SettingsPageController> {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('languages'.tr),
      trailing: DropdownButton(
        value: controller.currentLanguage.value,
        items:
            controller.supportedLanguages
                .map(
                  (language) =>
                      DropdownMenuItem(value: language, child: Text(language)),
                )
                .toList(),
        onChanged: controller.changeLanguage,
      ),
    );
  }
}
