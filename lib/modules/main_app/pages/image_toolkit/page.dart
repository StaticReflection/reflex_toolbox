import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/controller.dart';
import 'package:reflex_toolbox/modules/main_app/pages/image_toolkit/tabs/payload_dumper/tab.dart';

class _Tab extends StatelessWidget {
  final String title;
  const _Tab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(12), child: Text(title));
  }
}

class ImageToolkitPage extends GetView<ImageToolkitPageController> {
  const ImageToolkitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [_Tab(title: 'payloadDumper'.tr), _Tab(title: 'placeholder')],
          ),
          Expanded(
            child: TabBarView(children: [PayloadDumperTab(), Placeholder()]),
          ),
        ],
      ),
    );
  }
}
