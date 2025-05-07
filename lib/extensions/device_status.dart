import 'package:reflex_toolbox/data/value/enum/device_status.dart';

extension DeviceStatusExtension on DeviceStatus {
  bool get isAdbMode =>
      this == DeviceStatus.system ||
      this == DeviceStatus.recovery ||
      this == DeviceStatus.sideload;
  bool get isFastbootMode =>
      this == DeviceStatus.bootloader || this == DeviceStatus.fastbootd;

  static DeviceStatus fromString(String statusStr) {
    return switch (statusStr) {
      'offline' => DeviceStatus.offline,
      'unauthorized' => DeviceStatus.unauthorized,
      'device' => DeviceStatus.system,
      'recovery' => DeviceStatus.recovery,
      'sideload' => DeviceStatus.sideload,
      'fastbootd' => DeviceStatus.fastbootd,  // 万一谷歌某天改了呢？
      'fastboot' => DeviceStatus.bootloader,
      _ => DeviceStatus.unknown,
    };
  }
}
