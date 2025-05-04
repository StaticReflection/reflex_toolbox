import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnselectedDeviceHint extends StatelessWidget {
  const UnselectedDeviceHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'plaseSelectTheDevice'.tr,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
