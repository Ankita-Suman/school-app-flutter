// pages/login/my_children_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../dashboard/dashboard_controller.dart';
import 'my_children_list_controller.dart';

class MyChildrenListScreen extends StatefulWidget {
  const MyChildrenListScreen({super.key});

  @override
  State<MyChildrenListScreen> createState() => _MyChildrenListScreenState();
}

class _MyChildrenListScreenState extends State<MyChildrenListScreen> {
  late final MyChildrenListController controller;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<MyChildrenListController>()) {
      controller = Get.find<MyChildrenListController>();
    } else {
      controller = Get.put(MyChildrenListController());
    }
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
                          Obx(() => Text(
                            'My Children (${controller.totalChildren})',
                            style: Styles.whiteBold,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ========== CHILDREN LIST ==========
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
                              'No Children Found',
                              style: Styles.darkBlcW70016,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No children linked to this account',
                              style: Styles.darkBlueW400,
                            ),
                          ],
                        ),
                      );
                    }

                    final allChildren = controller.childrenList;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemCount: allChildren.length,
                      itemBuilder: (context, index) {
                        final child = allChildren[index];
                        return _buildChildCard(
                          child: child,
                          index: index,
                        );
                      },
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

  // ========== BUILD CHILD CARD ==========
  Widget _buildChildCard({
    required ChildData child,
    required int index,
  }) {
    final Color color = _getColorForStudent(index);

    return GestureDetector(
      onTap: () => _onChildSelected(child),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
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
              child: ClipOval(
                child: child.hasPhoto
                    ? Image.network(
                  child.photo!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitials(child.name, color);
                  },
                )
                    : _buildInitials(child.name, color),
              ),
            ),
            const SizedBox(width: 12),

            // ========== CHILD DETAILS ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name.isNotEmpty ? child.name : 'Student',
                    style: Styles.darkBlcW70014,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    child.fullClassName.isNotEmpty
                        ? '${child.fullClassName} • Roll No. ${child.rollNumber}'
                        : 'Roll No. ${child.rollNumber}',
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

  // ================================================================
  // ✅ CHILD SELECTED — Switch student + go back to home
  // ================================================================
  void _onChildSelected(ChildData child) {
    debugPrint("👶 Child selected: ${child.name} (ID: ${child.id})");

    // Dashboard controller dhundho aur us child ka data load karo
    if (Get.isRegistered<DashboardController>()) {
      final dashboardController = Get.find<DashboardController>();
      dashboardController.switchStudent(child.id);
      debugPrint("✅ Called switchStudent with ID: ${child.id}");
    } else {
      debugPrint("❌ DashboardController not registered!");
    }

    // Home screen pe wapas jao
    Get.back();
  }

  // ========== INITIALS AVATAR ==========
  Widget _buildInitials(String name, Color color) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
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