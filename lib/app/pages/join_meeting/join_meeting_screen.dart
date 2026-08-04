// screens/join_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  // ========== MEETING DATA ==========
  final List<Map<String, dynamic>> meetingList = [
    {
      'subject': 'Science - Chemical Reactions',
      'class': 'Class VI - A',
      'platform': 'Zoom',
      'time': '10:00 AM - 11:00 AM',
      'status': 'Ongoing', // Ongoing or Upcoming
      'color': Colors.blue,
    },
    {
      'subject': 'Maths - Algebra Basics',
      'class': 'Class VII - B',
      'platform': 'Teams',
      'time': '02:00 PM - 03:00 PM',
      'status': 'Upcoming',
      'color': Colors.orange,
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
                          Text('Join Meeting', style: Styles.whiteBold),
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
                        // ========== TODAY'S CLASSES TITLE ==========
                        Text(
                          "Today's Classes",
                          style: Styles.darkBlcW70014,
                        ),
                        const SizedBox(height: 12),

                        // ========== MEETING LIST ==========
                        ...meetingList.map((item) {
                          return _buildMeetingCard(
                            subject: item['subject'] as String,
                            className: item['class'] as String,
                            platform: item['platform'] as String,
                            time: item['time'] as String,
                            status: item['status'] as String,
                            color: item['color'] as Color,
                          );
                        }),
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

  // ========== BUILD MEETING CARD ==========
  Widget _buildMeetingCard({
    required String subject,
    required String className,
    required String platform,
    required String time,
    required String status,
    required Color color,
  }) {
    // Status badge color
    bool isOngoing = status == 'Ongoing';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
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
          // ========== SUBJECT & STATUS BADGE ==========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Subject
              Expanded(
                child: Text(
                  subject,
                  style: Styles.darkBlcW60014,
                ),
              ),
              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.green.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOngoing
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isOngoing
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // ========== CLASS & PLATFORM ==========
          Text(
            '$className | Platform: $platform',
            style: Styles.darkBlueW400,
          ),
          const SizedBox(height: 10),

          // ========== DIVIDER ==========
          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),
          const SizedBox(height: 10),

          // ========== TIME & JOIN BUTTON ==========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: Styles.darkBlcW60015),
              // ========== JOIN BUTTON ==========
              ElevatedButton(
                onPressed: () {
                  // Join meeting logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Join Now', style: Styles.whiteW600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
