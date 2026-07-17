// teacher_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/teacher_bottom_nav.dart';
import 'teacher_dashboard_controller.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    print("🏠🏠🏠 Teacher DASHBOARD SCREEN BUILD START 🏠🏠🏠");
    print("🏠🏠🏠Teacher DASHBOARD SCREEN BUILD END 🏠🏠🏠");
    return GetBuilder<TeacherDashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: controller.screens[controller.selectedIndex.value], // Direct access
        bottomNavigationBar: const TeacherBottomNavBarWidget(),
      ),
    );
  }
}