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
      'type': 'PTM',
      'date': '20 Aug',
      'description': 'Parent–Teacher Meeting — 14 May',
      'deadline': 'Book your slot on portal from 1 Apr.',
      'color': Colors.red,
    },
  ];

  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> filteredEventsList = RxList<Map<String, dynamic>>();

  @override
  Widget build(BuildContext context) {
    filteredEventsList.value = upcomingEventsList;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
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
                    // Header Section
                    SizedBox(height:15),
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
                            hintStyle: Styles.darkBlueW500,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          ),
                          style: Styles.whiteBold14600
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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
                            Icons.priority_high,
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
                        return _buildEventCard(filteredEventsList[index],index);
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