import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/data/value/config/window.dart';
import 'package:reflex_toolbox/global_widgets/close_app_dialog.dart';
import 'package:reflex_toolbox/services/log/service.dart';

class AppWindowService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'AppWindowService';

  Future<AppWindowService> init() async {
    return this;
  }

  @override
  void onInit() {
    _logService = Get.find<LogService>();

    _logService.debug(_tag, 'Initialize app window');
    doWhenWindowReady(() {
      appWindow.minSize = AppWindowConfig.minimumSize;
      appWindow.size = AppWindowConfig.initialSize;
      appWindow.alignment = AppWindowConfig.initialAlignment;
      appWindow.show();
    });

    _logService.debug(_tag, 'Initialization completed');

    super.onInit();
  }

  Future<void> close() async {
    _logService.debug(_tag, 'Open CloseAppDialog');

    Get.dialog(CloseAppDialog());
  }

  void maximizeOrRestore() {
    _logService.debug(_tag, 'Maximize window Or Restore');
    appWindow.maximizeOrRestore();
  }

  void minimize() {
    _logService.debug(_tag, 'Minimize window');
    appWindow.minimize();
  }
}
