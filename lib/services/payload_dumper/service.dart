import 'package:get/get.dart';
import 'package:reflex_toolbox/data/providers/executable.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/data/value/model/partition.dart';
import 'package:reflex_toolbox/services/app_config/service.dart';
import 'package:reflex_toolbox/services/log/service.dart';
import 'package:reflex_toolbox/utils/compute_execute/util.dart';

class PayloadDumperService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'PayloadDumperService';

  final String _payloadDumperPath = ExecutableProvider.payloadDumperPath;

  Future<PayloadDumperService> init() async {
    return this;
  }

  @override
  void onInit() {
    _logService = Get.find<LogService>();

    _logService.debug(_tag, 'Initialization completed');
    super.onInit();
  }

  Future<ExecuteResult> _execute(List<String> arguments) async {
    return await executeWithCompute(_payloadDumperPath, arguments);
  }

  Future<List<Partition>> getPartitionList(String filePath) async {
    ExecuteResult result = await _execute(['-l', filePath]);
    if (result.success == true) {
      if (!result.output!.contains('Found partitions:\n')) return [];

      final partitionsRaw =
          result.output!.split('Found partitions:\n').last.trim();
      if (partitionsRaw.isEmpty) return [];

      final partitionList = partitionsRaw.split(', ');

      return partitionList.map((item) {
        final parts = item.replaceAll(')', '').split(' (');
        return Partition(name: parts[0], size: parts[1]);
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> dumpPartitions({
    required String filePath,
    required List<Partition> partitionList,
    required String outputPath,
  }) async {
    for (var partition in partitionList) {
      await _execute(['-p', partition.name, '-o', outputPath, filePath]);
    }
  }

  Future<void> dumpAllPartitions({
    required String filePath,
    required String outputPath,
  }) async {
    int workersCount =
        Get.find<AppConfigService>().payloadDumperWorkerCount.value;

    await _execute(['-o', outputPath, '-c', workersCount.toString(), filePath]);
  }
}
