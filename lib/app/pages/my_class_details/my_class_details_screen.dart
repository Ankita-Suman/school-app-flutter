import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import 'my_class_details_controller.dart';

class MyClassDetailsScreen extends StatelessWidget {
  MyClassDetailsScreen({super.key});

  final MyClassDetailsController controller =
      Get.put(MyClassDetailsController(Get.find()));

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                          Obx(() => Text(
                                controller.fullClassName.isNotEmpty
                                    ? 'My Class (${controller.fullClassName})'
                                    : 'My Class',
                                style: Styles.whiteBold,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.classDetailsData.value == null ||
                        controller.classDetailsData.value?.data == null) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Data Available',
                                style: Styles.darkBlcW70016,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Unable to load class details.',
                                style: Styles.darkBlueW400,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final data = controller.classDetailsData.value!.data!;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========== CONTAINER 1: TODAY'S TIMETABLE ==========
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.icTable,
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Today's Timetable",
                                        style: Styles.darkBlcW700,
                                      ),
                                    ],
                                  ),
                                ),
                                // ✅ Timetable with static times
                                if (controller.timetableWithTimes.isNotEmpty)
                                  ...controller.timetableWithTimes
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    final isLast = index ==
                                        controller.timetableWithTimes.length -
                                            1;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: isLast ? 16 : 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Time
                                              SizedBox(
                                                width: 70,
                                                child: Text(
                                                  item['time'] ?? '',
                                                  style: Styles.darkBlackW60012,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Subject Details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['subject'] ?? 'Free',
                                                      style: item['subject'] ==
                                                              'Free'
                                                          ? Styles.darkBlueW400
                                                          : Styles
                                                              .darkBlcW70014,
                                                    ),
                                                    if (item['teacher']
                                                            ?.isNotEmpty ??
                                                        false)
                                                      const SizedBox(height: 2),
                                                    if (item['teacher']
                                                            ?.isNotEmpty ??
                                                        false)
                                                      Text(
                                                        item['teacher'] ?? '',
                                                        style:
                                                            Styles.darkBlueW400,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!isLast)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Divider(
                                                color: Colors.grey.shade200,
                                                height: 1,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })
                                else
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'No timetable available',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ========== CONTAINER 2: SUBJECT ALLOCATION ==========
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.tHome,
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Subject Allocation',
                                        style: Styles.darkBlcW700,
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.subjectAllocationList.isNotEmpty)
                                  ...controller.subjectAllocationList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final subject = entry.value;
                                    final isLast = index ==
                                        controller
                                                .subjectAllocationList.length -
                                            1;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: isLast ? 16 : 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subject.subject,
                                            style: Styles.darkBlcW70014,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Teacher: ${subject.teacherName}',
                                            style: Styles.darkBlueW400,
                                          ),
                                          if (subject.subjectCode != null &&
                                              subject.subjectCode!.isNotEmpty)
                                            Text(
                                              'Code: ${subject.subjectCode}',
                                              style: Styles.darkBlueW400,
                                            ),
                                          if (!isLast)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Divider(
                                                color: Colors.grey.shade200,
                                                height: 1,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })
                                else
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'No subjects allocated',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ========== CONTAINER 3: CLASS STRENGTH ==========
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.tStudent,
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Class Strength',
                                        style: Styles.darkBlcW700,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${controller.totalStudents}',
                                        style: Styles.darkBlcW80032,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total Students',
                                        style: Styles.darkBlackW60012,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          decoration: BoxDecoration(
                                            color: ColorsValue.cardBorderSkyClr,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.blue.shade100,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${controller.boysCount}',
                                                style: Styles.skyBlueW70020,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Boys',
                                                style: Styles.darkBlueW400,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          decoration: BoxDecoration(
                                            color: ColorsValue.cardBorderSkyClr,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.blue.shade100,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${controller.girlsCount}',
                                                style: Styles.skyBlueW70020,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Girls',
                                                style: Styles.darkBlueW400,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
