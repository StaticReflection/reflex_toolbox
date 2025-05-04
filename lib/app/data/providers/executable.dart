import 'package:reflex_toolbox/app/data/value/constants/app_constants.dart';

class ExecutableProvider {
  static String get adbPath {
    return '${AppConstants.binaryDirectory}/${AppConstants.platformToolsDirectory}/adb';
  }

  static String get fastbootPath {
    return '${AppConstants.binaryDirectory}/${AppConstants.platformToolsDirectory}/fastboot';
  }

  static String get scrcpyPath {
    return '${AppConstants.binaryDirectory}/${AppConstants.scrcpyDirectory}/scrcpy';
  }
}
