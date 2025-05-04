import 'package:reflex_toolbox/app/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/app/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/app/data/value/model/memory_info.dart';
import 'package:reflex_toolbox/app/data/value/model/storage_info.dart';

class DeviceInfo {
  final String serial;
  final DeviceStatus status;

  String? marketName; // ro.product.marketname
  String? codeName; // ro.product.name
  String? model; // ro.product.model
  String? androidVersion; // ro.build.version.release
  String? kernelVersion; // uname -r
  String? buildVersion; // ro.system.build.version.incremental
  String? abi; // ro.product.cpu.abi
  String? slot; // ro.boot.slot_suffix
  String? vndk; // ro.vndk.version
  String? band; // ro.product.brand
  String? cpu; // ro.board.platform
  String? selinuxMode; // getenforce
  int? batteryLevel; // 电量
  List<FastbootInfo>? fastbootInfo;
  StorageInfo? storageInfo;
  MemoryInfo? memoryInfo;

  DeviceInfo({required this.serial, required this.status});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo && other.serial == serial;
  }

  @override
  int get hashCode => serial.hashCode;

  @override
  String toString() {
    return 'DeviceInfo(serial: $serial, status: $status)';
  }
}
