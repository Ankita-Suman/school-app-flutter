import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class NoticeBoardScreen extends StatelessWidget {
  NoticeBoardScreen({super.key});

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
    {
      'type': 'WORKSHOP',
      'date': '15 Jul',
      'description': 'AI & Robotics Workshop on 15 July 2024',
      'deadline': 'Limited seats. Register before 10 July.',
      'color': Colors.purple,
    },
    {
      'type': 'SPORTS',
      'date': '20 Aug',
      'description': 'Annual Sports Day on 20 August 2024',
      'deadline': 'Register your name by 15 August.',
      'color': Colors.red,
    },
  ];

  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> filteredEventsList = RxList<Map<String, dynamic>>();

  @override
  Widget build(BuildContext context) {
    // Initialize filtered list
    filteredEventsList.value = upcomingEventsList;

    return Scaffold(
      body: Stack(
        children: [
          // SVG Background with full width and static height
          SizedBox(
            width: double.infinity,
            height: 150,
            child: SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: double.infinity,
              height: 150,
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
                    const SizedBox(height: 25),

                    // Header Section
                    Padding(
                      padding: const EdgeInsets.all(16),
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
                              Text('Notice Board', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Search Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            filteredEventsList.value = upcomingEventsList;
                          } else {
                            filteredEventsList.value = upcomingEventsList.where((event) {
                              return event['type'].toString().toLowerCase().contains(value.toLowerCase()) ||
                                  event['description'].toString().toLowerCase().contains(value.toLowerCase()) ||
                                  event['deadline'].toString().toLowerCase().contains(value.toLowerCase());
                            }).toList();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search notices...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                  ],
                ),


                // Notice List
                Expanded(
                  child: Obx(
                        () => filteredEventsList.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notices found',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEventsList.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(filteredEventsList[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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