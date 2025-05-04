import 'package:reflex_toolbox/app/data/value/model/device_info.dart';
import 'package:reflex_toolbox/app/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/app/data/value/model/memory_info.dart';
import 'package:reflex_toolbox/app/data/value/model/storage_info.dart';
import 'package:reflex_toolbox/app/services/platform_tools/service.dart';
import 'package:reflex_toolbox/app/utils/platform_tools/util.dart';

extension AdbInfoExtension on PlatformToolsService {
  Future<String?> getprop(String serial, String prop) async {
    ExecuteResult result = await PlatformToolsUtil.adb.shell(
      serial,
      'getprop $prop',
    );

    if (result.output == null) {
      return null;
    } else {
      if (result.output!.isEmpty) {
        return null;
      } else {
        return result.output;
      }
    }
  }

  Future<void> getDeviceInfoProperties(DeviceInfo device) async {
    final props = <String, void Function(String?)>{
      'ro.product.cpu.abi': (v) => device.abi = v,
      'ro.build.version.release': (v) => device.androidVersion = v,
      'ro.system.build.version.incremental': (v) => device.buildVersion = v,
      'ro.product.name': (v) => device.codeName = v,
      'ro.product.model': (v) => device.model = v,
      'ro.boot.slot_suffix': (v) => device.slot = v,
      'ro.vndk.version': (v) => device.vndk = v,
      'ro.product.marketname': (v) => device.marketName = v,
      'ro.product.brand': (v) => device.band = v,
      'ro.board.platform': (v) => device.cpu = v,
    };

    await Future.wait(
      props.entries.map((e) async {
        final value = await getprop(device.serial, e.key);
        e.value(value);
      }),
    );
  }

  Future<void> getKernelVersion(DeviceInfo device) async {
    final kernel = await PlatformToolsUtil.adb.shell(device.serial, 'uname -r');
    device.kernelVersion = kernel.output;
  }

  Future<void> getBatteryLevel(DeviceInfo device) async {
    final result = await PlatformToolsUtil.adb.shell(
      device.serial,
      'dumpsys battery | grep level',
    );
    if (result.success) {
      final parts = result.output!.trim().split(': ');
      device.batteryLevel = (parts.length == 2) ? int.tryParse(parts[1]) : null;
    } else {
      device.batteryLevel = null;
    }
  }

  Future<void> getenforce(DeviceInfo device) async {
    final result = await PlatformToolsUtil.adb.shell(
      device.serial,
      'getenforce',
    );

    device.selinuxMode = result.output;
  }

  Future<StorageInfo?> getStorageInfo(String serial) async {
    try {
      final result = await PlatformToolsUtil.adb.shell(serial, 'df /data');

      if (!result.success || result.output == null) {
        return null;
      }

      final lines = result.output!.trim().split('\n');
      if (lines.length < 2) return null;

      final parts = lines[1].trim().split(RegExp(r'\s+'));
      if (parts.length < 4) return null;

      final totalKB = double.tryParse(parts[1]);
      final usedKB = double.tryParse(parts[2]);

      if (totalKB == null || usedKB == null) return null;

      final totalGB = totalKB / (1024 * 1024);
      final usedGB = usedKB / (1024 * 1024);

      return StorageInfo(
        total: double.parse(totalGB.toStringAsFixed(2)),
        used: double.parse(usedGB.toStringAsFixed(2)),
      );
    } catch (e) {
      return null;
    }
  }

  Future<MemoryInfo?> getMemoryInfo(String serial) async {
    try {
      final result = await PlatformToolsUtil.adb.shell(
        serial,
        'cat /proc/meminfo',
      );
      if (!result.success || result.output == null) {
        return null;
      }

      final lines = result.output!.trim().split('\n');
      final memInfo = <String, double>{};

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        final colonIndex = line.indexOf(':');
        if (colonIndex == -1) continue;
        final key = line.substring(0, colonIndex).trim();
        final valuePart =
            line.substring(colonIndex + 1).trim().split(RegExp(r'\s+'))[0];
        final value = double.tryParse(valuePart);
        if (value != null) {
          memInfo[key] = value;
        }
      }

      final totalKb = memInfo['MemTotal'];
      final freeKb = memInfo['MemFree'];
      final buffersKb = memInfo['Buffers'];
      final sharedKb = memInfo['Shmem'];
      final cachedKb = memInfo['Cached'];
      final availableKb = memInfo['MemAvailable'] ?? memInfo['MemFree'];

      if (totalKb == null ||
          freeKb == null ||
          buffersKb == null ||
          sharedKb == null ||
          cachedKb == null ||
          availableKb == null) {
        return null;
      }

      final usedKb = totalKb - freeKb - buffersKb - cachedKb;

      const bytesPerGB = 1000 * 1000 * 1000;
      final totalGB = (totalKb * 1024) / bytesPerGB;
      final usedGB = (usedKb * 1024) / bytesPerGB;
      final sharedGB = (sharedKb * 1024) / bytesPerGB;
      final buffersGB = (buffersKb * 1024) / bytesPerGB;
      final availableGB = (availableKb * 1024) / bytesPerGB;

      return MemoryInfo(
        total: double.parse(totalGB.toStringAsFixed(2)),
        used: double.parse(usedGB.toStringAsFixed(2)),
        shared: double.parse(sharedGB.toStringAsFixed(2)),
        buffers: double.parse(buffersGB.toStringAsFixed(5)),
        available: double.parse(availableGB.toStringAsFixed(2)),
      );
    } catch (e) {
      return null;
    }
  }
}
