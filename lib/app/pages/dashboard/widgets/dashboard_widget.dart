// widgets/dashboard_widget.dart
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // ✅ Ticker के लिए
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/domain/models/announcement_model.dart'; // ✅ Announcement type
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

    return Obx(() {
      if (controller.isLoadingHome.value) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 3,
            ),
          ),
        );
      }

      return _ImagePreloader(
        imageUrl: _getFullImageUrl(
            controller.profileData.value?.personal.photo),
        child: _buildMainContent(context, controller, screenWidth),
      );
    });
  }

  static String _getFullImageUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return '';
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return photoUrl;
    }
    return 'https://demo.aitsolutions.in/$photoUrl';
  }

  Widget _buildMainContent(
      BuildContext context,
      DashboardController controller,
      double screenWidth,
      ) {
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
                                Obx(() => Text(
                                  controller.profileData.value?.personal
                                      .name ??
                                      'Olivier Thomas',
                                  style: Styles.whiteBold,
                                )),
                                Obx(() => Text(
                                  'Class ${controller.profileData.value?.personal.classInfo.name ?? '1'} – ${controller.profileData.value?.personal.section.name ?? 'A'}',
                                  style: Styles.whiteW400011,
                                )),
                              ],
                            ),
                          ),
                        ),
                        Obx(() {
                          if (!controller.hasMultipleChildren.value) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.swap_horiz,
                                color: Colors.white,
                                size: 20,
                              ),
                              tooltip: 'Switch Student',
                              onPressed: () {
                                RouteManagement.goToMyChildrenList();
                              },
                            ),
                          );
                        }),
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
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CreditScoreCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
    String? photoUrl = controller.profileData.value?.personal.photo;
    String? fullName = controller.profileData.value?.personal.name;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      String finalUrl = _getFullImageUrl(photoUrl);

      return ClipOval(
        child: Image.network(
          finalUrl,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoaderAvatar();
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar(fullName);
          },
        ),
      );
    }

    return _buildInitialsAvatar(fullName);
  }

  Widget _buildLoaderAvatar() {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: ColorsValue.bgColors,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String? fullName) {
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
          style: Styles.whiteBold.copyWith(fontSize: 18),
        ),
      ),
    );
  }

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'AS';
    List<String> parts = fullName.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    String first = parts[0][0].toUpperCase();
    String last = parts[parts.length - 1][0].toUpperCase();
    return '$first$last';
  }
}

// ============================================================
// ✅ FAST IMAGE PRELOADER
// ============================================================
class _ImagePreloader extends StatefulWidget {
  final String imageUrl;
  final Widget child;

  const _ImagePreloader({
    required this.imageUrl,
    required this.child,
  });

  @override
  State<_ImagePreloader> createState() => _ImagePreloaderState();
}

class _ImagePreloaderState extends State<_ImagePreloader> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _preloadWithTimeout();
  }

  Future<void> _preloadWithTimeout() async {
    if (widget.imageUrl.isEmpty) {
      if (mounted) setState(() => _isReady = true);
      return;
    }
    try {
      await Future.any([
        _loadImage(),
        Future.delayed(const Duration(milliseconds: 1500)),
      ]);
    } catch (e) {
      debugPrint("⚠️ Image preload error: $e");
    }
    if (mounted) setState(() => _isReady = true);
  }

  Future<void> _loadImage() async {
    final completer = Completer<void>();
    final imageProvider = NetworkImage(widget.imageUrl);
    final stream = imageProvider.resolve(ImageConfiguration.empty);

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
          (imageInfo, synchronousCall) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 3,
          ),
        ),
      );
    }
    return widget.child;
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
                Text('STUDENT PR', style: Styles.whiteW70010),
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
                        '${controller.profileData.value?.other.grade.averagePercentage ?? 0}',
                        style: Styles.whiteBold),
                    const SizedBox(width: 5),
                    Text('/100', style: Styles.whiteW4009),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              RouteManagement.goToAttendanceRecord();
            },
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
                      Obx(() => Text(
                        '${controller.profileData.value?.other.attendance.percentage ?? 0}%',
                        style: Styles.whiteBold15,
                      )),
                      Text('Attendance', style: Styles.whiteW400010),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ✅ Announcements Tabs Widget
// ============================================================
class AnnouncementsTabs extends StatelessWidget {
  AnnouncementsTabs({super.key});

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  String _formatTime(DateTime date) {
    int hour = date.hour;
    String amPm = 'AM';
    if (hour >= 12) {
      amPm = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  String _formatEventDate(String? date) {
    if (date == null || date.isEmpty) return 'Event Date';
    try {
      final dt = DateTime.parse(date);
      return '${dt.day} ${_getMonthName(dt.month)}, ${_formatTime(dt)}';
    } catch (e) {
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = int.parse(parts[1]);
        final day = parts[2];
        return '$day ${_getMonthName(month)} $year';
      }
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Builder(
                      builder: (context) {
                        final TabController tabController =
                        DefaultTabController.of(context);
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
                TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      controller.getAnnouncementDetails();
                    } else if (index == 1) {
                      controller.getEventsDetails();
                    }
                  },
                  tabs: const [
                    Tab(text: 'Announcements'),
                    Tab(text: 'Upcoming Events'),
                  ],
                  labelColor: ColorsValue.navIconColor,
                  unselectedLabelColor: ColorsValue.unSelectedClr,
                  indicatorColor: ColorsValue.navIconColor,
                  indicatorWeight: 2,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // ============================================================
                  // ✅ ANNOUNCEMENTS TAB (Max 10 items, no duplicates, smart scroll)
                  // ============================================================
                  Obx(() {
                    if (controller.isLoadingAnnouncements.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      );
                    }

                    // ✅ Frontend sort — latest सबसे ऊपर
                    final raw = controller.announcementData.value?.data ?? [];
                    List<Announcement> sortedList = List<Announcement>.from(raw)
                      ..sort((a, b) =>
                          b.announcementDate.compareTo(a.announcementDate));

                    // ✅ सिर्फ टॉप 10 ही लें, चाहे API से 100 आएं
                    final announcements = sortedList.take(10).toList();

                    if (announcements.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No announcements available"),
                        ),
                      );
                    }

                    final latestId = announcements.first.id;

                    return _AutoScrollingAnnouncements(
                      announcements: announcements,
                      itemBuilder: (item, index) {
                        Color catColor = Colors.blue;
                        IconData catIcon = Icons.campaign;

                        if (item.category == 'URGENT') {
                          catColor = Colors.orange;
                          catIcon = Icons.priority_high;
                        } else if (item.category == 'ACADEMIC') {
                          catColor = Colors.blue;
                          catIcon = Icons.school;
                        } else if (item.category == 'HOLIDAY') {
                          catColor = Colors.green;
                          catIcon = Icons.beach_access;
                        } else if (item.category == 'PTM') {
                          catColor = Colors.red;
                          catIcon = Icons.person;
                        }

                        String formattedDate = "${item.announcementDate.day} ${_getMonthName(item.announcementDate.month)}, ${_formatTime(item.announcementDate)}";

                        final Map<String, dynamic> eventMap = {
                          'type': item.category,
                          'date': formattedDate,
                          'description': item.title,
                          'deadline': item.description,
                          'color': catColor,
                          'icon': catIcon,
                          'isNew': item.id == latestId,
                        };

                        return _buildEventCard(eventMap, index);
                      },
                    );
                  }),

                  // ============================================================
                  // ✅ UPCOMING EVENTS TAB
                  // ============================================================
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() {
                          if (controller.isLoadingEvents.value) {
                            return const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue),
                              ),
                            );
                          }
                          return _buildCarouselSlider(controller);
                        }),
                        const SizedBox(height: 8),
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
    if (events.isEmpty) return const SizedBox.shrink();
    if (_currentIndex >= events.length) _currentIndex = 0;

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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    border: Border.all(
                                        color: Colors.grey.shade500, width: 1),
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
                  color: _currentIndex == entry.key
                      ? Colors.blue
                      : Colors.grey.shade300,
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
    Color getLightShade(Color color) => color.withOpacity(0.10);
    final bool isNew = event['isNew'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            height: 90,
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
            margin: const EdgeInsets.only(left: 12, top: 20),
            decoration: BoxDecoration(
              color: (event['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              event['icon'] ?? Icons.info,
              color: event['color'],
              size: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              event['type'],
                              style: TextStyle(
                                color: event['color'] as Color,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                            if (isNew) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        event['date'],
                        style: Styles.darkBlkW60010,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['description'],
                    style: Styles.darkBlackW700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event['deadline'],
                    style: Styles.darkBlkW400,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// ============================================================
// ✅ SMART AUTO-SCROLLING ANNOUNCEMENTS (No Duplicates, Exact API Length)
// ============================================================
class _AutoScrollingAnnouncements extends StatefulWidget {
  final List<Announcement> announcements;
  final Widget Function(Announcement item, int index) itemBuilder;

  const _AutoScrollingAnnouncements({
    required this.announcements,
    required this.itemBuilder,
  });

  @override
  State<_AutoScrollingAnnouncements> createState() =>
      _AutoScrollingAnnouncementsState();
}

class _AutoScrollingAnnouncementsState
    extends State<_AutoScrollingAnnouncements>
    with SingleTickerProviderStateMixin {
  static const double _itemExtent = 108.0;
  static const double _pixelsPerSecond = 20.0; // स्क्रॉल की स्पीड

  final ScrollController _scrollController = ScrollController();
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  DateTime? _lastInteractionTime;
  bool _isTouching = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isInteractionPaused {
    if (_isTouching) return true;
    if (_lastInteractionTime == null) return false;
    return DateTime.now().difference(_lastInteractionTime!) < const Duration(seconds: 3);
  }

  void _markInteraction() {
    _lastInteractionTime = DateTime.now();
  }

  void _onTick(Duration elapsed) {
    if (!_scrollController.hasClients) {
      _lastElapsed = elapsed;
      return;
    }

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0) return;

    if (_isInteractionPaused) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return; // कुछ स्क्रॉल करने को नहीं है

    final current = _scrollController.offset;

    // ✅ अगर नीचे तक पहुँच गए, तो वापस ऊपर जाएं (जंप)
    if (current >= maxScroll) {
      _scrollController.jumpTo(0);
      return;
    }

    var next = current + (_pixelsPerSecond * dt);
    if (next > maxScroll) next = maxScroll;

    _scrollController.jumpTo(next);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.announcements.isEmpty) return const SizedBox.shrink();

    // ✅ अगर सिर्फ 1 या 2 आइटम हैं, तो स्क्रॉल बंद रखें
    if (widget.announcements.length <= 2) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.announcements.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(widget.announcements[index], index);
        },
      );
    }

    // ✅ 3 या ज्यादा आइटम होने पर स्क्रॉल चालू करें (सिर्फ असली आइटम, कोई डुप्लीकेट नहीं)
    return Listener(
      onPointerDown: (_) {
        _isTouching = true;
        _markInteraction();
      },
      onPointerMove: (_) => _markInteraction(),
      onPointerUp: (_) {
        _isTouching = false;
        _markInteraction();
      },
      onPointerCancel: (_) {
        _isTouching = false;
        _markInteraction();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemExtent: _itemExtent,
        itemCount: widget.announcements.length, // ✅ सिर्फ API से आए हुए आइटम
        itemBuilder: (context, index) {
          return widget.itemBuilder(widget.announcements[index], index);
        },
      ),
    );
  }
}

class DynamicProgressBar extends StatelessWidget {
  final double percentage;
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
        alignment: Alignment.centerLeft,
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