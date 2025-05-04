import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/i18n/app_languages.dart';
import 'package:reflex_toolbox/app/services/app_config/service.dart';

class SettingsPageController extends GetxController {
  late final AppConfigService _appConfigService;

  RxBool get isDarkMode => _appConfigService.isDarkMode;
  RxString get currentLanguage => _appConfigService.currentLanguage;
  RxList<String> get supportedLanguages => AppLanguages.supportedLanguages.obs;

  @override
  void onInit() {
    _appConfigService = Get.find<AppConfigService>();
    super.onInit();
  }

  void toggleDarkMode(bool value) {
    _appConfigService.isDarkMode.value = value;
  }

  void changeLanguage(String? language) {
    if (language == null) return;
    _appConfigService.currentLanguage.value = language;
  }
}
