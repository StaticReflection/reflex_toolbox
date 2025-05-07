import 'package:reflex_toolbox/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/services/platform_tools/service.dart';
import 'package:reflex_toolbox/utils/platform_tools/util.dart';

extension FastbootInfoExtension on PlatformToolsService {
  Future<List<FastbootInfo>> getvarAll(String serial) async {
    return await PlatformToolsUtil.fastboot.getvar(serial, 'all');
  }

  
}
