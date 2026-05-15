// screens/dashboard_home_screen.dart
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../dashboard_controller.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                    child:  Center(
                                      child: Text(
                                        'AS',
                                        style: Styles.whiteBold
                                      ),
                                    ),
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
                                      style: Styles.whiteW60010
                                    ),
                                     Text(
                                      'Olivier Thomas',
                                      style:Styles.whiteBold
                                    ),
                                    Text(
                                      'Class 9-A · EN/2024/O124',
                                      style: Styles.whiteW400011
                                    ),
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
                        const CreditScoreCard(),
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
                            '85',
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
                          '92%',
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
                          'A+',
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

  final List<Map<String, dynamic>> upcomingEventsList = [
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

  final List<Map<String, dynamic>> carouselAnnouncements = const [
    {
      'image': 'assets/images/bg.png',
      'title': 'Summer Camp 2025',
      'subtitle': 'Register before 30 May',
      'align': 'left',
    },
    {
      'image': 'assets/images/bg.png',
      'title': 'Math Olympiad',
      'subtitle': '3 July 2024 | Open for Classes 6-10',
      'align': 'right',
    },
    {
      'image': 'assets/images/bg.png',
      'title': 'Drawing Competition',
      'subtitle': '28 June 2024 | Register now',
      'align': 'left',
    },
    {
      'image': 'assets/images/bg.png',
      'title': 'Parent-Teacher Meet',
      'subtitle': '5 June 2024 | 10 AM onwards',
      'align': 'right',
    },
    {
      'image': 'assets/images/bg.png',
      'title': 'Science Exhibition',
      'subtitle': '15 July 2024',
      'align': 'left',
    },
  ];

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
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
            // Fixed Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Announcements'),
                        Tab(text: 'Upcoming Events'),
                      ],
                      labelColor: ColorsValue.navIconColor,
                      unselectedLabelColor: ColorsValue.unSelectedClr,
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      indicatorColor: ColorsValue.navIconColor,
                      indicatorWeight: 3,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All →',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ColorsValue.navIconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - Announcements (Events List + E-Learning Hub)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: upcomingEventsList.length,
                          itemBuilder: (context, index) => _buildEventCard(upcomingEventsList[index]),
                        ),
                        const SizedBox(height: 16),
                        // E-Learning Hub in First Tab
                        const ELearningHub(),
                        const SizedBox(height: 10),
                        const Academics(),
                        const SizedBox(height: 10),
                        const Others(),
                      ],
                    ),
                  ),
                  // Second Tab - Upcoming Events (Carousel + E-Learning Hub)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Carousel Slider
                        _buildCarouselSlider(),
                        const SizedBox(height: 16),
                        // E-Learning Hub in Second Tab
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

  Widget _buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider(
          items: carouselAnnouncements.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: item['align'] == 'left'
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              _currentIndex = index;
            },
          ),
          carouselController: _carouselController,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselAnnouncements.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.blue
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (event['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left Vertical Colored Line
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: event['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event['type'],
                        style: TextStyle(
                          color: event['color'],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event['date'],
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['deadline'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
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
    {'icon': AssetConstants.icTask, 'label': 'Daily Time'},
    {'icon': AssetConstants.icLsn, 'label': 'Library Hour'},
    {'icon': AssetConstants.icPc, 'label': 'Online Library'},
    {'icon': AssetConstants.icDown, 'label': 'Downloads'},
    {'icon': AssetConstants.icZoom, 'label': 'School Library'},
    {'icon': AssetConstants.icMeet, 'label': 'Download Library'},
    {'icon': AssetConstants.icClass, 'label': 'Return Library'},
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
              childAspectRatio: 0.7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
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
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Styles.darkBlkW600013,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// E-Learning Hub Widget - 2 Rows with 4 items each (Appears in both tabs)
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
              childAspectRatio: 0.7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
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
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Styles.darkBlkW600013,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
              childAspectRatio: 0.7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                svgIcon: item['icon'] as String,
                label: item['label'] as String,
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
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Styles.darkBlkW600013,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}