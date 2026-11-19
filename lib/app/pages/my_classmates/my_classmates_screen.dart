import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/my_classmates_response.dart';
import '../../app.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_classmates_controller.dart';
import 'my_classmates_presenter.dart';

class MyClassmatesScreen extends StatelessWidget {
  const MyClassmatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TeacherHomeUseCases>()) {
      Get.put(TeacherHomeUseCases(Get.find()));
    }

    final MyClassmatesController controller = Get.put(
      MyClassmatesController(
        MyClassmatesPresenter(Get.find<TeacherHomeUseCases>()),
      ),
    );

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
                            child: SvgPicture.asset(AssetConstants.icBackBg),
                          ),
                          const SizedBox(width: 8),
                          // ✅ टाइटल बदलकर My Classmates कर दिया गया है
                          Text('My Classmates', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    if (controller.classmatesList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              'No classmates found',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Classmates List',
                                  style: Styles.darkBlcW700016,
                                ),
                              ),
                              // Dynamic List from API
                              ...controller.classmatesList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                final isLast = index == controller.classmatesList.length - 1;

                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 10,
                                    bottom: isLast ? 16 : 8,
                                  ),
                                  child: _buildClassmateCard(student),
                                );
                              }),
                            ],
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
  Widget _buildClassmateCard(Classmate student) {
    final String baseUrl = 'https://decentgroupofschools.com/';
    String fullImageUrl = student.photo != null && student.photo!.isNotEmpty
        ? '${baseUrl}${student.photo}'
        : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // ========== STUDENT IMAGE / AVATAR ==========
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle, // ✅ गोल आकार
            ),
            clipBehavior: Clip.antiAlias,
            child: fullImageUrl.isNotEmpty
                ? Image.network(
              fullImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(student.fullName),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  ),
                );
              },
            )
                : _buildInitialsAvatar(student.fullName),
          ),
          const SizedBox(width: 16),

          // ========== NAME & ROLL NUMBER ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName ?? 'Unknown Name',
                  style: Styles.darkBlcW60015,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll No: ${student.rollNumber ?? 'N/A'}',
                  style: Styles.darkBlueW400.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          // ✅ यहाँ से Arrow Icon हटा दिया गया है
        ],
      ),
    );
  }

  // ✅ अगर फोटो नहीं है तो नाम के पहले अक्षर दिखाने के लिए
  Widget _buildInitialsAvatar(String? fullName) {
    String initials = 'S';
    if (fullName != null && fullName.isNotEmpty) {
      List<String> parts = fullName.trim().split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}