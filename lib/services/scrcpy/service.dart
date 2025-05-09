import 'package:get/get.dart';
import 'package:reflex_toolbox/data/providers/executable.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';
import 'package:reflex_toolbox/services/isolate_execute/service.dart';
import 'package:reflex_toolbox/services/log/service.dart';

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
    String tag = _tag + arguments.toString();
    
    if (Get.isRegistered(tag: tag)) {
      await Get.delete(tag: tag);
    }

    ExecuteService service = await Get.putAsync<ExecuteService>(
      () => ExecuteService().init(),
      tag: tag,
    );

    return service.startExecution(_scrcpyPath, arguments);
  }

  Future screenCast(String serial) async {
    await _execute(['-s', serial]);
  }
}
