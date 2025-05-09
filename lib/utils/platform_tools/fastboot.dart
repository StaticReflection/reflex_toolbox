import 'package:get/get.dart';
import 'package:reflex_toolbox/data/providers/executable.dart';
import 'package:reflex_toolbox/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/services/isolate_execute/service.dart';

class Fastboot {
  final String _fastbootPath = ExecutableProvider.fastbootPath;

  Future<ExecuteResult> _execute(List<String> arguments) async {
    String tag = 'Fastboot$arguments';

    if (Get.isRegistered(tag: tag)) {
      await Get.delete(tag: tag);
    }

    ExecuteService service = await Get.putAsync<ExecuteService>(
      () => ExecuteService().init(),
      tag: tag,
    );

    return service.startExecution(_fastbootPath, arguments);
  }

  Future<List<DeviceInfo>> getDeviceList() async {
    ExecuteResult result = await _execute(['devices']);

    List<DeviceInfo> deviceList = [];

    if (result.success) {
      List<String> lines = result.output.split('\n');

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        List<String> parts = line.split('\t');
        if (parts.length != 2) continue;

        String serial = parts[0].trim();
        DeviceStatus status = await getFastbootMode(serial);

        deviceList.add(DeviceInfo(serial: serial, status: status));
      }
    }

    return deviceList;
  }

  Future<DeviceStatus> getFastbootMode(String serial) async {
    var result = await getvar(serial, 'is-userspace');

    if (result.isNotEmpty) {
      if (result.first.value == 'yes') {
        return DeviceStatus.fastbootd;
      } else {
        return DeviceStatus.bootloader;
      }
    } else {
      return DeviceStatus.unknown;
    }
  }

  // 电源操作
  Future<ExecuteResult> powerAction(String serial, PowerActions action) async {
    List<String> argument = [];
    switch (action) {
      case PowerActions.powerOff:
        argument.add('oem');
        argument.add('poweroff');
        break;
      case PowerActions.reboot:
        argument.add('reboot');
        break;
      case PowerActions.rebootToFastbootd:
        argument.add('reboot');
        argument.add('fastboot');
        break;
      case PowerActions.rebootToRecovery:
        argument.add('reboot');
        argument.add('recovery');
        break;
      case PowerActions.rebootToBootloader:
        argument.add('reboot');
        argument.add('bootloader');
        break;
    }

    return await _execute(['-s', serial, ...argument]);
  }

  // fastboot getvar name
  Future<List<FastbootInfo>> getvar(String serial, String name) async {
    ExecuteResult result = await _execute(['-s', serial, 'getvar', name]);

    if (!result.success) return [];

    if (name == 'all') {
      final pattern = RegExp(r'\(bootloader\)\s+((?:[^:]+:)*[^:]+):\s*(\S+)');

      return result.output
          .split('\n')
          .map((line) => pattern.firstMatch(line.trim()))
          .where((match) => match != null && match.groupCount == 2)
          .map(
            (match) =>
                FastbootInfo(name: match!.group(1)!, value: match.group(2)!),
          )
          .toList();
    } else {
      final lines = result.output.split('\n');
      final firstLine = lines.firstWhere(
        (line) => line.contains(':'),
        orElse: () => '',
      );
      final parts = firstLine.split(':');

      if (parts.length >= 2) {
        final value = parts.sublist(1).join(':').trim();
        return [FastbootInfo(name: name, value: value)];
      } else {
        return [FastbootInfo(name: name, value: '')];
      }
    }
  }
}
