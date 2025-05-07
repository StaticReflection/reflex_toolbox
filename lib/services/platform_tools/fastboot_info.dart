import 'package:reflex_toolbox/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/services/platform_tools/service.dart';
import 'package:reflex_toolbox/utils/platform_tools/util.dart';

extension FastbootInfoExtension on PlatformToolsService {
  Future<List<FastbootInfo>> getvarAll() async {
    final result = await PlatformToolsUtil.fastboot.getvar(
      currentSelectedDevice.value!.serial,
      'all',
    );

    if (!result.success || result.output == null) return [];

    final pattern = RegExp(r'\(bootloader\)\s+((?:[^:]+:)*[^:]+):\s*(\S+)');

    return result.output!
        .split('\n')
        .map((line) => pattern.firstMatch(line.trim()))
        .where((match) => match != null && match.groupCount == 2)
        .map(
          (match) =>
              FastbootInfo(name: match!.group(1)!, value: match.group(2)!),
        )
        .toList();
  }
}
