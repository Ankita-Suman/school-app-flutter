import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/staff_leave_history/staff_leave_history_controller.dart';
import '../../app.dart';

class StaffLeaveHistoryScreen extends StatelessWidget {
  const StaffLeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffLeaveHistoryController>();
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
                            child: SvgPicture.asset(AssetConstants.icBackBg),
                          ),
                          const SizedBox(width: 8),
                          Text('Leave History', style: Styles.whiteBold),
                        ],
                      ),
                      // Total count
                      Obx(() => Container(
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
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ========== LIST ==========
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!controller.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No leave history found',
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
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.leaveHistoryItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.leaveHistoryItems[index];
                        return _buildLeaveCard(
                          studentName: item.staff.fullName,
                          className: item.leaveTypeDisplay,
                          reason: item.leaveReason,
                          fromDate: item.formattedFromDate,
                          toDate: item.formattedToDate,
                          duration: item.durationDisplay,
                          status: item.statusDisplay,
                        );
                      },
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
    required String studentName,
    required String className,
    required String reason,
    required String fromDate,
    required String toDate,
    required String duration,
    required String status,
  }) {
    // ========== Status Color Mapping ==========
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'approved':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'rejected':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    Color getStatusBgColor(String status) {
      switch (status.toLowerCase()) {
        case 'approved':
          return Colors.green.shade50;
        case 'pending':
          return Colors.orange.shade50;
        case 'rejected':
          return Colors.red.shade50;
        default:
          return Colors.grey.shade50;
      }
    }

    Color getStatusBorderColor(String status) {
      switch (status.toLowerCase()) {
        case 'approved':
          return Colors.green.shade200;
        case 'pending':
          return Colors.orange.shade200;
        case 'rejected':
          return Colors.red.shade200;
        default:
          return Colors.grey.shade200;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // ========== Name & Status ==========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  studentName,
                  style: Styles.darkBlcW60015,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusBgColor(status),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: getStatusBorderColor(status),
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            className,
            style: Styles.darkBlueW400,
          ),
          const SizedBox(height: 10),

          // ========== LIGHT BACKGROUND CONTAINER ==========
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Reason ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason: ',
                      style: Styles.darkGryW60012,
                    ),
                    Expanded(
                      child: Text(
                        reason,
                        style: Styles.darkBlcW40013,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // ---------- Dates & Duration ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dates: $fromDate - $toDate',
                      style: Styles.darkBlueW400,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
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
}