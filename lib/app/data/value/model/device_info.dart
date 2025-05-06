import 'package:reflex_toolbox/app/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/app/data/value/model/fastboot_info.dart';
import 'package:reflex_toolbox/app/data/value/model/memory_info.dart';
import 'package:reflex_toolbox/app/data/value/model/property.dart';
import 'package:reflex_toolbox/app/data/value/model/storage_info.dart';

class DeviceInfo {
  final String serial;
  final DeviceStatus status;

  final List<Property> properties = <Property>[
    Property(key: 'ro.product.marketname'), // 市场名称: Redmi K50
    Property(key: 'ro.product.name'), // codename: rubens
    Property(key: 'ro.product.model'), // 型号: 2204211AC
    Property(key: 'ro.build.version.release'), // 安卓版本: 14
    Property(
      key: 'ro.system.build.version.incremental',
    ), // 构建版本: OS2.0.3.0.ULNCNXM
    Property(key: 'ro.product.cpu.abi'), // CPU的ABI: arm64-v8a
    Property(key: 'ro.boot.slot_suffix'), // A/B槽位: _a
    Property(key: 'ro.vndk.version'), // VNDK版本: 31
    Property(key: 'ro.product.brand'), // 厂商: Redmi
    Property(key: 'ro.board.platform'), // CPU: mt6895
  ];

  String? selinuxMode; // getenforce
  int? batteryLevel; // 电量
  StorageInfo? storageInfo;
  MemoryInfo? memoryInfo;
  String? kernelVersion; // uname -r

  List<FastbootInfo>? fastbootInfo;

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
