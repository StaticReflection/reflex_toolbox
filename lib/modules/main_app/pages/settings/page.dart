import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/settings/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/settings/local_widgets/dark_mode_setting.dart';
import 'package:reflex_toolbox/modules/main_app/pages/settings/local_widgets/language_setting.dart';

class SettingsPage extends GetView<SettingsPageController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [const DarkModeSetting(), LanguageSetting(), Divider()],
    );
  }
}
