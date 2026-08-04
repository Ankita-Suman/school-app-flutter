import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/events_response.dart';
import '../../app.dart';
import 'upcoming_events_controller.dart';

class UpcomingEventsScreen extends StatelessWidget {
  UpcomingEventsScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxList<Event> filteredEventsList = RxList<Event>();


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
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final UpcomingEventsController controller =
        Get.put(UpcomingEventsController(Get.find()));

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Dynamic background height based on screen size
    final backgroundHeight = screenHeight < 700 ? 160.0 : 180.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        // Loading state
        if (controller.isLoadingEvents.value &&
            controller.eventsData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final allEvents = controller.eventsData.value?.data?.events ?? [];

        // Initialize filtered list when data is loaded
        if (filteredEventsList.isEmpty && allEvents.isNotEmpty) {
          filteredEventsList.value = allEvents;
        }

        final events =
            filteredEventsList.isEmpty ? allEvents : filteredEventsList;

        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.priority_high,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No upcoming events found',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // ✅ Responsive SVG Background - Fixed height
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

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Fixed Header Section
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(12),
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
                                Text('Upcoming Events',
                                    style: Styles.whiteBold),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Search Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          height: 45,
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
                              final allEventsList =
                                  controller.eventsData.value?.data?.events ??
                                      [];
                              if (value.isEmpty) {
                                filteredEventsList.value = allEventsList;
                              } else {
                                final filtered = allEventsList.where((event) {
                                  return event.title
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ==
                                          true ||
                                      event.eventType
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ==
                                          true ||
                                      event.description
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ==
                                          true ||
                                      event.location
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ==
                                          true;
                                }).toList();
                                filteredEventsList.value = filtered;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search events...',
                              hintStyle: Styles.darkBlueW500,
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.grey.shade500, size: 18),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                            ),
                            style: Styles.whiteBold14600,
                          ),
                        ),
                      ),

                      // ✅ Fixed spacing
                      const SizedBox(height: 20),
                    ],
                  ),

                  // Events List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
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

  Widget _buildCarouselCard(Event event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorsValue.navBgColors,
        borderRadius: BorderRadius.circular(12),
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
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
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatEventDate(event.eventDate),
                              style: Styles.darkBlcW70010,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                  color: Colors.grey.shade500, width: 1),
                              borderRadius: BorderRadius.circular(12),
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
          ),

          // Title and Subtitle
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? 'Upcoming Event',
                  style: Styles.darkBlkW70014,
                ),
                const SizedBox(height: 4),
                Text(
                  event.description ?? 'Join us for this event',
                  style: Styles.darkGryW40011,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(AssetConstants.icLocations,
                        height: 14, width: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.location ?? 'School Premises',
                        style: Styles.darkBlkW400.copyWith(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
