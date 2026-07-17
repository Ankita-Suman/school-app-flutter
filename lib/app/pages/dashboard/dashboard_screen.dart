// teacher_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_nav.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    print("🏠🏠🏠 DASHBOARD SCREEN BUILD START 🏠🏠🏠");

    final DashboardController controller = Get.put(DashboardController(Get.find()), permanent: true);

    print("🏠🏠🏠 DASHBOARD SCREEN BUILD END 🏠🏠🏠");
    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: controller.screens[controller.selectedIndex.value], // Direct access
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}