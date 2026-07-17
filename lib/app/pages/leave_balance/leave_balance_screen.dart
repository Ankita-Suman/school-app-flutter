// screens/join_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class LeaveBalanceScreen extends StatefulWidget {
  const LeaveBalanceScreen({super.key});

  @override
  State<LeaveBalanceScreen> createState() => _LeaveBalanceScreenState();
}

class _LeaveBalanceScreenState extends State<LeaveBalanceScreen> {
  // ========== LEAVE BALANCE DATA ==========
  final Map<String, dynamic> leaveData = {
    'totalRemaining': 14,
    'totalAllowed': 20,
    'casualLeave': 5,
    'casualUsed': 3,
    'sickLeave': 4,
    'sickUsed': 2,
    'earnedLeave': 5,
    'earnedUsed': 1,
  };

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
                          Text('Leave Balance', style: Styles.whiteBold),
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
                      children: [
                        // ========== TOTAL REMAINING LEAVES CARD (Full Width) ==========
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
                              Text(
                                'Total Remaining Leaves',
                                style: Styles.darkGryW60014
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${leaveData['totalRemaining']}',
                                style: Styles.skyBlueW70032
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Out of ${leaveData['totalAllowed']} for this academic year',
                                style: Styles.darkBlcW40013
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========== ROW: CASUAL LEAVE & SICK LEAVE ==========
                        Row(
                          children: [
                            // ========== CASUAL LEAVE CARD ==========
                            Expanded(
                              child: Container(
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
                                          Text(
                                            'Casual Leave',
                                            style: Styles.darkGryW60012
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${leaveData['casualLeave']}',
                                            style: Styles.darkBlcW70024,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Used: ${leaveData['casualUsed']}',
                                            style: Styles.darkBlcW40010
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade700,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // ========== SICK LEAVE CARD ==========
                            Expanded(
                              child: Container(
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
                                          Text(
                                            'Sick Leave',
                                              style: Styles.darkGryW60012
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${leaveData['sickLeave']}',
                                            style: Styles.darkBlcW70024,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Used: ${leaveData['sickUsed']}',
                                              style: Styles.darkBlcW40010
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ========== EARNED LEAVE CARD (Same Width as Casual Leave) ==========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24, // 🔥 Half width minus padding
                              child: Container(
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
                                          Text(
                                            'Earned Leave',
                                              style: Styles.darkGryW60012
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${leaveData['earnedLeave']}',
                                            style: Styles.darkBlcW70024,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Used: ${leaveData['earnedUsed']}',
                                              style: Styles.darkBlcW40010
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade700,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}