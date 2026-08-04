// screens/join_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import 'leave_balance_controller.dart';

class LeaveBalanceScreen extends StatefulWidget {
  const LeaveBalanceScreen({super.key});

  @override
  State<LeaveBalanceScreen> createState() => _LeaveBalanceScreenState();
}

class _LeaveBalanceScreenState extends State<LeaveBalanceScreen> {
  late final LeaveBalanceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LeaveBalanceController>();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                            child: SvgPicture.asset(AssetConstants.icBackBg),
                          ),
                          const SizedBox(width: 8),
                          Text('Leave Balance', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!controller.hasData) {
                      return const Center(
                        child: Text(
                          'No leave data available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final breakdown = controller.breakdown;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // ========== TOTAL REMAINING LEAVES CARD ==========
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text('Total Remaining Leaves',
                                    style: Styles.darkGryW60014),
                                const SizedBox(height: 8),
                                Text(
                                  '${controller.totalRemaining}',
                                  style: Styles.skyBlueW70032,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Out of ${controller.totalQuota} for this academic year',
                                  style: Styles.darkBlcW40013,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ========== LEAVE BREAKDOWN ==========
                          // Show all leave types dynamically (max 2 per row)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: breakdown.map((item) {
                              return SizedBox(
                                width: screenWidth / 2 - 24,
                                child: _buildLeaveCard(
                                  title: item.leaveTypeDisplay,
                                  quota: item.quota,
                                  used: item.used,
                                  color: _getColorForLeaveType(item.leaveType),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),
                        ],
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

  // ========== BUILD LEAVE CARD ==========
  Widget _buildLeaveCard({
    required String title,
    required int quota,
    required int used,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: Styles.darkGryW60012),
                const SizedBox(height: 4),
                Text('$quota', style: Styles.darkBlcW70024),
                const SizedBox(height: 4),
                Text('Used: $used', style: Styles.darkBlcW40010),
              ],
            ),
          ),
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== COLOR MAPPING ==========
  Color _getColorForLeaveType(String type) {
    switch (type.toUpperCase()) {
      case 'CASUAL':
        return Colors.blue.shade700;
      case 'SICK':
        return Colors.green.shade700;
      case 'EARNED':
        return Colors.orange.shade700;
      default:
        return Colors.purple.shade700;
    }
  }
}