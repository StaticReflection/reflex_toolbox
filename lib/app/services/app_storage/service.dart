import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/constants/app_key.dart';
import 'package:reflex_toolbox/app/services/log/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'AppStorageService';

  late final SharedPreferences _prefs;

  RxList<String> wirelessConnectionHistory = <String>[].obs;

  Future<AppStorageService> init() async {
    return this;
  }

  @override
  void onInit() async {
    _logService = Get.find<LogService>();

    _prefs = await SharedPreferences.getInstance();

    _initWirelessConnectionHistory();

    _logService.debug(_tag, 'Initialization completed');

    super.onInit();
  }

  void _initWirelessConnectionHistory() {
    _logService.debug(_tag, 'Initialize wireless connection history');

    wirelessConnectionHistory.value =
        _prefs.getStringList(AppKey.wirelessConnectionHistory) ?? [];
    ever(wirelessConnectionHistory, (newList) {
      _prefs.setStringList(AppKey.wirelessConnectionHistory, newList);
    });
  }
}
