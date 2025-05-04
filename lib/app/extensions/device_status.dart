import 'package:reflex_toolbox/app/data/value/enum/device_status.dart';

extension DeviceStatusX on DeviceStatus {
  bool get isAdbMode =>
      this == DeviceStatus.device || this == DeviceStatus.recovery;
  bool get isFastbootMode => this == DeviceStatus.fastboot;
}
