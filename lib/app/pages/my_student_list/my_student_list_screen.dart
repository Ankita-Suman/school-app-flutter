import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/student_list_response.dart';
import '../../app.dart';
import '../../navigators/routes_management.dart';
import 'my_student_list_controller.dart';

class MyStudentListScreen extends StatefulWidget {
  const MyStudentListScreen({super.key});

  @override
  State<MyStudentListScreen> createState() => _MyStudentListScreenState();
}

class _MyStudentListScreenState extends State<MyStudentListScreen> {
  // ========== CONTROLLER ==========
  late final MyStudentListController controller;

  // ========== SEARCH CONTROLLER ==========
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyStudentListController(Get.find()));

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                            'Student List (${controller.totalStudents})',
                            style: Styles.whiteBold,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!controller.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Students Found',
                              style: Styles.darkBlcW70016,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No students enrolled in this class',
                              style: Styles.darkBlueW400,
                            ),
                          ],
                        ),
                      );
                    }

                    final allStudents = controller.students ?? [];
                    final filteredStudents = allStudents.where((student) {
                      final query = searchQuery.value.toLowerCase().trim();
                      if (query.isEmpty) return true;
                      return student.studentName.toLowerCase().contains(query) ||
                          student.rollNumber.contains(query);
                    }).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by name or roll no...',
                                hintStyle: Styles.darkBlcGryW400,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                suffixIcon: Obx(() {
                                  if (searchQuery.value.isNotEmpty) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey.shade400,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        searchController.clear();
                                        searchQuery.value = '';
                                      },
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            '${filteredStudents.length} students found',
                            style: Styles.darkBlueW400,
                          ),

                          const SizedBox(height: 12),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              return _buildStudentCard(
                                student: student,
                                index: index,
                              );
                            },
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

  // ========== BUILD STUDENT CARD ==========
  Widget _buildStudentCard({
    required StudentInfi student,
    required int index,
  }) {
    final Color color = _getColorForStudent(index);

    return GestureDetector(
      onTap: () {
        // ✅ Student ID pass karo
        RouteManagement.goToStudentProfile(
          studentId: student.studentId,  // ✅ Student ID pass
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // ========== AVATAR ==========
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  student.studentName.isNotEmpty
                      ? student.studentName[0].toUpperCase()
                      : 'S',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ========== STUDENT DETAILS ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: Styles.darkBlcW70014,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Roll No. ${student.rollNumber}',
                    style: Styles.darkBlueW400,
                  ),
                ],
              ),
            ),

            // ========== ARROW ICON ==========
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ========== GET COLOR FOR STUDENT ==========
  Color _getColorForStudent(int index) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}