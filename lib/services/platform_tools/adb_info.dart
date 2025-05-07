import 'package:reflex_toolbox/data/value/enum/device_status.dart';
import 'package:reflex_toolbox/data/value/model/device_info.dart';
import 'package:reflex_toolbox/data/value/model/memory_info.dart';
import 'package:reflex_toolbox/data/value/model/storage_info.dart';
import 'package:reflex_toolbox/services/platform_tools/service.dart';
import 'package:reflex_toolbox/utils/platform_tools/util.dart';

extension AdbInfoExtension on PlatformToolsService {
  Future<String?> getprop(String serial, String prop) async {
    final result = await PlatformToolsUtil.adb.shell(serial, 'getprop $prop');

    return result.success && result.output.isNotEmpty ? result.output : null;
  }

  Future<void> getDeviceInfoProperties(DeviceInfo device) async {
    await Future.wait(
      device.properties.map((property) async {
        property.value = await getprop(device.serial, property.key);
      }),
    );
  }

  Future<String?> getKernelVersion(String serial) async {
    final result = await PlatformToolsUtil.adb.shell(serial, 'uname -r');

    return result.success ? result.output : null;
  }

  Future<int?> getBatteryLevel(String serial, DeviceStatus status) async {
    if (status == DeviceStatus.system) {
      final result = await PlatformToolsUtil.adb.shell(
        serial,
        'dumpsys battery',
      );

      if (!result.success) return null;

      final levelMatch = RegExp(
        r'^\s*level\s*:\s*(\d+)',
        multiLine: true,
      ).firstMatch(result.output);
      return levelMatch != null ? int.tryParse(levelMatch.group(1)!) : null;
    } else if (status == DeviceStatus.recovery) {
      final result = await PlatformToolsUtil.adb.shell(
        serial,
        'cat /sys/class/power_supply/battery/capacity',
      );

      return int.tryParse(result.output);
    }

    return null;
  }

  Future<String?> getenforce(String serial) async {
    final result = await PlatformToolsUtil.adb.shell(serial, 'getenforce');

    return result.success ? result.output : null;
  }

  Future<StorageInfo?> getStorageInfo(String serial) async {
    try {
      final result = await PlatformToolsUtil.adb.shell(serial, 'df /data');

      if (result.success) {
        final lines = result.output.trim().split('\n');
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
      } else {
        return null;
      }
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
      if (!result.success) {
        return null;
      }

      final lines = result.output.trim().split('\n');
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
