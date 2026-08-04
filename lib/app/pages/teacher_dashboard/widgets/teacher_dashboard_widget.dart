// screens/dashboard_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../../../../domain/models/teacher_dashboard_response.dart';
import '../teacher_dashboard_controller.dart';

class TeacherDashboardHomeScreen extends StatelessWidget {
  const TeacherDashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TeacherDashboardController>()) {
      Get.put(TeacherDashboardController(Get.find()), permanent: true);
    }

    final TeacherDashboardController controller =
        Get.find<TeacherDashboardController>();
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          // ========== FIXED HEADER SECTION ==========
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  AssetConstants.icBlueBg,
                  width: screenWidth,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorsValue.lightBorderBlueColor,
                                  width: 2,
                                ),
                              ),
                              child: _buildAvatar(controller),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Good morning 🌞',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    _getTeacherName(controller),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  _getStaffId(controller),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              controller.showComingSoonSnackbar();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),

          // ========== SCROLLABLE CONTENT SECTION ==========
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 GRID VIEW - Dashboard Cards
                  SizedBox(
                    height: 280,
                    child: Obx(() {
                      final cards = controller.dashboardCards ?? [];
                      final displayCards =
                          cards.isNotEmpty ? cards : _getDefaultCards();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 7,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: displayCards.length,
                        itemBuilder: (context, index) {
                          final card = displayCards[index];
                          return _buildDashboardCard(
                            card: card,
                            index: index,
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  const GridWidget(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== GET DEFAULT CARDS ==========
  List<DashboardCard> _getDefaultCards() {
    return [
      DashboardCard(
        id: '1',
        title: 'View Timetable',
        value: '0',
        time: '8:00 AM - 2:00 PM',
        type: DashboardCardType.timetable,
      ),
      DashboardCard(
        id: '2',
        title: 'To Review',
        value: '0',
        time: 'Homework submissions',
        type: DashboardCardType.reviews,
      ),
      DashboardCard(
        id: '3',
        title: 'Announcements',
        value: '0',
        time: 'Latest update preview',
        type: DashboardCardType.announcements,
      ),
      DashboardCard(
        id: '4',
        title: 'Staff Meeting',
        value: '',
        time: '28 Jun, 2:00 PM',
        type: DashboardCardType.meeting,
      ),
    ];
  }

  // ========== BUILD DASHBOARD CARD ==========
  Widget _buildDashboardCard({
    required DashboardCard card,
    required int index,
  }) {
    final bool isTimetable = card.type == DashboardCardType.timetable;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                _getCardIcon(card.type),
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(
                card.hasValue ? card.value : '0',
                style: Styles.darkBlcW70020,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            card.title,
            style: isTimetable ? Styles.skyBlueW50012 : Styles.darkBlcW600,
          ),
          const SizedBox(height: 2),
          Text(
            card.time ?? '',
            style: Styles.darkBlueW400,
          ),
        ],
      ),
    );
  }

  // ========== GET CARD ICON ==========
  String _getCardIcon(DashboardCardType type) {
    switch (type) {
      case DashboardCardType.timetable:
        return AssetConstants.icTable;
      case DashboardCardType.reviews:
        return AssetConstants.icReviews;
      case DashboardCardType.announcements:
        return AssetConstants.icBell;
      case DashboardCardType.meeting:
        return AssetConstants.icTimer;
      default:
        return AssetConstants.icTable;
    }
  }

  // ========== HELPER METHODS ==========

  String _getTeacherName(TeacherDashboardController controller) {
    final teacher = controller.teacherInfo;
    if (teacher != null) {
      return teacher.fullName;
    }
    return 'Teacher';
  }

  String _getStaffId(TeacherDashboardController controller) {
    final teacher = controller.teacherInfo;
    if (teacher != null) {
      return 'Staff ID: ${teacher.staffId}';
    }
    return 'Have a great day at School!';
  }

  // ========== BUILD AVATAR ==========
  Widget _buildAvatar(TeacherDashboardController controller) {
    final teacher = controller.teacherInfo;
    String? fullName = teacher?.fullName ?? 'Teacher';

    // Check if photo exists
    if (teacher?.hasPhoto == true) {
      return ClipOval(
        child: Image.network(
          teacher!.photo!,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar(fullName);
          },
        ),
      );
    }

    return _buildInitialsAvatar(fullName);
  }

  Widget _buildInitialsAvatar(String fullName) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: ColorsValue.bgColors,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(fullName),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'T';
    List<String> parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    String first = parts[0][0].toUpperCase();
    String last = parts[parts.length - 1][0].toUpperCase();
    return '$first$last';
  }
}

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  final List<Map<String, dynamic>> allMenuItems = const [
    {'icon': AssetConstants.icTClass, 'label': 'Class'},
    {'icon': AssetConstants.tStudent, 'label': 'Student'},
    {'icon': AssetConstants.tAttan, 'label': 'Attendance'},
    {'icon': AssetConstants.tHome, 'label': 'Homework & Assignments'},
    {'icon': AssetConstants.tLesson, 'label': 'Lesson Planning'},
    {'icon': AssetConstants.tExam, 'label': 'Examination'},
    {'icon': AssetConstants.tStaf, 'label': 'Staff Leave'},
    {'icon': AssetConstants.tOnline, 'label': 'Online Classes'},
    {'icon': AssetConstants.tFee, 'label': 'Fee Info (View)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Access', style: Styles.darkBlcW70016),
        const SizedBox(height: 12),
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
          case 0:
            RouteManagement.goToMyClasses();
            break;
          case 1:
            RouteManagement.goToMyStudentClassList();
            break;
          case 2:
            RouteManagement.goToAttendanceManagement();
            break;
          case 3:
            RouteManagement.goToHomeworkAssignment();
            break;
          case 4:
            RouteManagement.goToLessonPlanning();
            break;
          case 5:
            RouteManagement.goToExamination();
            break;
          case 6:
            RouteManagement.goToStaffLeave();
            break;
          case 7:
            RouteManagement.goToCreateLiveClass();
            break;
          case 8:
            RouteManagement.goToFeeCollection();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgIcon,
                height: 40, width: 40, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: Styles.darkBlcW50011,
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
