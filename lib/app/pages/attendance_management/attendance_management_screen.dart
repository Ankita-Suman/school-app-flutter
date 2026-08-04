import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class AttendanceManagementScreen extends StatelessWidget {
  AttendanceManagementScreen({super.key});

  // ========== MARKING & EDITING DATA ==========
  final List<Map<String, dynamic>> markingEditing = [
    {
      'title': 'Class Attendance',
      'subtitle': 'Daily student attendance',
      'icon': Icons.people_outline,
      'color': Colors.blue,
      'route': '/Mark-Attendance-Screen', // ✅ Added route
      'position': 0,
    },

    {
      'title': 'Edit Attendance',
      'subtitle': 'Modify previous records',
      'icon': Icons.edit_outlined,
      'color': Colors.green,
      'route': '/Edit-Attendance-Screen',
      'position': 2,
    },
  ];

  // ========== REPORTS & TRACKING DATA ==========
  final List<Map<String, dynamic>> reportsTracking = [
    {
      'title': 'Attendance History',
      'subtitle': 'View monthly & term reports',
      'icon': Icons.history_outlined,
      'color': Colors.purple,
      'route': '/attendance-history',
      'position': 3,
    },
    {
      'title': 'Late Arrival Tracking',
      'subtitle': 'Monitor habitual latecomers',
      'icon': Icons.access_time_outlined,
      'color': Colors.red,
      'route': '/Late-Arrivals-Screen',
      'position': 4,
    },
    {
      'title': 'Leave Status',
      'subtitle': 'Approved & pending student leaves',
      'icon': Icons.beach_access_outlined,
      'color': Colors.teal,
      'route': '/Leave-Applications-Screen',
      'position': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ========== HEADER BACKGROUND ==========
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: double.infinity,
              height: backgroundHeight,
              fit: BoxFit.cover,
            ),
          ),

          // ========== MAIN CONTENT ==========
          SafeArea(
            child: Column(
              children: [
                // ========== HEADER ==========
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: SvgPicture.asset(
                              AssetConstants.icBackBg,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Attendance Management',
                              style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== CONTAINER 1: MARKING & EDITING ==========
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Marking & Editing',
                                style: Styles.darkBlcW700016,
                              ),
                            ),
                            // Items
                            ...markingEditing.map((item) {
                              final isLast = markingEditing.indexOf(item) ==
                                  markingEditing.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                  bottom: isLast ? 16 : 8,
                                ),
                                child: _buildClassCard(
                                  title: item['title'] as String,
                                  subtitle: item['subtitle'] as String,
                                  icon: item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  route: item['route'] as String,
                                  position: item['position'] as int,
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // ========== CONTAINER 2: REPORTS & TRACKING ==========
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Reports & Tracking',
                                style: Styles.darkBlcW700016,
                              ),
                            ),
                            // Items
                            ...reportsTracking.map((item) {
                              final isLast = reportsTracking.indexOf(item) ==
                                  reportsTracking.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                  bottom: isLast ? 16 : 8,
                                ),
                                child: _buildClassCard(
                                  title: item['title'] as String,
                                  subtitle: item['subtitle'] as String,
                                  icon: item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  route: item['route'] as String,
                                  position: item['position'] as int,
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD CLASS CARD ==========
  Widget _buildClassCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
    required int position,
  }) {
    return GestureDetector(
      onTap: () => _handleNavigation(route, title, position),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // ========== COLORED CONTAINER WITH ICON ==========
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ========== TITLE & SUBTITLE ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.darkBlcW60015,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: Styles.darkBlueW400,
                    ),
                ],
              ),
            ),

            // ========== ARROW ICON ==========
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ========== NAVIGATION HANDLER ==========
  void _handleNavigation(String route, String title, int position) {
    switch (position) {
      case 0:
        // Class Attendance
        Get.toNamed(
          Routes.markAttendance,
          arguments: {'title': title},
        );
        // OR
        // RouteManagement.goToClassAttendance();
        break;

      case 1:
        // Exam Term Attendance
        Get.toNamed(
          Routes.termAttendance,
          arguments: {'title': title},
        );
        // RouteManagement.goToExamTermAttendance();
        break;

      case 2:
        // Edit Attendance
        Get.toNamed(
          Routes.editAttendance,
          arguments: {'title': title},
        );
        // RouteManagement.goToEditAttendance();
        break;

      case 3:
        // Attendance History
        Get.toNamed(
          Routes.attendanceReport,
          arguments: {'title': title},
        );
        // RouteManagement.goToAttendanceHistory();
        break;

      case 4:
        // Late Arrival Tracking
        Get.toNamed(
          Routes.lateArrival,
          arguments: {'title': title},
        );
        // RouteManagement.goToLateArrivalTracking();
        break;

      case 5:
        // Leave Status
        Get.toNamed(
          Routes.leaveApplications,
          arguments: {'title': title},
        );
        // RouteManagement.goToLeaveStatus();
        break;

      default:
        Get.snackbar(
          'Coming Soon',
          '$title feature is under development',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        break;
    }
  }
}
