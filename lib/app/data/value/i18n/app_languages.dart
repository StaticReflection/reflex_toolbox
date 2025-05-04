import 'package:get/get.dart';
// 语言
import 'package:reflex_toolbox/app/data/value/i18n/en_us.dart';
import 'package:reflex_toolbox/app/data/value/i18n/zh_cn.dart';

class AppLanguages extends Translations {
  static List<String> get supportedLanguages => ['en_US', 'zh_CN'];

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US.keys(),
    'zh_CN': zh_CN.keys(),
  };
}
