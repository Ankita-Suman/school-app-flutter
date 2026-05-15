// widgets/tab_bar_widget.dart (Larger Box Version)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../pages/login/login_controller.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return Obx(
            () => Row(
          children: [
            _buildTabItem(
              controller: controller,
              icon: Icons.school,
              label: 'Student',
              index: 0,
            ),
            _buildTabItem(
              controller: controller,
              icon: Icons.family_restroom,
              label: 'Parent',
              index: 1,
            ),
            _buildTabItem(
              controller: controller,
              icon: Icons.person,
              label: 'Teacher',
              index: 2,
            ),
          ],
        ),
    );
  }

  Widget _buildTabItem({
    required LoginController controller,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorsValue.navSelectColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? ColorsValue.darkFillBlueColor : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.blue.shade700 : Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}