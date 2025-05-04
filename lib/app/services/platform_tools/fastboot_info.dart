import 'package:reflex_toolbox/app/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/app/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/app/services/platform_tools/service.dart';
import 'package:reflex_toolbox/app/utils/platform_tools/util.dart';

extension FastbootInfoExtension on PlatformToolsService {
  Future<List<FastbootInfo>> getvarAll() async {
    ExecuteResult result = await PlatformToolsUtil.fastboot.getvar(
      currentSelectedDevice.value!.serial,
      'all',
    );

    List<FastbootInfo> fastbootInfo = [];

    if (result.success) {
      for (var line in result.output!.split('\n')) {
        RegExp pattern = RegExp(
          r'\(bootloader\)\s+((?:[^:]+:)*[^:]+):\s*(\S+)',
        );

        RegExpMatch? match = pattern.firstMatch(line.trim());

        if (match != null && match.groupCount == 2) {
          String name = match.group(1)!;
          String value = match.group(2)!;

          fastbootInfo.add(FastbootInfo(name: name, value: value));
        }
      }
    }

    return fastbootInfo;
  }
}
