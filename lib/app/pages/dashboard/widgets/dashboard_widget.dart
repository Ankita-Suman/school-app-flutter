// screens/dashboard_home_screen.dart
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../../notice_board/notice_board_screen.dart';
import '../../upcoming_events/upcoming_events_screen.dart';
import '../dashboard_controller.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // ========== FIXED HEADER SECTION (Non-scrollable) ==========
            Column(
              children: [
                // Header Section
                Container(
                  decoration: const BoxDecoration(
                    color: ColorsValue.bgColors,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar with Status
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
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: ColorsValue.darkFillBlueColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Obx(() => Center(
                                      child: Text(
                                        controller.profileData.value?.personal?.name?.isNotEmpty == true
                                            ? controller.profileData.value!.personal!.name![0].toUpperCase()
                                            : 'AS',
                                        style: Styles.whiteBold,
                                      ),
                                    )),
                                  ),
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
                            // User Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Good morning 🌞',
                                      style: Styles.whiteW60010,
                                    ),
                                    Obx(() => Text(
                                      controller.profileData.value?.personal?.name ?? 'Olivier Thomas',
                                      style: Styles.whiteBold,
                                    )),
                                    Obx(() => Text(
                                      'Class ${controller.profileData.value?.personal?.classInfo?.name ?? '1'} – ${controller.profileData.value?.personal?.section?.name ?? 'A'} - Session ${controller.profileData.value?.other?.academic?.session ?? '2025 – 26'}',
                                      style: Styles.whiteW400011,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            // Notification Icon
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
                                icon: const Icon(Icons.notifications, color: Colors.white, size: 20),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Credit Score Card
                        CreditScoreCard(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // ========== SCROLLABLE TABS SECTION ==========
            Expanded(
              child: AnnouncementsTabs(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Credit Score Card
class CreditScoreCard extends StatelessWidget {
  const CreditScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    return Row(
      children: [
        // Credit Score Circle
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                 Text(
                  'CREDIT SCORE',
                  style: Styles.whiteW70010
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetConstants.progressBar,
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                       Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${controller.profileData.value?.other?.grade?.averagePercentage ?? 0}',
                            style: Styles.whiteBold
                          ),
                          Text(
                            '/100',
                            style: Styles.whiteW4009
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stats Column
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetConstants.icUserProfile,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${controller.profileData.value?.other.attendance?.percentage ?? 0}%',
                          style: Styles.whiteBold15
                        ),
                        Text(
                          'Attendance',
                            style: Styles.whiteW400010
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetConstants.icGradeStar,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            controller.profileData.value?.other?.grade?.grade ?? 'N/A',
                            style: Styles.whiteBold
                        ),
                        Text(
                          'Last Grade',
                            style: Styles.whiteW400010
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Announcements Tabs Widget (Scrollable) - E-Learning Hub in both tabs
class AnnouncementsTabs extends StatelessWidget {
  AnnouncementsTabs({super.key});

  // Static data for Announcements Tab
  final List<Map<String, dynamic>> announcementsList = [
    {
      'type': 'URGENT',
      'date': '28 Jun',
      'description': 'Drawing Competition on 28 June 2024',
      'deadline': 'Register yourself on school portal before 25 June.',
      'color': Colors.orange,
    },
    {
      'type': 'ACADEMIC',
      'date': '3 Jul',
      'description': 'Math Olympiad on 3 July 2024',
      'deadline': 'Register on the school portal. Open to Class 6-10.',
      'color': Colors.blue,
    },
    {
      'type': 'Holiday',
      'date': '10 May',
      'description': 'Summer Vacation: 10–25 May 2025',
      'deadline': 'School will remain closed for summer holidays.',
      'color': Colors.green,
    },
  ];

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();


  String _formatEventDate(String? date) {
    if (date == null || date.isEmpty) return 'Event Date';
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        // parts[0] = year (2025), parts[1] = month (06), parts[2] = day (28)
        final year = parts[0];
        final month = int.parse(parts[1]);
        final day = parts[2];
        return '$day ${_getMonthName(month)} $year';
      }
      return date;
    } catch (e) {
      return date ?? 'Event Date';
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Tab Bar with See All on Top Right
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // See All Button on Top Right
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Builder(
                      builder: (context) {
                        final TabController tabController = DefaultTabController.of(context);
                        return TextButton(
                          onPressed: () {
                            if (tabController.index == 0) {
                              RouteManagement.goToNoticeBored();
                            } else {
                              RouteManagement.goToUpcomingEvents();
                            }
                          },
                          child: const Text(
                            'See All →',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ColorsValue.navIconColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Tab Bar
                 TabBar(
                  tabs: const [
                    Tab(text: 'Announcements'),
                    Tab(text: 'Upcoming Events'),
                  ],
                  labelColor: ColorsValue.navIconColor,
                  unselectedLabelColor: ColorsValue.unSelectedClr,
                  labelStyle: Styles.darkBlueW700,
                  unselectedLabelStyle: Styles.darkBlackW700,
                  indicatorColor: ColorsValue.navIconColor,
                  indicatorWeight: 3,
                ),
              ],
            ),

            // TabBarView (Same as before)
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - Announcements (Static)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: announcementsList.length,
                          itemBuilder: (context, index) => _buildEventCard(announcementsList[index], index),
                        ),
                        const SizedBox(height: 16),
                        const ELearningHub(),
                        const SizedBox(height: 10),
                        const Academics(),
                        const SizedBox(height: 10),
                        const Others(),
                      ],
                    ),
                  ),
                  // Second Tab - Upcoming Events
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() => _buildCarouselSlider(controller)),
                        const SizedBox(height: 16),
                        const ELearningHub(),
                        const SizedBox(height: 10),
                        const Academics(),
                        const SizedBox(height: 10),
                        const Others(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(DashboardController controller) {
    final events = controller.eventsData.value?.data?.events ?? [];

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    // Reset index if needed
    if (_currentIndex >= events.length) {
      _currentIndex = 0;
    }

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorsValue.navBgColors,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
            items: events.map((event) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _formatEventDate(event.eventDate),
                                    style: Styles.darkBlcW70010,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    border: Border.all(color: Colors.grey.shade500, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    event.eventType?.toUpperCase() ?? 'EVENT',
                                    style: Styles.whiteW70010W,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                _currentIndex = index;
              },
            ),
            carouselController: _carouselController,
          ),

          // Title and Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  events[_currentIndex].title ?? 'Upcoming Event',
                  style: Styles.darkBlkW70014,
                ),
                const SizedBox(height: 3),
                Text(
                  events[_currentIndex].description ?? 'Join us for this event',
                  style: Styles.darkGryW40011,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SvgPicture.asset(AssetConstants.icLocations),
                    const SizedBox(width: 5),
                    Text(
                      events[_currentIndex].location ?? 'School Premises',
                      style: Styles.darkBlkW400,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: events.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key ? Colors.blue : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  Widget _buildEventCard(Map<String, dynamic> event, int index) {
    // Get light shade color based on event color
    Color getLightShade(Color color) {
      return color.withOpacity(0.10); // 15% opacity for light shade
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: getLightShade(event['color']), // ✅ Light shade background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (event['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Vertical Colored Line
          Container(
            width: 4,
            height: 100,
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            decoration: BoxDecoration(
              color: event['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(left: 12, top: 25),
            decoration: BoxDecoration(
              color: (event['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              event['type'] == 'URGENT' ? Icons.priority_high :
              event['type'] == 'ACADEMIC' ? Icons.school :
              event['type'] == 'Holiday' ? Icons.beach_access :
              Icons.person,
              color: event['color'],
              size: 20,
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                          event['type'],
                          style: index==0?Styles.orangeBold700:index==1?
                          Styles.blueBold70009:index==2?Styles.greenBold70009:Styles.rdBold70009
                      ),
                      Text(
                        event['date'],
                        style: Styles.darkBlkW60010,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                      event['description'],
                      style: Styles.darkBlackW700
                  ),
                  const SizedBox(height: 4),
                  Text(
                      event['deadline'],
                      style: Styles.darkBlkW400
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

// E-Learning Hub Widget - 2 Rows with 4 items each (Appears in both tabs)
class ELearningHub extends StatelessWidget {
  const ELearningHub({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': AssetConstants.icWork, 'label': 'Home Work'},
    {'icon': AssetConstants.icTask, 'label': 'Daily Task'},
    {'icon': AssetConstants.icLsn, 'label': 'Lesson Plan'},
    {'icon': AssetConstants.icPc, 'label': 'Online Exam'},
    {'icon': AssetConstants.icDown, 'label': 'Downloads'},
    {'icon': AssetConstants.icZoom, 'label': 'Zoom Classes'},
    {'icon': AssetConstants.icMeet, 'label': 'Gmeet Classes'},
    {'icon': AssetConstants.icClass, 'label': 'Team Classes'},
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
            'E-Learning Hub',
            style: Styles.darkBlkW70014,
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.9, // Changed to 0.9 for better fit
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
                index: index,
              );
            },
          ),
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
          case 0:
          // RouteManagement.goToHomework();
            break;
          case 1:
          // RouteManagement.goToDailyTime();
            break;
          case 2:
          // RouteManagement.goToLibraryHour();
            break;
          case 3:
          // RouteManagement.goToOnlineLibrary();
            break;
          case 4:
          // RouteManagement.goToDownloads();
            break;
          case 5:
            RouteManagement.goToZoomLiveClasses();
            break;
          case 6:
          // RouteManagement.goToDownloadLibrary();
            break;
          case 7:
            RouteManagement.goToTeamLiveClasses();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4), // Reduced vertical padding
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
                const SizedBox(height: 2),
                SvgPicture.asset(
                  svgIcon,
                  height: 18, // Further reduced
                  width: 18,  // Further reduced
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 2), // Reduced spacing
                Flexible(
                  child: Text(
                    label,
                    style: Styles.darkBlkW600013?.copyWith(
                      fontSize: 9, // Optimal font size
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
}// E-Learning Hub Widget - 2 Rows with 4 items each (Appears in both tabs)
class Academics extends StatelessWidget {
  const Academics({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': AssetConstants.icTime, 'label': 'Time Table'},
    {'icon': AssetConstants.icCourse, 'label': 'Course Status'},
    {'icon': AssetConstants.icAttan, 'label': 'Attendance'},
    {'icon': AssetConstants.icExams, 'label': 'Examinations'},
    {'icon': AssetConstants.icTimeline, 'label': 'Timeline'},
    {'icon': AssetConstants.icDoc, 'label': 'My Documents'},
    {'icon': AssetConstants.icGrades, 'label': 'Grades'},
    {'icon': AssetConstants.icPc, 'label': 'CBSE Exams'},
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
            'Academics',
            style: Styles.darkBlkW70014,
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.9, // Changed to 0.9 for square shape with better fit
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
                index: index,
              );
            },
          ),
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
          case 0:
          // RouteManagement.goToHomework();
            break;
          case 1:
          // RouteManagement.goToDailyTime();
            break;
          case 2:
          // RouteManagement.goToLibraryHour();
            break;
          case 3:
          // RouteManagement.goToOnlineLibrary();
            break;
          case 4:
          // RouteManagement.goToDownloads();
            break;
          case 5:
          // RouteManagement.goToZoomLiveClasses();
            break;
          case 6:
          // RouteManagement.goToDownloadLibrary();
            break;
          case 7:
          // RouteManagement.goToTeamLiveClasses();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4), // Reduced padding
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svgIcon,
                  height: 18, // Reduced from 28
                  width: 18,  // Reduced from 28
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 2), // Reduced from 8
                Flexible(
                  child: Text(
                    label,
                    style: Styles.darkBlkW600013?.copyWith(
                      fontSize: 9, // Smaller text size for better fit
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
// E-Learning Hub Widget - 2 Rows with 4 items each (Appears in both tabs)
class Others extends StatelessWidget {
  const Others({super.key});

  final List<Map<String, dynamic>> menuItems = const [
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
          Text(
            'Others',
            style: Styles.darkBlkW70014,
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.9, // Changed to 0.9 for square shape with better fit
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
                index: index,
              );
            },
          ),
          const SizedBox(height:5),
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
          case 0:
          // RouteManagement.goToHomework();
            break;
          case 1:
            RouteManagement.goToApplyLeave();
            break;
          case 2:
          // RouteManagement.goToLibraryHour();
            break;
          case 3:
          // RouteManagement.goToOnlineLibrary();
            break;
          case 4:
          // RouteManagement.goToDownloads();
            break;
          case 5:
          // RouteManagement.goToZoomLiveClasses();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4), // Reduced padding
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svgIcon,
                  height: 18, // Reduced from 28
                  width: 18,  // Reduced from 28
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 2), // Reduced from 8
                Flexible(
                  child: Text(
                    label,
                    style: Styles.darkBlkW600013?.copyWith(
                      fontSize: 9, // Smaller text size for better fit
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