import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/controller.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/home/controller.dart';
import 'package:reflex_toolbox/app/modules/main_app/pages/settings/controller.dart';

class MainAppPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppPageController>(() => MainAppPageController());
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<SettingsPageController>(() => SettingsPageController());
  }
}
