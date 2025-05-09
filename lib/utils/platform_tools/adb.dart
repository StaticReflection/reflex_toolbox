import 'package:get/get.dart';
import 'package:reflex_toolbox/data/providers/executable.dart';
import 'package:reflex_toolbox/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/extensions/device_status.dart';
import 'package:reflex_toolbox/services/isolate_execute/service.dart';
import 'package:reflex_toolbox/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';

class Adb {
  final String _adbPath = ExecutableProvider.adbPath;

  Future<ExecuteResult> _execute(List<String> arguments) async {
    String tag = 'Adb$arguments';

    if (Get.isRegistered(tag: tag)) {
      await Get.delete(tag: tag);
    }

    ExecuteService service = await Get.putAsync<ExecuteService>(
      () => ExecuteService().init(),
      tag: tag,
    );

    return await service.startExecution(_adbPath, arguments);
  }

  Future startServer() async {
    await _execute(['start-server']);
  }

  Future killServer() async {
    await _execute(['kill-server']);
  }

  Future restartServer() async {
    await killServer();
    await startServer();
  }

  Future<List<DeviceInfo>> getDeviceList() async {
    final result = await _execute(['devices']);
    if (!result.success) return [];

    return result.output
        .split('\n')
        .skip(1)
        .map((line) => line.trim().split('\t'))
        .where((splitLine) => splitLine.length == 2)
        .map((splitLine) {
          final serial = splitLine[0];
          final statusStr = splitLine[1];

          DeviceStatus status = DeviceStatusExtension.fromString(statusStr);

          return DeviceInfo(serial: serial, status: status);
        })
        .toList();
  }

  //  shell
  Future<ExecuteResult> shell(String serial, String command) async {
    ExecuteResult result = await _execute(['-s', serial, 'shell', command]);

    if (RegExp(
      r"^adb\.exe: device '(.+)' not found$",
    ).hasMatch(result.output)) {
      return ExecuteResult(success: false, output: 'no device found');
    }

    if (RegExp(r"^adb\.exe: device offline$").hasMatch(result.output)) {
      return ExecuteResult(success: false, output: 'device offline');
    }

    return result;
  }

  // adb connect [ipAddress]
  Future<ExecuteResult> connect(String ipAddress) async {
    return await _execute(['connect', ipAddress]);
  }

  // adb connect [ipAddress] [pairingCode]
  Future<ExecuteResult> pair(String ipAddress, String pairingCode) async {
    return await _execute(['pair', ipAddress, pairingCode]);
  }

  // adb reconnect offline
  Future<ExecuteResult> reconnectOffline() async {
    return await _execute(['reconnect', 'offline']);
  }

  // 电源操作
  Future<ExecuteResult> powerAction(String serial, PowerActions action) async {
    String argument = '';
    switch (action) {
      case PowerActions.powerOff:
        argument = '-p';
        break;
      case PowerActions.reboot:
        break;
      case PowerActions.rebootToFastbootd:
        argument = 'fastboot';
        break;
      case PowerActions.rebootToRecovery:
        argument = 'recovery';
        break;
      case PowerActions.rebootToBootloader:
        argument = 'bootloader';
        break;
    }

    return await _execute(['-s', serial, 'shell', 'reboot', argument]);
  }
}
