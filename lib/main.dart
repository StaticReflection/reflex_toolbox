import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/app/data/value/i18n/app_languages.dart';
import 'package:reflex_toolbox/app/routes/pages.dart';
import 'package:reflex_toolbox/app/routes/routes.dart';
import 'package:reflex_toolbox/app/services/app_config/service.dart';
import 'package:reflex_toolbox/app/data/value/config/default.dart';
import 'package:reflex_toolbox/app/data/value/constants/app_constants.dart';
import 'package:reflex_toolbox/app/services/app_storage/service.dart';
import 'package:reflex_toolbox/app/services/app_window/service.dart';
import 'package:reflex_toolbox/app/services/log/service.dart';
import 'package:reflex_toolbox/app/services/platform_tools/service.dart';
import 'package:reflex_toolbox/app/services/scrcpy/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => LogService().init());
  await Get.putAsync(() => AppConfigService().init());
  await Get.putAsync(() => PlatformToolsService().init());
  await Get.putAsync(() => ScrcpyService().init());
  await Get.putAsync(() => AppWindowService().init());
  await Get.putAsync(() => AppStorageService().init());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _listener = AppLifecycleListener(
      onExitRequested: () async {
        await Get.deleteAll();

        return AppExitResponse.exit;
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final lightScheme =
            lightDynamic?.harmonized() ??
            ColorScheme.fromSeed(seedColor: Colors.white);
        final darkScheme =
            darkDynamic?.harmonized() ??
            ColorScheme.fromSeed(
              seedColor: Colors.black,
              brightness: Brightness.dark,
            );
        return GetMaterialApp(
          // 标题
          title: AppConstants.appName,
          // 关闭调试模式下的debug标签
          debugShowCheckedModeBanner: false,
          // 国际化
          translations: AppLanguages(),
          fallbackLocale: AppDefaultConfig.fallbackLocale,
          // 主题
          theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
          themeMode: ThemeMode.system,
          // 路由
          getPages: AppPages.pages,
          initialRoute: AppRoutes.home,
        );
      },
    );
  }
}
