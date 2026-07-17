import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';

class ExaminationScheduleScreen extends StatefulWidget {
  const ExaminationScheduleScreen({super.key});

  @override
  State<ExaminationScheduleScreen> createState() => _ExaminationScheduleScreenState();
}

class _ExaminationScheduleScreenState extends State<ExaminationScheduleScreen> {
  // ========== EXAM DATA ==========
  final Map<String, dynamic> examData = {
    'examType': 'Mid Term 2026',
    'class': 'VI - A',
  };

  // ========== EXAM SCHEDULE DATA ==========
  final List<Map<String, dynamic>> examSchedule = [
    {
      'subject': 'Mathematics',
      'date': '12 Sep',
      'time': '09:00 AM - 12:00 PM',
      'day': 'Monday',
      'color': Colors.blue,
    },
    {
      'subject': 'Science',
      'date': '14 Sep',
      'time': '09:00 AM - 12:00 PM',
      'day': 'Wednesday',
      'color': Colors.green,
    },
    {
      'subject': 'English',
      'date': '16 Sep',
      'time': '09:00 AM - 12:00 PM',
      'day': 'Friday',
      'color': Colors.orange,
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
                          Text('Examination Schedule', style: Styles.whiteBold),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== EXAM TYPE & CLASS ==========
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exam Type',
                                    style: Styles.darkBlackW60012,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.06),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      examData['examType'] as String,
                                      style: Styles.darkBlcW400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Class',
                                    style: Styles.darkBlackW60012,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.06),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      examData['class'] as String,
                                      style: Styles.darkBlcW400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // ========== MID TERM TIME TABLE TITLE ==========
                        Text(
                          'Mid Term Time Table',
                          style: Styles.darkBlcW70014,
                        ),
                        const SizedBox(height: 12),

                        // ========== EXAM SCHEDULE LIST ==========
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: examSchedule.length,
                          itemBuilder: (context, index) {
                            final exam = examSchedule[index];
                            return _buildExamCard(
                              subject: exam['subject'] as String,
                              date: exam['date'] as String,
                              time: exam['time'] as String,
                              day: exam['day'] as String,
                              color: exam['color'] as Color,
                            );
                          },
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

  // ========== BUILD EXAM CARD (FIXED) ==========
  Widget _buildExamCard({
    required String subject,
    required String date,
    required String time,
    required String day,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== MIDDLE: Subject & Time ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: Styles.darkBlcW60015,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style:Styles.darkBlueW400
                ),
              ],
            ),
          ),

          // ========== RIGHT SIDE: Date & Day ==========
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: Styles.skyBlueW70014,
              ),
              const SizedBox(height: 4),
              Text(
                day,
                style: Styles.darkBlueW400
              ),
            ],
          ),
        ],
      ),
    );
  }
}