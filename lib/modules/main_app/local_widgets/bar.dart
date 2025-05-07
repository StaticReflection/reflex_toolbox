import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/controller.dart';
import 'package:reflex_toolbox/data/value/constants/app_constants.dart';

class MainAppPageBar extends GetView<MainAppPageController> {
  const MainAppPageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MoveWindow(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.minimize,
                icon: Icon(Icons.remove),
              ),
              IconButton(
                onPressed: controller.maximizeOrRestore,
                icon: Icon(Icons.crop_square),
              ),
              IconButton(onPressed: controller.close, icon: Icon(Icons.close)),
            ],
          ),
        ),
      ],
    );
  }
}
