// widgets/teacher_bottom_nav_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/app/app.dart';
import '../pages/teacher_dashboard/teacher_dashboard_controller.dart';
import '../utils/asset_constants.dart';

class TeacherBottomNavBarWidget extends StatelessWidget {
  const TeacherBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print("🔽🔽🔽 TEACHER BOTTOM NAV BAR BUILD 🔽🔽🔽");

    if (!Get.isRegistered<TeacherDashboardController>()) {
      print("⚠️ TeacherDashboardController not registered yet");
      return const SizedBox.shrink();
    }

    final TeacherDashboardController controller = Get.find<TeacherDashboardController>();

    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;

      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: AssetConstants.icUnselectedHome,
                  activeIcon: AssetConstants.icUnselectedHome,
                  label: 'Home',
                  index: 0,
                  selectedIndex: selectedIndex,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: AssetConstants.icUnSelectedSchedule,
                  activeIcon: AssetConstants.icUnSelectedSchedule,
                  label: 'Work',
                  index: 1,
                  selectedIndex: selectedIndex,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: AssetConstants.icUnselectedFees,
                  activeIcon: AssetConstants.icUnselectedFees,
                  label: 'Schedule',
                  index: 2,
                  selectedIndex: selectedIndex,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: AssetConstants.icInbox, // ✅ Changed to Inbox icon
                  activeIcon: AssetConstants.icInbox, // ✅ Changed to Inbox icon
                  label: 'Messages',
                  index: 3,
                  selectedIndex: selectedIndex,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: AssetConstants.icUnselectedProfile, // ✅ Changed to Profile icon
                  activeIcon: AssetConstants.icUnselectedProfile, // ✅ Changed to Profile icon
                  label: 'Profile',
                  index: 4,
                  selectedIndex: selectedIndex,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required String icon,
    required String activeIcon,
    required String label,
    required int index,
    required int selectedIndex,
    required TeacherDashboardController controller,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTab(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? ColorsValue.navSelectColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isSelected ? activeIcon : icon,
                height: 22,
                width: 22,
                colorFilter: ColorFilter.mode(
                  isSelected ? ColorsValue.navIconColor : Colors.grey.shade500,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? ColorsValue.navIconColor : Colors.grey.shade500,
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}