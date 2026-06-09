import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../domain/models/events_response.dart';
import '../../app.dart';
import 'upcoming_events_controller.dart';

class UpcomingEventsScreen extends StatelessWidget {
  UpcomingEventsScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxList<Event> filteredEventsList = RxList<Event>();

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
    final UpcomingEventsController controller = Get.put(UpcomingEventsController(Get.find()));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        // Loading state
        if (controller.isLoadingEvents.value && controller.eventsData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final allEvents = controller.eventsData.value?.data?.events ?? [];

        // Initialize filtered list when data is loaded
        if (filteredEventsList.isEmpty && allEvents.isNotEmpty) {
          filteredEventsList.value = allEvents;
        }

        final events = filteredEventsList.isEmpty ? allEvents : filteredEventsList;

        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.priority_high, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No upcoming events found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // SVG Background
            SizedBox(
              width: double.infinity,
              height: 170,
              child: SvgPicture.asset(
                AssetConstants.icBlueBg,
                width: double.infinity,
                height: 170,
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
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: SvgPicture.asset(AssetConstants.icBackBg),
                                ),
                                const SizedBox(width: 8),
                                Text('Upcoming Events', style: Styles.whiteBold),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Search Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              final allEventsList = controller.eventsData.value?.data?.events ?? [];
                              if (value.isEmpty) {
                                // Show all events when search is empty
                                filteredEventsList.value = allEventsList;
                              } else {
                                // Filter events by title (case insensitive)
                                final filtered = allEventsList.where((event) {
                                  return event.title?.toLowerCase().contains(value.toLowerCase()) == true ||
                                      event.eventType?.toLowerCase().contains(value.toLowerCase()) == true ||
                                      event.description?.toLowerCase().contains(value.toLowerCase()) == true ||
                                      event.location?.toLowerCase().contains(value.toLowerCase()) == true;
                                }).toList();
                                filteredEventsList.value = filtered;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search events...',
                              hintStyle: Styles.darkBlueW500,
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            ),
                            style: Styles.whiteBold14600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),

                  // Events List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return _buildCarouselCard(events[index], index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Same UI as your _buildCarouselSlider - just data set from API
  Widget _buildCarouselCard(Event event, int index) {
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
          // Carousel Image Container
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            height: 200,
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
                        // Left Container - Date from API
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
                        // Right Container - Event Type from API
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
          ),

          // Title and Subtitle from API
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? 'Upcoming Event',
                  style: Styles.darkBlkW70014,
                ),
                const SizedBox(height: 3),
                Text(
                  event.description ?? 'Join us for this event',
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
                      event.location ?? 'School Premises',
                      style: Styles.darkBlkW400,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}