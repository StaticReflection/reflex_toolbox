import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/config/default.dart';
import 'package:reflex_toolbox/app/data/value/constants/app_key.dart';
import 'package:reflex_toolbox/app/services/log/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigService extends GetxService {
  late final LogService _logService;
  static const String _tag = 'AppConfigService';

  late final SharedPreferences _prefs;

  RxBool isDarkMode = AppDefaultConfig.isDarkMode.obs;
  late RxString currentLanguage =
      AppDefaultConfig.fallbackLocale.toString().obs;
  RxInt payloadDumperWorkerCount = 4.obs;

  Future<AppConfigService> init() async {
    return this;
  }

  void _initValue<T>(String key, T defaultValue, Rx rx) {
    if (_prefs.containsKey(key)) {
      switch (T) {
        case const (bool):
          rx.value = (_prefs.getBool(key) as T?) ?? defaultValue;
        case const (int):
          rx.value = (_prefs.getInt(key) as T?) ?? defaultValue;
        case const (double):
          rx.value = (_prefs.getDouble(key) as T?) ?? defaultValue;
        case const (String):
          rx.value = (_prefs.getString(key) as T?) ?? defaultValue;
      }
    } else {
      rx.value = defaultValue;
      switch (T) {
        case const (bool):
          _prefs.setBool(key, defaultValue as bool);
          break;
        case const (int):
          _prefs.setInt(key, defaultValue as int);
          break;
        case const (double):
          _prefs.setDouble(key, defaultValue as double);
          break;
        case const (String):
          _prefs.setString(key, defaultValue as String);
          break;
      }
    }
  }

  @override
  void onInit() async {
    _logService = Get.find<LogService>();

    _prefs = await SharedPreferences.getInstance();

    ever(isDarkMode, _updateDarkMode);
    ever(currentLanguage, _updateLanguage);

    _initValue<bool>(
      AppKey.isDarkMode,
      AppDefaultConfig.isDarkMode,
      isDarkMode,
    );
    _initValue<String>(
      AppKey.language,
      Get.deviceLocale?.toString() ??
          AppDefaultConfig.fallbackLocale.toString(),
      currentLanguage,
    );

    _logService.debug(_tag, 'Initialization completed');

    super.onInit();
  }

  // 应用暗色模式
  void _updateDarkMode(bool isDark) {
    _logService.debug(_tag, 'Update DarkMode to $isDark');

    _prefs.setBool(AppKey.isDarkMode, isDark);

    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // 应用语言
  void _updateLanguage(String languageCode) {
    _logService.debug(_tag, 'Update language to $languageCode');

    _prefs.setString(AppKey.language, languageCode);

    final parts = languageCode.split('_');
    Get.updateLocale(
      parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]),
    );
  }
}
