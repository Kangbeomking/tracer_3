import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/navigation_controller.dart';
import 'package:tracer_3/views/model_pages/home_page.dart';
import 'package:tracer_3/views/model_pages/project_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final NavigationController navigationController =
      Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navigationController.tabIndex.value,
            children: [
              HomePage(),
              ProjectPage(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navigationController.tabIndex.value,
            onTap: navigationController.changeTabIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Project'),
            ],
          )),
    );
  }
}
