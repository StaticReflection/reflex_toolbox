import 'package:get/get.dart';
import 'package:reflex_toolbox/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/global_widgets/prompt_dialog.dart';
import 'package:reflex_toolbox/modules/main_app/pages/home/local_widgets/connect_wirelessly_dialog.dart';
import 'package:reflex_toolbox/services/app_storage/service.dart';
import 'package:reflex_toolbox/services/platform_tools/service.dart';
import 'package:reflex_toolbox/services/scrcpy/service.dart';

class HomePageController extends GetxController {
  late final PlatformToolsService _platformToolsService;
  late final ScrcpyService _scrcpyService;
  late final AppStorageService _appStorageService;

  RxList<DeviceInfo> get deviceList => _platformToolsService.deviceList;
  Rxn<DeviceInfo> get currentSelectedDevice =>
      _platformToolsService.currentSelectedDevice;
  List<PowerActions> get powerActions => PowerActions.values;
  RxList<String> get wirelessConnectionHistory =>
      _appStorageService.wirelessConnectionHistory;

  @override
  void onInit() {
    _platformToolsService = Get.find<PlatformToolsService>();
    _scrcpyService = Get.find<ScrcpyService>();
    _appStorageService = Get.find<AppStorageService>();

    super.onInit();
  }

  void refreshDeviceList() {
    _platformToolsService.refreshDeviceList();
  }

  void changeSelectedDevice(DeviceInfo? device) {
    _platformToolsService.changeSelectedDevice(device);
  }

  void openConnectWirelesslyDialog() {
    Get.dialog(ConnectWirelesslyDialog());
  }

  void connectWirelessly(String ipAddress, String pairingCode) {
    Get.back();
    _platformToolsService.connectWirelessly(ipAddress, pairingCode);

    if (!wirelessConnectionHistory.contains(ipAddress) &&
        ipAddress.isNotEmpty) {
      wirelessConnectionHistory.add(ipAddress);
    }
  }

  void deleteWirelessConnectionHistory(String ipAddress) {
    wirelessConnectionHistory.remove(ipAddress);
  }

  void clearWirelessConnectionHistory() {
    wirelessConnectionHistory.clear();
  }

  void screenCast() {
    if (currentSelectedDevice.value != null) {
      _scrcpyService.screenCast(currentSelectedDevice.value!.serial);
    } else {
      Get.dialog(PromptDialog('pleaseSelectTheDeviceFirst'.tr));
    }
  }

  void powerAction(PowerActions action) {
    _platformToolsService.powerAction(action);
  }

  void getCurrentDeviceInfo() {
    _platformToolsService.getCurrentDeviceInfo();
  }

  void reconnectOffline() {
    _platformToolsService.reconnectOffline();
  }
}
