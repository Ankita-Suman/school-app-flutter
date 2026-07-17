// screens/join_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class ApprovalStatusScreen extends StatefulWidget {
  const ApprovalStatusScreen({super.key});

  @override
  State<ApprovalStatusScreen> createState() => _ApprovalStatusScreenState();
}

class _ApprovalStatusScreenState extends State<ApprovalStatusScreen> {
  // ========== LEAVE APPROVAL DATA ==========
  final List<Map<String, dynamic>> leaveList = [
    {
      'leaveType': 'Sick Leave',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'appliedDate': '15 Jun 2026',
      'dateRange': '20 Jun 2026 to 21 Jun 2026',
      'reason': 'Feeling unwell, advised rest.',
    },
    {
      'leaveType': 'Casual Leave',
      'status': 'Approved',
      'statusColor': Colors.green,
      'appliedDate': '01 May 2026',
      'dateRange': '10 May 2026',
      'reason': 'Personal work.',
    },
    {
      'leaveType': 'Earned Leave',
      'status': 'Rejected',
      'statusColor': Colors.red,
      'appliedDate': '05 Apr 2026',
      'dateRange': '15 Apr 2026 to 16 Apr 2026',
      'reason': 'Insufficient leave balance.',
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
                          Text('Approval Status', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: leaveList.map((item) {
                        return _buildLeaveCard(
                          leaveType: item['leaveType'] as String,
                          status: item['status'] as String,
                          statusColor: item['statusColor'] as Color,
                          appliedDate: item['appliedDate'] as String,
                          dateRange: item['dateRange'] as String,
                          reason: item['reason'] as String,
                        );
                      }).toList(),
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

  // ========== BUILD LEAVE CARD ==========
  Widget _buildLeaveCard({
    required String leaveType,
    required String status,
    required Color statusColor,
    required String appliedDate,
    required String dateRange,
    required String reason,
  }) {
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
          // ========== ROW: Leave Type & Status ==========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leaveType,
                style: Styles.darkBlcW60015
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: Styles.orange11600
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // ========== Applied Date ==========
          Text(
            'Applied: $appliedDate',
            style: Styles.darkBlueW400
          ),

          const SizedBox(height: 10),

          // ========== Date Range ==========
          Text(
            'Date: $dateRange',
            style: Styles.darkBlcW40012
          ),

          const SizedBox(height: 4),

          // ========== Reason ==========
          Text(
            'Reason: $reason',
              style: Styles.darkBlueW400
          ),
        ],
      ),
    );
  }
}