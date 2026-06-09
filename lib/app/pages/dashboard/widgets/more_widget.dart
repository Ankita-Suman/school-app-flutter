import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../app.dart';
import '../dashboard.dart';

class MoreWidget extends StatelessWidget {
  const MoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.navBgColors,
        body: SafeArea(
          child: Column(
            children: [
              // Fixed Header Section (Non-scrollable)
              Stack(
                children: [
                  // SVG Background Image - Responsive
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      AssetConstants.icBlueBg,
                      width: screenWidth,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content on top of SVG
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                        // Profile Container
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Obx(() => Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue.shade300,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: controller.profileData
                                              .value?.personal?.photo != null
                                              ? Image.network(
                                            controller.profileData
                                                .value!.personal!.photo!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.fill,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                AssetConstants.userImage,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.fill,
                                              );
                                            },
                                          )
                                              : Image.asset(
                                            AssetConstants.userImage,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.profileData.value?.personal?.name ??
                                              'Olivier Thomas',
                                          style: Styles.whiteBold,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Class ${controller.profileData.value?.personal?.classInfo?.name ?? '1'} – ${controller.profileData.value?.personal?.section?.name ?? 'A'} - Session ${controller.profileData.value?.other?.academic?.session ?? '2025 – 26'}',
                                          style: Styles.whiteW400,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                'Roll. No. ${controller.profileData.value?.personal?.rollNumber ?? '18001'}',
                                                style: Styles.whiteW40011,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Scrollable Grid Section
              const Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      CombinedGridWidget(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CombinedGridWidget extends StatelessWidget {
  const CombinedGridWidget({super.key});

  // Combined menu items for all three sections
  final List<Map<String, dynamic>> allMenuItems = const [
    // E-Learning Hub Items (0-7)
    {'icon': AssetConstants.icWork, 'label': 'Home Work', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icTask, 'label': 'Daily Task', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icLsn, 'label': 'Lesson Plan', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icPc, 'label': 'Online Exam', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icDown, 'label': 'Downloads', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icZoom, 'label': 'Zoom Classes', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icMeet, 'label': 'Gmeet Classes', 'section': 'E-Learning Hub'},
    {'icon': AssetConstants.icClass, 'label': 'Team Classes', 'section': 'E-Learning Hub'},

    // Academics Items (8-15)
    {'icon': AssetConstants.icTime, 'label': 'Time Table', 'section': 'Academics'},
    {'icon': AssetConstants.icCourse, 'label': 'Course Status', 'section': 'Academics'},
    {'icon': AssetConstants.icAttan, 'label': 'Attendance', 'section': 'Academics'},
    {'icon': AssetConstants.icExams, 'label': 'Examinations', 'section': 'Academics'},
    {'icon': AssetConstants.icTimeline, 'label': 'Timeline', 'section': 'Academics'},
    {'icon': AssetConstants.icDoc, 'label': 'My Documents', 'section': 'Academics'},
    {'icon': AssetConstants.icGrades, 'label': 'Grades', 'section': 'Academics'},
    {'icon': AssetConstants.icPc, 'label': 'CBSE Exams', 'section': 'Academics'},

    // Others Items (16-21)
    {'icon': AssetConstants.icFee, 'label': 'Fees', 'section': 'Others'},
    {'icon': AssetConstants.icApply, 'label': 'Apply Leave', 'section': 'Others'},
    {'icon': AssetConstants.icRoutes, 'label': 'Routes', 'section': 'Others'},
    {'icon': AssetConstants.icTo, 'label': 'To Do List', 'section': 'Others'},
    {'icon': AssetConstants.icLib, 'label': 'Library', 'section': 'Others'},
    {'icon': AssetConstants.icRate, 'label': 'Reviews', 'section': 'Others'},
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
          Text(
            'All Features',
            style: Styles.darkBlkW70014,
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0, // Reduced from 0.9 to make boxes smaller
              crossAxisSpacing: 8,
              mainAxisSpacing: 12, // Reduced from 14
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
        // Navigate based on combined index
        switch (index) {
        // E-Learning Hub Items (0-7)
          case 0:
          // Home Work
            break;
          case 1:
          // Daily Task
            break;
          case 2:
          // Lesson Plan
            break;
          case 3:
          // Online Exam
            break;
          case 4:
          // Downloads
            break;
          case 5:
            RouteManagement.goToZoomLiveClasses();
            break;
          case 6:
          // Gmeet Classes
            break;
          case 7:
            RouteManagement.goToTeamLiveClasses();
            break;

        // Academics Items (8-15)
          case 8:
          // Time Table
            break;
          case 9:
          // Course Status
            break;
          case 10:
          // Attendance
            break;
          case 11:
          // Examinations
            break;
          case 12:
          // Timeline
            break;
          case 13:
          // My Documents
            break;
          case 14:
          // Grades
            break;
          case 15:
          // CBSE Exams
            break;

        // Others Items (16-21)
          case 16:
          // Fees
            break;
          case 17:
            RouteManagement.goToApplyLeave();
            break;
          case 18:
          // Routes
            break;
          case 19:
          // To Do List
            break;
          case 20:
          // Library
            break;
          case 21:
          // Reviews
            break;

          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6), // Increased padding
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Increased icon size
                SvgPicture.asset(
                  svgIcon,
                  height: 28, // Increased from 18 to 24
                  width: 28,  // Increased from 18 to 24
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8), // Increased spacing
                Flexible(
                  child: Text(
                    label,
                    style: Styles.darkBlkW600013?.copyWith(
                      fontSize: 12, // Increased from 9 to 11
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}