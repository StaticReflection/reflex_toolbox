import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/home/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/settings/controller.dart';

class MainAppPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppPageController>(() => MainAppPageController());

    Get.lazyPut<HomePageController>(() => HomePageController());

    Get.lazyPut<ImageToolkitPageController>(() => ImageToolkitPageController());
    Get.lazyPut<PayloadDumperTabController>(() => PayloadDumperTabController());

    Get.lazyPut<SettingsPageController>(() => SettingsPageController());
  }
}
