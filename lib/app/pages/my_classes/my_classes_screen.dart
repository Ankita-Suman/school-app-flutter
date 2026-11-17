import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/my_classes_response.dart';
import '../../app.dart';
import 'my_classes_controller.dart';

class MyClassesScreen extends StatefulWidget {
  const MyClassesScreen({super.key});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  // Get controller
  late final MyClassesController controller;

  // Search controller
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  // Color palette for class cards (Keeping it in case you need it later)
  final List<Color> colorPalette = [
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

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyClassesController(Get.find()));

    // Add listener to search controller
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase().trim();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Get color based on index
  Color getColorForIndex(int index) {
    return colorPalette[index % colorPalette.length];
  }

  // ========== GET FILTERED CLASS LIST ==========
  List<ClassItem> get filteredClasses {
    final allClasses = controller.classList;
    if (allClasses == null || allClasses.isEmpty) return [];

    if (searchQuery.value.isEmpty) return allClasses;

    return allClasses.where((classItem) {
      final className = classItem.className.toLowerCase();
      final sectionName = classItem.sectionName.toLowerCase();
      final fullName = '$className ${classItem.sectionName}'.toLowerCase();
      final query = searchQuery.value;

      return className.contains(query) ||
          sectionName.contains(query) ||
          fullName.contains(query);
    }).toList();
  }

  // ========== NAVIGATE TO CLASS DETAILS ==========
  void navigateToClassDetails(ClassItem classItem) {
    // Get class ID and section ID
    final String classId = classItem.classId;
    final String sectionId = classItem.sectionId;

    // Navigate to class details screen with required data
    RouteManagement.goToMyClassDetails(
      classId: classId,
      sectionId: sectionId,
    );
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
          // ========== HEADER BACKGROUND ==========
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

          // ========== MAIN CONTENT ==========
          SafeArea(
            child: Column(
              children: [
                // ========== HEADER ==========
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
                          Text('My Classes', style: Styles.whiteBold),
                        ],
                      ),
                      // Show total classes count
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.totalClasses} Classes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== SEARCH BAR ==========
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search class...',
                                    hintStyle: Styles.darkBlcGryW400,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 4,
                                    ),
                                    suffixIcon: Obx(
                                          () => searchQuery.value.isNotEmpty
                                          ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.grey.shade400,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          searchQuery.value = '';
                                        },
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========== CLASS LIST ==========
                        Obx(() {
                          // Show loading indicator
                          if (controller.isLoadingData) {
                            return SizedBox(
                              width: double.infinity,
                              height: screenHeight * 0.5,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          // Show no data message
                          if (!controller.hasData) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Classes Assigned',
                                    style: Styles.darkBlcW70016,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'You are not assigned to any class yet.',
                                    style: Styles.darkBlueW400,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          // Get filtered list
                          final filteredList = filteredClasses;

                          // Show no search results
                          if (filteredList.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Results Found',
                                    style: Styles.darkBlcW70016,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try adjusting your search terms.',
                                    style: Styles.darkBlueW400,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show filtered class list
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final classItem = filteredList[index];
                              return _buildClassCard(
                                classItem: classItem,
                                onTap: () => navigateToClassDetails(classItem),
                              );
                            },
                          );
                        }),

                        const SizedBox(height: 20),
                      ],
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

  // ========== BUILD CLASS CARD ==========
  Widget _buildClassCard({
    required ClassItem classItem,
    required VoidCallback onTap,
  }) {
    // ✅ Student Count सेट किया गया है
    String studentCount = '${classItem.totalStudentCount} Students';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ========== CLASS DETAILS ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ RichText का इस्तेमाल करके Class और Section का रंग अलग किया गया है
                  RichText(
                    text: TextSpan(
                      text: classItem.className, // जैसे: Grade V
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade800, // Class Name का Color (Blue)
                        fontFamily: 'Inter', // आपके ऐप का डिफ़ॉल्ट फ़ॉन्ट (ज़रूरत हो तो बदलें)
                      ),
                      children: [
                        if (classItem.sectionName.isNotEmpty)
                          TextSpan(
                            text: ' - ${classItem.sectionName}', // जैसे: - Heven
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black, // Section Name का Color (Black)
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // ✅ सिर्फ Student Count दिखेगा
                  Text(
                    studentCount,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ========== ARROW ICON ==========
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}