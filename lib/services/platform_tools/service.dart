import 'dart:async';

import 'package:get/get.dart';
import 'package:reflex_toolbox/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/extensions/device_status.dart';
import 'package:reflex_toolbox/global_widgets/prompt_dialog.dart';
import 'package:reflex_toolbox/services/log/service.dart';
import 'package:reflex_toolbox/services/platform_tools/adb_info.dart';
import 'package:reflex_toolbox/services/platform_tools/fastboot_info.dart';
import 'package:reflex_toolbox/utils/platform_tools/util.dart';

class PlatformToolsService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'PlatformToolsService';

  final deviceList = <DeviceInfo>[].obs;
  final currentSelectedDevice = Rxn<DeviceInfo>();

  @override
  void onInit() async {
    _logService = Get.find<LogService>();

    await PlatformToolsUtil.adb.startServer();

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

  Future<void> refreshDeviceList() async {
    _logService.debug(_tag, 'Refresh device list');

    final adbDevices = PlatformToolsUtil.adb.getDeviceList();
    final fastbootDevices = PlatformToolsUtil.fastboot.getDeviceList();

    deviceList.value = [...await adbDevices, ...await fastbootDevices].toList();

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
      Get.dialog(PromptDialog(result.output));
    }
  }

  Future<void> powerAction(PowerActions action) async {
    _logService.debug(_tag, 'Power action: ${action.name}');

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
      getDeviceInfoProperties(device);

      final batteryFuture = getBatteryLevel(device.serial, device.status);
      final kernelFuture = getKernelVersion(device.serial);
      final selinuxFuture = getenforce(device.serial);
      final storageFuture = getStorageInfo(device.serial);
      final memoryFuture = getMemoryInfo(device.serial);

      device.batteryLevel = await batteryFuture;
      device.kernelVersion = await kernelFuture;
      device.selinuxMode = await selinuxFuture;
      device.storageInfo = await storageFuture;
      device.memoryInfo = await memoryFuture;
    } else {
      device.fastbootInfo = await getvarAll(device.serial);
    }
    currentSelectedDevice.refresh();
  }

  Future<void> reconnectOffline() async {
    await PlatformToolsUtil.adb.reconnectOffline();
    await refreshDeviceList();
  }
}
