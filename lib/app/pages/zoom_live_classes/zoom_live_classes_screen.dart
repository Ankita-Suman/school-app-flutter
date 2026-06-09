import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class ZoomLiveClassesScreen extends StatelessWidget {
  ZoomLiveClassesScreen({super.key});

  final List<Map<String, dynamic>> liveClassesList = [
    {
      'subject': 'Mathematics — Algebra',
      'teacherName': 'Ramesh Tiwari',
      'teacherInitial': 'RT',
      'time': '10:00 AM – 11:00 AM',
    },
    {
      'subject': 'Science — Physics',
      'teacherName': 'Priya Sharma',
      'teacherInitial': 'PS',
      'time': '11:30 AM – 12:30 PM',
    },
    {
      'subject': 'English — Grammar',
      'teacherName': 'Amit Verma',
      'teacherInitial': 'AV',
      'time': '01:00 PM – 02:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Responsive SVG Background
          SizedBox(
            width: screenWidth,
            height: isTablet ? 200 : (isSmallPhone ? 150 : 170),
            child: SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: screenWidth,
              height: isTablet ? 200 : (isSmallPhone ? 150 : 170),
              fit: BoxFit.fill,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Fixed Header Section
                Column(
                  children: [
                    SizedBox(height: isTablet ? 20 : 15),
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: SvgPicture.asset(
                                  AssetConstants.icBackBg,
                                  // width: isTablet ? 28 : 24,
                                  // height: isTablet ? 28 : 24,
                                ),
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              Text('Zoom Live Classes', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 5),

                    // Online Sessions Widget
                    _buildOnlineSessionsWidget(isTablet, isSmallPhone),

                    SizedBox(height: isTablet ? 20 : 16),
                  ],
                ),

                // Live Classes List - Responsive padding
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    itemCount: liveClassesList.length,
                    itemBuilder: (context, index) {
                      return _buildLiveClassCard(liveClassesList[index], isTablet, isSmallPhone);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Online Sessions Widget - Responsive
  Widget _buildOnlineSessionsWidget(bool isTablet, bool isSmallPhone) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetConstants.icVideo,
            // width: isTablet ? 28 : 24,
            // height: isTablet ? 28 : 24,
          ),
          SizedBox(width: isTablet ? 10 : 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Online Sessions',
                style: Styles.whiteBold,
              ),
              Text(
                'Join your scheduled classes',
                style: Styles.whiteW60010,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Live Class Card - Responsive with original styles
  Widget _buildLiveClassCard(Map<String, dynamic> classData, bool isTablet, bool isSmallPhone) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: ColorsValue.cardBorderSkyClr,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White Container with Top Radius
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Subject Name
                  Expanded(
                    child: Text(
                      classData['subject'],
                      style: Styles.blueW70012,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  // LIVE Container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsValue.redClrs,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: isTablet ? 9 : 7,
                          height: isTablet ? 9 : 7,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 5),
                        Text(
                          'LIVE',
                          style: Styles.whiteW70009,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),

            // Bottom Section
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Teacher Info Row
                  Row(
                    children: [
                      // Teacher Initial Circle
                      Container(
                        width: isTablet ? 50 : 40,
                        height: isTablet ? 50 : 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                        child: Center(
                          child: Text(
                            classData['teacherInitial'],
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              classData['teacherName'],
                              style: Styles.darkBlackW700,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Teacher',
                              style: Styles.darkGryW400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),
                  SizedBox(height: isTablet ? 16 : 12),
                  // Time Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: Styles.darkGryW600,
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: isTablet ? 22 : 18,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: isTablet ? 12 : 8),
                          Expanded(
                            child: Text(
                              classData['time'],
                              style: Styles.darkBlkW70013,
                            ),
                          ),
                          SizedBox(width: isTablet ? 16 : 12),
                          // Join Now Button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 24 : 20,
                              vertical: isTablet ? 10 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsValue.navIconColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Join Now',
                              style: Styles.whiteW70012,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}