import 'dart:async';

import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/app/data/value/model/device_info.dart';
import 'package:reflex_toolbox/app/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/app/extensions/device_status.dart';
import 'package:reflex_toolbox/app/global_widgets/prompt_dialog.dart';
import 'package:reflex_toolbox/app/services/log/service.dart';
import 'package:reflex_toolbox/app/services/platform_tools/adb_info.dart';
import 'package:reflex_toolbox/app/services/platform_tools/fastboot_info.dart';
import 'package:reflex_toolbox/app/utils/platform_tools/util.dart';

class PlatformToolsService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'PlatformToolsService';

  final deviceList = <DeviceInfo>[].obs;
  final currentSelectedDevice = Rxn<DeviceInfo>();

  @override
  void onInit() {
    _logService = Get.find<LogService>();

    autoRefreshDeviceList();

    _logService.debug(_tag, 'Initialization completed');

    super.onInit();
  }

  Future<PlatformToolsService> init() async {
    return this;
  }

  @override
  void onClose() {
    PlatformToolsUtil.adb.killServer();
    super.onClose();
  }

  Future<void> autoRefreshDeviceList() async {
    Timer.periodic(Duration(seconds: 3), (timer) => refreshDeviceList());
  }

  Future<void> refreshDeviceList() async {
    _logService.debug(_tag, 'Refresh device list');

    final adbDevices = await PlatformToolsUtil.adb.getDeviceList();
    final fastbootDevices = await PlatformToolsUtil.fastboot.getDeviceList();

    deviceList.value = [...adbDevices, ...fastbootDevices].toList();

    _logService.trace(_tag, 'Device list: $deviceList');

    if (deviceList.isEmpty) {
      currentSelectedDevice.value = null;
    } else if (currentSelectedDevice.value == null ||
        !deviceList.contains(currentSelectedDevice.value)) {
      currentSelectedDevice.value = deviceList.first;
    }

    getCurrentDeviceInfo();
  }

  void changeSelectedDevice(DeviceInfo? device) {
    currentSelectedDevice.value = device;
    getCurrentDeviceInfo();
  }

  Future<void> connectWirelessly(String ip, String code) async {
    final ExecuteResult result =
        (code.isEmpty)
            ? await PlatformToolsUtil.adb.connect(ip)
            : await PlatformToolsUtil.adb.pair(ip, code);
    if (result.success) {
      Get.dialog(PromptDialog(result.output!));
    }
  }

  Future<void> powerAction(PowerActions action) async {
    final device = currentSelectedDevice.value;
    if (device == null) return;

    if (device.status.isAdbMode) {
      await PlatformToolsUtil.adb.powerAction(device.serial, action);
    } else if (device.status.isFastbootMode) {
      await PlatformToolsUtil.fastboot.powerAction(device.serial, action);
    } else {
      Get.dialog(PromptDialog('deviceStatusError'.tr));
    }
  }

  Future<void> getCurrentDeviceInfo() async {
    final device = currentSelectedDevice.value;
    if (device == null) return;
    if (device.status.isAdbMode) {
      await Future.wait([
        AdbInfoExtension(this).getDeviceInfoProperties(device),
        AdbInfoExtension(this).getBatteryLevel(device),
        AdbInfoExtension(this).getenforce(device),
        AdbInfoExtension(this).getKernelVersion(device),
      ]);

      device.storageInfo = await getStorageInfo(device.serial);
      device.memoryInfo = await getMemoryInfo(device.serial);
    } else {
      device.fastbootInfo = await FastbootInfoExtension(this).getvarAll();
    }
    currentSelectedDevice.refresh();
  }

  Future<void> reconnectOffline() async {
    await PlatformToolsUtil.adb.reconnectOffline();
    await refreshDeviceList();
  }
}
