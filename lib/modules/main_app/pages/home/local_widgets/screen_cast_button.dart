import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/home/controller.dart';

class ScreenCastButton extends GetView<HomePageController> {
  const ScreenCastButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: controller.screenCast,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        minimumSize: Size(double.infinity, kMinInteractiveDimension),
      ),
      child: Text('screenCast'.tr),
    );
  }
}
