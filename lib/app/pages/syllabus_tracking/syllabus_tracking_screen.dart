import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';

class SyllabusTrackingScreen extends StatefulWidget {
  const SyllabusTrackingScreen({super.key});

  @override
  State<SyllabusTrackingScreen> createState() => _SyllabusTrackingScreenState();
}

class _SyllabusTrackingScreenState extends State<SyllabusTrackingScreen> {
  // ========== SYLLABUS DATA ==========
  final Map<String, dynamic> syllabusData = {
    'class': 'Class VI - A',
    'subject': 'Science',
    'totalChapters': 10,
    'completedChapters': 4,
  };

  // ========== CHAPTERS DATA ==========
  final List<Map<String, dynamic>> chapters = [
    {'name': 'Food: Where Does It Come From?', 'progress': 100},
    {'name': 'Components of Food', 'progress': 60},
    {'name': 'Fibre to Fabric', 'progress': 0},
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
                          Text('Syllabus Tracking', style: Styles.whiteBold),
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
                        // ========== CLASS & SUBJECT (Single Container) ==========
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                            children: [
                              // Class
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Class',
                                      style: Styles.darkBlueW40010,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      syllabusData['class'] as String,
                                      style: Styles.darkBlcW70013,
                                    ),
                                  ],
                                ),
                              ),
                              // Vertical Divider
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(width: 12),
                              // Subject
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Subject',
                                      style: Styles.darkBlueW40010,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      syllabusData['subject'] as String,
                                      style: Styles.darkBlcW70013,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========== OVERALL SYLLABUS CARD ==========
                        Container(
                          padding: const EdgeInsets.all(20),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row: Title + Percentage
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Text(
                                    'Overall Syllabus',
                                    style: Styles.darkBlcW70014
                                  ),

                                     Text(
                                          '${syllabusData['completedChapters']} of ${syllabusData['totalChapters']} Chapters Completed',
                                          style: Styles.darkBlackW60012
                                        ),


                                ],
                              ),
                                  Text(
                                    '${((syllabusData['completedChapters'] / syllabusData['totalChapters']) * 100).toStringAsFixed(0)}%',
                                    style: Styles.darkGreenW70020
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ========== CHAPTERS PROGRESS ==========
                        Text(
                          'Chapters Progress',
                          style: Styles.darkBlcW700,
                        ),
                        const SizedBox(height: 12),

                        // ========== CHAPTERS LIST ==========
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return _buildChapterItem(
                              name: chapter['name'] as String,
                              progress: chapter['progress'] as int,
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

  // ========== BUILD CHAPTER ITEM ==========
  Widget _buildChapterItem({
    required String name,
    required int progress,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Styles.darkBlcW70013
                ),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  fontFamily: GoogleFonts.sora().fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _getProgressColor(progress),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ========== PROGRESS BAR ==========
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: progress > 0
                ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress / 100,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: _getProgressColor(progress),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            )
                : null, // 🔥 0% par empty (fully grey)
          ),
        ],
      ),
    );
  }

// ========== GET PROGRESS COLOR ==========
  Color _getProgressColor(int progress) {
    if (progress == 100) {
      return Colors.green.shade700; // 🟢 Green - Complete
    } else if (progress >= 40) {
      return Colors.blue.shade700; // 🔵 Blue - In Progress (40-99%)
    } else if (progress > 0 && progress < 40) {
      return Colors.orange.shade700; // 🟠 Orange - Low Progress (1-39%)
    } else {
      return Colors.grey.shade200; // ⚪ Grey - 0%
    }
  }
}