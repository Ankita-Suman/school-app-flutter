import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class ExaminationScreen extends StatelessWidget {
  ExaminationScreen({super.key});

  // ========== LEAVE MANAGEMENT DATA ==========
  final List<Map<String, dynamic>> leaveManagement = [

    {
      'title': 'Exam Schedule',
      'subtitle': 'View upcoming exam dates',
      'icon': Icons.calendar_today_outlined,
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Mark Entry',
      'subtitle': 'Enter subject marks',
      'icon': Icons.create_outlined,
      'color': Colors.orangeAccent,
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
                          Text('Examination', style: Styles.whiteBold),
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
                        // ========== CONTAINER: LEAVE MANAGEMENT ==========
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Items
                            ...leaveManagement.map((item) {
                              final isLast = leaveManagement.indexOf(item) ==
                                  leaveManagement.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                  bottom: isLast ? 16 : 8,
                                ),
                                child: _buildManagementCard(
                                  title: item['title'] as String,
                                  subtitle: item['subtitle'] as String,
                                  icon: item['icon'] as IconData,
                                  color: item['color'] as Color,
                                ),
                              );
                            }).toList(),
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

  // ========== BUILD MANAGEMENT CARD ==========
  Widget _buildManagementCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
                size: 24,
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
    );
  }
}