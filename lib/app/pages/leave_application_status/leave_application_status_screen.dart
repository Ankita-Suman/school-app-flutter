import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/leave_application_status_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'leave_application_status_controller.dart';

class LeaveApplicationStatusScreen extends StatefulWidget {
  const LeaveApplicationStatusScreen({super.key});

  @override
  State<LeaveApplicationStatusScreen> createState() => _LeaveApplicationStatusScreenState();
}

class _LeaveApplicationStatusScreenState extends State<LeaveApplicationStatusScreen> {
  late final LeaveApplicationStatusController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LeaveApplicationStatusController(Get.find()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                          Text('Leave Status', style: Styles.whiteBold),
                        ],
                      ),
                      // Show total count
                      Obx(() {
                        if (controller.hasData) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${controller.totalCount} Applications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ========== TABS ==========
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(() => Row(
                    children: [
                      _buildTabButton('Today', 0),
                      _buildTabButton('This Week', 1),
                      _buildTabButton('This Month', 2),
                    ],
                  )),
                ),

                const SizedBox(height: 16),

                // ========== CONTENT ==========
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!controller.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getEmptyMessage(controller.selectedTab.value),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: controller.leaveApplications.map((application) {
                          return _buildLeaveCard(application);
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD TAB BUTTON ==========
  Widget _buildTabButton(String title, int index) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: GoogleFonts.sora().fontFamily,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? ColorsValue.navIconColor : ColorsValue.unSelectedClr,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                decoration: BoxDecoration(
                  color: isSelected ? ColorsValue.navIconColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== BUILD EMPTY STATE ==========
  Widget _buildEmptyState() {
    String message;
    switch (controller.selectedTab.value) {
      case 0:
        message = 'No leave applications for today';
        break;
      case 1:
        message = 'No leave applications for this week';
        break;
      case 2:
        message = 'No leave applications for this month';
        break;
      default:
        message = 'No leave applications found';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD LEAVE CARD ==========
  Widget _buildLeaveCard(LeaveApplication application) {
    final isLeave = application.isLeave;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== TOP SECTION: Name & Class ==========
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + Name & Class
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: application.avatarColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          application.initials,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: application.avatarColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.studentName,
                          style: Styles.darkBlcW60015,
                        ),
                        Text(
                          application.fullClass,
                          style: Styles.darkBlueW400,
                        ),
                      ],
                    ),
                  ],
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLeave
                        ? Colors.orange.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLeave
                          ? Colors.orange.shade200
                          : Colors.green.shade200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isLeave ? 'Leave' : 'Approved',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isLeave
                          ? Colors.orange.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ========== DIVIDER ==========
          Divider(
            color: Colors.grey.shade200,
            height: 1,
          ),

          // ========== BOTTOM SECTION: Date ==========
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      application.formattedDate,
                      style: Styles.darkBlueW400,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Remarks (if any)
                if (application.hasRemarks)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          application.remarks!,
                          style: Styles.darkBlcW400,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== HELPER METHODS ==========
  String _getEmptyMessage(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'No leave applications for today';
      case 1:
        return 'No leave applications for this week';
      case 2:
        return 'No leave applications for this month';
      default:
        return 'No leave applications found';
    }
  }
}