import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../app.dart';
import '../teacher_dashboard.dart';

class MoreWidget extends StatelessWidget {
  const MoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return GetBuilder<TeacherDashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.blue.shade700,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetConstants.icBlueBg,
                    width: screenWidth,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text('Other Options', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: const Column(
                    children: [
                      CombinedGridWidget(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'AS';

    List<String> parts = fullName.trim().split(' ');

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    String first = parts[0][0].toUpperCase();
    String last = parts[parts.length - 1][0].toUpperCase();
    return '$first$last';
  }
}

// CombinedGridWidget remains same
class CombinedGridWidget extends StatelessWidget {
  const CombinedGridWidget({super.key});

  final List<Map<String, dynamic>> allMenuItems = const [
    {'icon': AssetConstants.icWork, 'label': 'Home Work'},
    {'icon': AssetConstants.icTask, 'label': 'Daily Task'},
    {'icon': AssetConstants.icLsn, 'label': 'Lesson Plan'},
    {'icon': AssetConstants.icPc, 'label': 'Online Exam'},
    {'icon': AssetConstants.icDown, 'label': 'Downloads'},
    {'icon': AssetConstants.icZoom, 'label': 'Zoom Classes'},
    {'icon': AssetConstants.icMeet, 'label': 'Gmeet Classes'},
    {'icon': AssetConstants.icClass, 'label': 'Team Classes'},
    {'icon': AssetConstants.icTime, 'label': 'Time Table'},
    {'icon': AssetConstants.icCourse, 'label': 'Course Status'},
    {'icon': AssetConstants.icAttan, 'label': 'Attendance'},
    {'icon': AssetConstants.icExams, 'label': 'Examinations'},
    {'icon': AssetConstants.icTimeline, 'label': 'Timeline'},
    {'icon': AssetConstants.icDoc, 'label': 'My Documents'},
    {'icon': AssetConstants.icGrades, 'label': 'Grades'},
    {'icon': AssetConstants.icPc, 'label': 'CBSE Exams'},
    {'icon': AssetConstants.icFee, 'label': 'Fees'},
    {'icon': AssetConstants.icApply, 'label': 'Apply Leave'},
    {'icon': AssetConstants.icRoutes, 'label': 'Routes'},
    {'icon': AssetConstants.icTo, 'label': 'To Do List'},
    {'icon': AssetConstants.icLib, 'label': 'Library'},
    {'icon': AssetConstants.icRate, 'label': 'Reviews'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Access', style: Styles.darkBlkW70014),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: allMenuItems.length,
            itemBuilder: (context, index) {
              final item = allMenuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
                index: index,
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String svgIcon,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 5:
            RouteManagement.goToZoomLiveClasses();
            break;
          case 7:
            RouteManagement.goToTeamLiveClasses();
            break;
          case 16:
          // RouteManagement.goToFeesDetails();
            break;
          case 17:
            RouteManagement.goToApplyLeave();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgIcon, height: 28, width: 28, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: Styles.darkBlkW600013?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}