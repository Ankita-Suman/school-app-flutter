import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';

class HomeworkHistoryScreen extends StatefulWidget {
  const HomeworkHistoryScreen({super.key});

  @override
  State<HomeworkHistoryScreen> createState() => _HomeworkHistoryScreenState();
}

class _HomeworkHistoryScreenState extends State<HomeworkHistoryScreen> {
  // ========== SELECTED TAB ==========
  int _selectedTab = 0;

  // ========== HOMEWORK DATA ==========
  final List<Map<String, dynamic>> homeworkList = [
    {
      'title': 'Algebra Worksheet',
      'class': 'Class V-A',
      'subject': 'Mathematics',
      'due': '25 May 2024',
      'submitted': '20',
      'total': '32',
      'color': Colors.blue,
    },
    {
      'title': 'Fractions Practice',
      'class': 'Class V-A',
      'subject': 'Mathematics',
      'due': '28 May 2024',
      'submitted': '25',
      'total': '32',
      'color': Colors.orange,
    },
    {
      'title': 'Lines and Angles',
      'class': 'Class VI-B',
      'subject': 'Mathematics',
      'due': '01 Jun 2024',
      'submitted': '0',
      'total': '32',
      'color': Colors.green,
    },
  ];

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
                          Text('Homework History', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ========== TABS ==========
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
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
                  child: Row(
                    children: [
                      _buildTabButton('Assigned', 0),
                      _buildTabButton('Submitted', 1),
                      _buildTabButton('To Review', 2),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ========== CONTENT ==========
                Expanded(
                  child: _selectedTab == 0
                      ? _buildAssignedContent()
                      : _buildOtherTabContent(),
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
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
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

  // ========== BUILD ASSIGNED CONTENT ==========
  Widget _buildAssignedContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: homeworkList.map((item) {
          return _buildHomeworkCard(
            title: item['title'] as String,
            className: item['class'] as String,
            subject: item['subject'] as String,
            due: item['due'] as String,
            submitted: item['submitted'] as String,
            total: item['total'] as String,
            color: item['color'] as Color,
          );
        }).toList(),
      ),
    );
  }

  // ========== BUILD OTHER TAB CONTENT ==========
  Widget _buildOtherTabContent() {
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
            _selectedTab == 1 ? 'No submitted homework' : 'No homework to review',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD HOMEWORK CARD ==========
  Widget _buildHomeworkCard({
    required String title,
    required String className,
    required String subject,
    required String due,
    required String submitted,
    required String total,
    required Color color,
  }) {
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
              color: color,
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
                  // ========== TITLE & CLASS & SUBJECT ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Class
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Styles.blueW60015,
                            ),
                            Text(
                              '$className | $subject',
                              style: Styles.darkBlueW400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Due Date (Top Right)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Due: $due',
                          style:Styles.darkBlackW70011
                      ),
                  ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                            '$submitted/$total Submitted',
                            style: Styles.skyBlueW60012
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}