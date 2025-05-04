import 'package:reflex_toolbox/app/data/providers/executable.dart';
import 'package:reflex_toolbox/app/data/value/enum/power_actions.dart';
import 'package:reflex_toolbox/app/utils/compute_execute/util.dart';
import 'package:reflex_toolbox/app/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/app/data/value/model/device_info.dart';
import 'package:reflex_toolbox/app/data/value/model/execute_result.dart';

class Fastboot {
  final String _fastbootPath = ExecutableProvider.fastbootPath;

  Future<ExecuteResult> _execute(List<String> arguments) async {
    ExecuteResult result = await executeWithCompute(_fastbootPath, arguments);

    return result;
  }

  Future<List<DeviceInfo>> getDeviceList() async {
    ExecuteResult result = await _execute(['devices']);

    List<DeviceInfo> deviceList = [];

    if (result.success) {
      List<String> lines = result.output!.split('\n');

      for (var i = 0; i < lines.length; i++) {
        List<String> splitLine = lines[i].trim().split('\t');
        if (splitLine.length == 2) {
          deviceList.add(
            DeviceInfo(
              serial: splitLine[0].trim(),
              status: deviceStatusFromString(splitLine[1].trim()),
            ),
          );
        }
      }
    }

    return deviceList;
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
  Future<ExecuteResult> getvar(String serial, String name) async {
    return await _execute(['-s', serial, 'getvar', name]);
  }
}
