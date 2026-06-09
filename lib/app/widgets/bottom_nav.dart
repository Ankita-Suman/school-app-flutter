// widgets/bottom_nav_widget.dart (Complete Clean Version)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/app/app.dart';
import '../pages/dashboard/dashboard_controller.dart';
import '../utils/asset_constants.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final controller = Get.find<DashboardController>();
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
                  // _buildNavItem(
                  //   icon: AssetConstants.icUnSelectedSchedule,
                  //   activeIcon: AssetConstants.icUnSelectedSchedule,
                  //   label: 'Schedule',
                  //   index: 2,
                  //   selectedIndex: selectedIndex,
                  //   controller: controller,
                  // ),
                  _buildNavItem(
                    icon: AssetConstants.icUnselectedFees,
                    activeIcon: AssetConstants.icUnselectedFees,
                    label: 'Fees',
                    index: 2,
                    selectedIndex: selectedIndex,
                    controller: controller,
                  ),
                  _buildNavItem(
                    icon: AssetConstants.icUnselectedProfile,
                    activeIcon: AssetConstants.icUnselectedProfile,
                    label: 'Profile',
                    index: 3,
                    selectedIndex: selectedIndex,
                    controller: controller,
                  ),
                  _buildNavItem(
                    icon: AssetConstants.icMenus,
                    activeIcon: AssetConstants.icMenus,
                    label: 'More',
                    index: 4,
                    selectedIndex: selectedIndex,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String activeIcon,
    required String label,
    required int index,
    required int selectedIndex,
    required DashboardController controller,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeNavIndex(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal:8),
          decoration: BoxDecoration(
            color: isSelected ? ColorsValue.navSelectColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isSelected ? activeIcon : icon,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? ColorsValue.navIconColor : Colors.grey.shade500,
                  BlendMode.srcIn, // This will replace SVG color
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? ColorsValue.navIconColor : Colors.grey.shade500,
                  fontSize:10,
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