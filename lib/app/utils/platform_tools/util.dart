import 'package:reflex_toolbox/app/utils/platform_tools/adb.dart';
import 'package:reflex_toolbox/app/utils/platform_tools/fastboot.dart';

class PlatformToolsUtil {
  static final Adb adb = Adb();
  static final Fastboot fastboot = Fastboot();
}
