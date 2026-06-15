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
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Fixed background height based on screen size
    final backgroundHeight = screenHeight < 700 ? 150.0 : 170.0;

    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
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
                              Text('Zoom Live Classes', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                    ),

                    _buildOnlineSessionsWidget(),

                    // ✅ Fixed spacing
                    const SizedBox(height: 15),
                  ],
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: liveClassesList.length,
                    itemBuilder: (context, index) {
                      return _buildLiveClassCard(liveClassesList[index]);
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

  Widget _buildOnlineSessionsWidget() {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetConstants.icVideo),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Online Sessions', style: Styles.whiteBold),
              Text('Join your scheduled classes', style: Styles.whiteW60010),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveClassCard(Map<String, dynamic> classData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: ColorsValue.cardBorderSkyClr,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      classData['subject'],
                      style: Styles.blueW70012,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorsValue.redClrs,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('LIVE', style: Styles.whiteW70009),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                        child: Center(
                          child: Text(
                            classData['teacherInitial'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
                             Text('Teacher', style: Styles.darkGryW400),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),
                  const SizedBox(height: 10),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Time', style: Styles.darkGryW600),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('10:00 AM – 11:00 AM', style: Styles.darkBlkW70013),
                          ),
                          SizedBox(width: 10),
                          JoinNowButton(),
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

class JoinNowButton extends StatelessWidget {
  const JoinNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsValue.navIconColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child:  Text(
        'Join Now',
        style: Styles.whiteW70012,
      ),
    );
  }
}