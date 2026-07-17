// screens/dashboard_home_screen.dart
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../dashboard_controller.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController(Get.find()), permanent: true);
    }

    final DashboardController controller = Get.find<DashboardController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ Set navigation bar and status bar styles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          // Status Bar (Top)
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,

          // Navigation Bar (Bottom)
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
          // ========== FIXED HEADER SECTION (Non-scrollable) ==========
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
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
              // Content on top of SVG
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
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
                                  'Class ${controller.profileData.value?.personal?.classInfo?.name ?? '1'} – ${controller.profileData.value?.personal?.section?.name ?? 'A'}',
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
            ],
          ),
          const SizedBox(height: 16),

          // ========== SCROLLABLE TABS SECTION ==========
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: AnnouncementsTabs(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(DashboardController controller) {
    String? photoUrl = controller.profileData.value?.personal?.photo;
    String? fullName = controller.profileData.value?.personal?.name;

    // Agar image hai to show image
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Image fail ho to initials dikhao
            return _buildInitialsAvatar(fullName);
          },
        ),
      );
    }

    // Image nahi hai to initials dikhao
    return _buildInitialsAvatar(fullName);
  }

  Widget _buildInitialsAvatar(String? fullName) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: ColorsValue.bgColors,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(fullName),
          style: Styles.whiteBold.copyWith(fontSize: 18),
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

// Credit Score Card (No changes needed)
class CreditScoreCard extends StatelessWidget {
  const CreditScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final percentage = controller.profileData.value?.other?.grade?.averagePercentage ?? 0;
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
                    'STUDENT PR',
                    style: Styles.whiteW70010
                ),
                const SizedBox(height: 8),
                DynamicProgressBar(
                  percentage: 50.0,
                  height: 6,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  progressColor: ColorsValue.lightYellowClr,
                  borderRadius: 4,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${controller.profileData.value?.other?.grade?.averagePercentage ?? 0}',
                        style: Styles.whiteBold
                    ),
                    const SizedBox(width: 5),
                    Text(
                        '/100',
                        style: Styles.whiteW4009
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stats Column
        Expanded(
          flex: 2,
          child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
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
                      height: 25,
                      width: 25,
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
        ),
      ],
    );
  }
}

// Announcements Tabs Widget (Scrollable)
// Announcements Tabs Widget (Scrollable) - Fixed spacing
class AnnouncementsTabs extends StatelessWidget {
  AnnouncementsTabs({super.key});

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
      margin: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
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
            // Tab Bar with See All on Top Right
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // See All Button on Top Right
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 0),
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
                // Tab Bar - Reduced indicator weight
                const TabBar(
                  tabs: [
                    Tab(text: 'Announcements'),
                    Tab(text: 'Upcoming Events'),
                  ],
                  labelColor: ColorsValue.navIconColor,
                  unselectedLabelColor: ColorsValue.unSelectedClr,
                  indicatorColor: ColorsValue.navIconColor,
                  indicatorWeight: 2, // ✅ Reduced from 3
                ),
              ],
            ),

            // TabBarView - Reduced spacing
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
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // ✅ Reduced vertical padding
                          itemCount: announcementsList.length,
                          itemBuilder: (context, index) => _buildEventCard(announcementsList[index], index),
                        ),
                        const SizedBox(height: 8), // ✅ Reduced from 15
                      ],
                    ),
                  ),
                  // Second Tab - Upcoming Events
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() => _buildCarouselSlider(controller)),
                        const SizedBox(height: 8), // ✅ Reduced from 15
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

  // Rest of the methods remain the same...
  Widget _buildCarouselSlider(DashboardController controller) {
    final events = controller.eventsData.value?.data?.events ?? [];

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

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
    Color getLightShade(Color color) {
      return color.withOpacity(0.10);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8), // ✅ Reduced from 12
      decoration: BoxDecoration(
        color: getLightShade(event['color']),
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
          Container(
            width: 4,
            height: 90, // ✅ Reduced from 100
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
            margin: const EdgeInsets.only(left: 12, top: 20), // ✅ Reduced from 25
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
              size: 18, // ✅ Reduced from 20
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10), // ✅ Reduced from 12
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 4), // ✅ Reduced from 6
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event['type'],
                        style: index == 0 ? Styles.orangeBold700 : index == 1 ? Styles.blueBold70009 : index == 2 ? Styles.greenBold70009 : Styles.rdBold70009,
                      ),
                      Text(
                        event['date'],
                        style: Styles.darkBlkW60010,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // ✅ Reduced from 6
                  Text(
                    event['description'],
                    style: Styles.darkBlackW700,
                  ),
                  const SizedBox(height: 2), // ✅ Reduced from 4
                  Text(
                    event['deadline'],
                    style: Styles.darkBlkW400,
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
class DynamicProgressBar extends StatelessWidget {
  final double percentage; // 0 to 100
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;

  const DynamicProgressBar({
    super.key,
    required this.percentage,
    this.height = 6,
    this.backgroundColor = Colors.white24,
    this.progressColor = ColorsValue.lightYellowClr,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercentage = percentage.clamp(0.0, 100.0);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Align(
        alignment: Alignment.centerLeft, // ✅ Add this - left alignment
        child: FractionallySizedBox(
          widthFactor: clampedPercentage / 100,
          child: Container(
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}