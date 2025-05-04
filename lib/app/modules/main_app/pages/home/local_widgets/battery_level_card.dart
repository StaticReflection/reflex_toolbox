import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatteryLevelCard extends StatelessWidget {
  final int? power;
  const BatteryLevelCard(this.power, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CircularProgressIndicator(
                value: power == null ? null : power! / 100,
                strokeWidth: 8,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'batteryLevel'.tr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      power == null ? 'unknown'.tr : '$power%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
