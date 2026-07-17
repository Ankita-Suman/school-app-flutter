import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/late_arrivals_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'late_arrivals_controller.dart';

class LateArrivalsScreen extends StatefulWidget {
  const LateArrivalsScreen({super.key});

  @override
  State<LateArrivalsScreen> createState() => _LateArrivalsScreenState();
}

class _LateArrivalsScreenState extends State<LateArrivalsScreen> {
  late final LateArrivalsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LateArrivalsController(Get.find()));
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
                          Text('Late Arrivals', style: Styles.whiteBold),
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
                              '${controller.totalCount} Students',
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
                              Icons.history,
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
                        children: controller.lateArrivals.map((arrival) {
                          return _buildLateArrivalCard(arrival);
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

  // ========== BUILD LATE ARRIVAL CARD ==========
  Widget _buildLateArrivalCard(LateArrival arrival) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== VERTICAL LINE ==========
          Container(
            width: 6,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),

          // ========== CONTENT ==========
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========== NAME & CLASS & TIME ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Class
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              arrival.studentName,
                              style: Styles.darkBlcW60015,
                            ),
                            Text(
                              '${arrival.className} - ${arrival.sectionName} • Reg: ${arrival.studentRollNumber}',
                              style: Styles.darkBlueW400,
                            ),
                          ],
                        ),
                      ),
                      // Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            arrival.formattedDate,
                            style: Styles.darkBlcW70014,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.red.shade200,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'LATE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ========== REMARKS ==========
                  if (arrival.hasRemarks)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Remarks: ${arrival.remarks}',
                        style: Styles.darkOrangeW60010,
                      ),
                    ),
                ],
              ),
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
        return 'No late arrivals for today';
      case 1:
        return 'No late arrivals for this week';
      case 2:
        return 'No late arrivals for this month';
      default:
        return 'No late arrivals found';
    }
  }
}