import 'package:get/get.dart';
import 'package:reflex_toolbox/app/modules/main_app/binding.dart';
import 'package:reflex_toolbox/app/modules/main_app/page.dart';
import 'package:reflex_toolbox/app/routes/routes.dart';

class AppPages {
  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => MainAppPage(),
      binding: MainAppPageBinding(),
    ),
  ];
}
