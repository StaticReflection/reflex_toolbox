import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/controller.dart';
import 'package:reflex_toolbox/app/modules/main_app/local_widgets/bar.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/page.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/image_toolkit/page.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/settings/page.dart';

class MainAppPage extends GetView<MainAppPageController> {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MainAppPageBar(),
      ),
      body: Row(
        children: [
          Obx(
            () => NavigationDrawer(
              selectedIndex: controller.index.value,
              onDestinationSelected: controller.changePage,
              children: [
                NavigationDrawerDestination(
                  icon: Icon(Icons.home),
                  label: Text('home'.tr),
                ),
                NavigationDrawerDestination(
                  icon: Icon(Icons.apps),
                  label: Text('imageToolkit'.tr),
                ),
                NavigationDrawerDestination(
                  icon: Icon(Icons.settings),
                  label: Text('settings'.tr),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Obx(
                () => IndexedStack(
                  index: controller.index.value,
                  children: [HomePage(), ImageToolkitPage(), SettingsPage()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
