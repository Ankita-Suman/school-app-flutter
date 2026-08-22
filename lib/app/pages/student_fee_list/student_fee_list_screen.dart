// student_fee_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/student_fee_status_response.dart';
import '../../app.dart';
import 'student_fee_list_controller.dart';

class StudentFeeListScreen extends StatefulWidget {
  const StudentFeeListScreen({super.key});

  @override
  State<StudentFeeListScreen> createState() => _StudentFeeListScreenState();
}

class _StudentFeeListScreenState extends State<StudentFeeListScreen> {
  late final StudentFeeListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StudentFeeListController(Get.find()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                // ===== HEADER with Filter on Right =====
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
                          Text('Student Fee List', style: Styles.whiteBold),
                        ],
                      ),
                      // Filter dropdown on the right side
                      _buildFilterDropdown(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Main content
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.filteredStudents;
                    final summary = controller.summary;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== SELECT CRITERIA CARD =====
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                                Text('Select Criteria',
                                    style: Styles.darkBlcW60015),
                                const SizedBox(height: 12),

                                // Row: Class & Section
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Class',
                                        value: controller.selectedClassName.value,
                                        items: controller.termClasses
                                            .map((c) => c.name)
                                            .toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            final classItem = controller
                                                .termClasses
                                                .firstWhere(
                                                  (c) => c.name == newValue,
                                              orElse: () =>
                                              controller.termClasses.first,
                                            );
                                            controller.onClassChanged(classItem.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Section',
                                        value: controller.selectedSectionName.value,
                                        items: controller.termSections
                                            .map((s) => s.name)
                                            .toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            final section = controller
                                                .termSections
                                                .firstWhere(
                                                  (s) => s.name == newValue,
                                              orElse: () =>
                                              controller.termSections.first,
                                            );
                                            controller.onSectionChanged(section.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ===== FEE LIST HEADER (no filter here) =====
                          if (summary != null && students.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Student Fee List',
                                  style: Styles.darkBlcW70014,
                                ),
                                Text(
                                  'Total: ${summary.total}',
                                  style: Styles.skyBlueW60012,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ===== FEE LIST =====
                          if (students.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  'No fee data found for the selected criteria.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                return _buildFeeCard(student);
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

  // ========== FILTER DROPDOWN (Square box, right side in header) ==========
  Widget _buildFilterDropdown() {
    return Obx(() {
      final currentFilter = controller.selectedFilter.value;
      return PopupMenuButton<String>(
        offset: const Offset(0, 30),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 4,
        onSelected: (value) => controller.setFilter(value),
        itemBuilder: (context) => [
          'All',
          'Paid',
          'Pending',
          'Partial',
        ].map((filter) => PopupMenuItem<String>(
          value: filter,
          height: 40,
          child: Text(
            filter,
            style: Styles.darkBlcW600.copyWith(
              fontSize: 13,
              color: currentFilter == filter ? Colors.blue.shade700 : Colors.black87,
            ),
          ),
        )).toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(4),
           // border: Border.all(color: Colors.grey.shade600, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentFilter,
                style: Styles.darkBlcW600.copyWith(fontSize: 12),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  // ========== DROPDOWN FIELD (unchanged) ==========
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.darkBlueW40010),
        const SizedBox(height: 4),
        Builder(
          builder: (btnContext) {
            return GestureDetector(
              onTap: () {
                if (items.isEmpty) return;

                final RenderBox renderBox =
                btnContext.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero);
                final Size size = renderBox.size;

                showMenu<String>(
                  context: btnContext,
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + size.height,
                    offset.dx + size.width,
                    offset.dy + size.height + 100,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 4,
                  constraints: BoxConstraints(
                    minWidth: size.width,
                    maxWidth: size.width,
                  ),
                  items: _buildGenericMenuItems(items),
                ).then((newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                });
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value.isNotEmpty ? value : '--',
                        style: value.isNotEmpty
                            ? Styles.darkBlcW600.copyWith(fontSize: 12)
                            : const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ========== GENERIC MENU ITEMS WITH DIVIDER ==========
  List<PopupMenuEntry<String>> _buildGenericMenuItems(List<String> items) {
    final List<PopupMenuEntry<String>> menuItems = [];

    for (int i = 0; i < items.length; i++) {
      menuItems.add(
        PopupMenuItem<String>(
          value: items[i],
          height: 40,
          child: SizedBox(
            width: 220,
            child: Text(
              items[i],
              style: Styles.darkBlcW600.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      if (i != items.length - 1) {
        menuItems.add(const PopupMenuDivider(height: 1));
      }
    }

    return menuItems;
  }

  // ========== FEE CARD (unchanged) ==========
  Widget _buildFeeCard(StudentFeeStudent student) {
    final status = student.status;
    final amount = student.netAmount;
    final paid = student.paidAmount;
    final pending = student.pendingAmount;

    Color statusColor;
    IconData statusIcon;
    switch (status.toUpperCase()) {
      case 'PAID':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'PARTIAL':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
    }

    final name = student.fullName;
    final roll = student.rollNumber;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    final colors = [Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.red, Colors.teal, Colors.pink, Colors.indigo];
    final avatarColor = colors[initial.codeUnitAt(0) % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: avatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Styles.darkBlcW70013),
                    Text('Roll: $roll', style: Styles.darkBlueW400),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200, height: 1, thickness: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.toUpperCase() == 'PAID' ? 'Amount Paid' : (status.toUpperCase() == 'UNPAID' ? 'Total Dues' : 'Amount Paid'),
                style: Styles.darkBlueW40010,
              ),
              Text(
                status.toUpperCase() == 'PAID' ? '₹$amount' : (status.toUpperCase() == 'UNPAID' ? '₹$amount' : '₹$paid'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (status.toUpperCase() == 'PARTIAL' || status.toUpperCase() == 'UNPAID') ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Amount',
                  style: Styles.darkBlueW40010,
                ),
                Text(
                  '₹$pending',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}