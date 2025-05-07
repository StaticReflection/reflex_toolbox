import 'package:get/get.dart';
import 'package:reflex_toolbox/data/providers/executable.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/services/log/service.dart';
import 'package:reflex_toolbox/utils/compute_execute/util.dart';

class ScrcpyService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'ScrcpyService';

  final String _scrcpyPath = ExecutableProvider.scrcpyPath;

  Future<ScrcpyService> init() async {
    return this;
  }

  @override
  void onInit() {
    _logService = Get.find<LogService>();

    _logService.debug(_tag, 'Initialization completed');

    super.onInit();
  }

  Future<ExecuteResult> _execute(List<String> arguments) async {
    return await executeWithCompute(_scrcpyPath, arguments);
  }

  Future screenCast(String serial) async {
    await _execute(['-s', serial]);
  }
}
