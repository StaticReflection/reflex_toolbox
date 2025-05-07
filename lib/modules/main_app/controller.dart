import 'package:get/get.dart';
import 'package:reflex_toolbox/services/app_window/service.dart';

class MainAppPageController extends GetxController {
  late final AppWindowService _appWindowService;

  RxInt index = 0.obs;

  @override
  void onInit() {
    _appWindowService = Get.find<AppWindowService>();
    super.onInit();
  }

  void changePage(int newPageIndex) {
    index.value = newPageIndex;
  }

  void close() {
    _appWindowService.close();
  }

  void minimize() {
    _appWindowService.minimize();
  }

  void maximizeOrRestore() {
    _appWindowService.maximizeOrRestore();
  }
}
