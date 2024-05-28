import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_nav.dart';
import 'home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context)  => Scaffold(
    backgroundColor: Colors.white,
    body: GetBuilder<HomeController>(
      builder: (controller) =>
          controller.getItemWidget(controller.selectedIndex),
    ),
    bottomNavigationBar: const BottomNavBarWidget(),
  );
}
