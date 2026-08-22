import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/class_attendance_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'mark_attendance_controller.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late final MarkAttendanceController controller;

  // Helper to display status (convert "HALF_DAY" to "HALF DAY")
  String _displayStatus(String status) {
    if (status.toUpperCase() == 'HALF_DAY') return 'HALF DAY';
    return status.toUpperCase();
  }

  List<String> get statusOptions {
    final students = controller.attendanceStudents;
    if (students != null && students.isNotEmpty) {
      final statuses = students.first.attendanceStatuses;
      if (statuses.isNotEmpty) {
        var unique = statuses.map((s) => s.toUpperCase()).toSet().toList();
        unique = unique.map((s) => _displayStatus(s)).toSet().toList();
        unique.sort((a, b) =>
        a == 'PRESENT' ? -1 : (b == 'PRESENT' ? 1 : a.compareTo(b)));
        return unique;
      }
    }
    return ['PRESENT', 'ABSENT', 'LATE', 'HALF DAY', 'LEAVE'];
  }

  String get currentDate {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(MarkAttendanceController(Get.find()));
    ever(controller.classAttendanceData, (_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getStatusColor(String status) {
    final display = _displayStatus(status);
    switch (display) {
      case 'PRESENT':
        return Colors.green;
      case 'LATE':
        return Colors.orange;
      case 'ABSENT':
        return Colors.red;
      case 'HALF DAY':
        return Colors.purple;
      case 'LEAVE':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    final display = _displayStatus(status);
    switch (display) {
      case 'PRESENT':
        return Colors.green.shade50;
      case 'LATE':
        return Colors.orange.shade50;
      case 'ABSENT':
        return Colors.red.shade50;
      case 'HALF DAY':
        return Colors.purple.shade50;
      case 'LEAVE':
        return Colors.blue.shade50;
      default:
        return Colors.transparent;
    }
  }

  void _updateAttendance(int index, String status) {
    final students = controller.attendanceStudents;
    if (students == null || index >= students.length) return;

    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked. Cannot change.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    setState(() {
      students[index].currentStatus = _displayStatus(status);
    });
  }

  void _showNoteDialog(int index, String currentNote) {
    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked. Cannot add note.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    final TextEditingController noteController =
    TextEditingController(text: currentNote);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Note', style: Styles.darkBlcW700),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter note...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text('Cancel',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final students = controller.attendanceStudents;
                      if (students != null && index < students.length) {
                        students[index].remarks = noteController.text.trim();
                      }
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    final students = controller.attendanceStudents;
    if (students == null || students.isEmpty) return;

    final statusCounts = controller.getStatusCounts();
    if (statusCounts.isEmpty) {
      Get.snackbar('Info', 'No status selected. Please mark at least one student.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Attendance',
                style: Styles.darkBlcW700.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Students: ${students.length}',
                style: Styles.darkBlueW400,
              ),
              const SizedBox(height: 16),
              ...statusCounts.entries.map((entry) {
                final displayStatus = _displayStatus(entry.key);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(displayStatus),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            displayStatus,
                            style: Styles.darkBlcW600,
                          ),
                        ],
                      ),
                      Text(
                        '${entry.value}',
                        style: Styles.darkBlcW600,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        controller.revertChanges();
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.saveAttendance();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _loadMore() {
    if (controller.hasMorePages && !controller.isLoadingMoreData) {
      controller.loadMoreData();
    }
  }

  // ========== BUILD CLASS MENU ITEMS ==========
  List<PopupMenuEntry<String>> _buildClassMenuItems(List<dynamic> classes) {
    final List<PopupMenuEntry<String>> items = [];

    for (int i = 0; i < classes.length; i++) {
      final classItem = classes[i];
      items.add(
        PopupMenuItem<String>(
          value: classItem.classId,
          height: 40,
          child: SizedBox(
            width: 220,
            child: Text(
              classItem.className,
              style: Styles.darkBlcW600.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      if (i != classes.length - 1) {
        items.add(const PopupMenuDivider(height: 1));
      }
    }

    return items;
  }

  // ========== BUILD SECTION MENU ITEMS ==========
  List<PopupMenuEntry<String>> _buildSectionMenuItems(List<dynamic> sections) {
    final List<PopupMenuEntry<String>> items = [];

    for (int i = 0; i < sections.length; i++) {
      final item = sections[i];
      items.add(
        PopupMenuItem<String>(
          value: item.sectionId,
          height: 40,
          child: Text(
            item.sectionName,
            style: Styles.darkBlcW600.copyWith(fontSize: 13),
          ),
        ),
      );

      if (i != sections.length - 1) {
        items.add(const PopupMenuDivider(height: 1));
      }
    }

    return items;
  }

// ========== CLASS DROPDOWN (reactive with Obx) ==========
  Widget _buildClassDropdown() {
    return Obx(() {
      final allClasses = controller.uniqueClassList;
      if (allClasses == null || allClasses.isEmpty) {
        return Container(
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
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        );
      }

      final selectedId = controller.selectedClassId.value;
      final selectedClass = allClasses.firstWhere(
            (c) => c.classId == selectedId,
        orElse: () => allClasses.first,
      );

      return Builder(
        builder: (btnContext) {
          return GestureDetector(
            onTap: () {
              final currentClasses = controller.uniqueClassList;
              if (currentClasses == null || currentClasses.isEmpty) return;

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
                items: _buildClassMenuItems(currentClasses),
              ).then((newValue) {
                if (newValue != null) {
                  controller.onClassSelected(newValue);
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
                      selectedClass.className,
                      style: Styles.darkBlcW600.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      );
    });
  }

// ========== SECTION DROPDOWN (reactive with Obx) ==========
  Widget _buildSectionDropdown() {
    return Obx(() {
      final latestSections =
          controller.classGroups[controller.selectedClassId.value] ?? [];
      if (latestSections.isEmpty) {
        return Container(
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
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        );
      }

      final selectedId = controller.selectedSectionId.value;
      String displayName = '--';
      try {
        final selectedItem = latestSections.firstWhere(
              (item) => item.sectionId == selectedId,
          orElse: () => latestSections.first,
        );
        displayName = selectedItem.sectionName;
      } catch (_) {
        displayName = latestSections.first.sectionName;
      }

      return Builder(
        builder: (btnContext) {
          return GestureDetector(
            onTap: () {
              final currentSections =
                  controller.classGroups[controller.selectedClassId.value] ?? [];
              if (currentSections.isEmpty) return;

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
                items: _buildSectionMenuItems(currentSections),
              ).then((newId) {
                if (newId != null) {
                  controller.onSectionSelected(newId);
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
                      displayName,
                      style: Styles.darkBlcW600.copyWith(fontSize: 12),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                // Header
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
                          Text('Mark Attendance', style: Styles.whiteBold),
                        ],
                      ),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.totalStudentCount} Students',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Top Row: Date + Class + Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date',
                                  style: Styles.darkBlueW400
                                      .copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              Container(
                                height: 40,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
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
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    currentDate,
                                    style: Styles.darkBlcW600
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Class
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Class',
                                  style: Styles.darkBlueW400
                                      .copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              _buildClassDropdown(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Section',
                                  style: Styles.darkBlueW400
                                      .copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              _buildSectionDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Student List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingData ||
                        controller.isLoading.value ||
                        controller.isFirstLoad) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.attendanceStudents;
                    if (students == null || students.isEmpty) {
                      return const Center(
                        child: Text(
                          'No students found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Header row
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          color: Colors.grey.shade100,
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 40,
                                  child: Text('Roll',
                                      style: Styles.darkBlackW60012)),
                              Expanded(
                                  flex: 3,
                                  child: Text('Student Name',
                                      style: Styles.darkBlackW60012)),
                              Expanded(
                                  flex: 2,
                                  child: Text('Status',
                                      style: Styles.darkBlackW60012)),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('Note',
                                      style: Styles.darkBlackW60012),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade300),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scroll) {
                              if (scroll.metrics.pixels ==
                                  scroll.metrics.maxScrollExtent &&
                                  controller.hasMorePages &&
                                  !controller.isLoadingMoreData) {
                                _loadMore();
                              }
                              return false;
                            },
                            child: ListView.builder(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: students.length +
                                  (controller.hasMorePages ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == students.length &&
                                    controller.hasMorePages) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2)),
                                  );
                                }
                                final student = students[index];
                                return Column(
                                  children: [
                                    _buildStudentRow(
                                        student: student, index: index),
                                    if (index < students.length - 1)
                                      Divider(
                                          height: 1,
                                          color: Colors.grey.shade200),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                // Save Button
                Obx(() {
                  if (controller.isLoadingData || controller.isLoading.value) {
                    return const SizedBox.shrink();
                  }
                  final students = controller.attendanceStudents;
                  if (students == null || students.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final bool alreadyMarked =
                      controller.isAttendanceAlreadyMarked.value;

                  String buttonText;
                  VoidCallback? onPressed;

                  if (alreadyMarked) {
                    buttonText = 'Already Marked ✓';
                    onPressed = null;
                  } else {
                    buttonText = 'Save Attendance';
                    onPressed = _showConfirmationDialog;
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, -4))
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Opacity(
                        opacity: alreadyMarked ? 0.5 : 1.0,
                        child: GradientButton(
                          onPressed: onPressed ?? () {},
                          text: buttonText,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== STUDENT ROW ==========
  Widget _buildStudentRow(
      {required AttendanceStudent student, required int index}) {
    final options = statusOptions;
    final bool alreadyMarked = controller.isAttendanceAlreadyMarked.value;

    final String? selectedStatus = student.currentStatus != null
        ? _displayStatus(student.currentStatus!)
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: Text(student.rollNumber, style: Styles.darkBlcW60013),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.studentName, style: Styles.darkBlcW60013),
                Text('Reg: ${student.registrationNumber}',
                    style: Styles.darkBlueW40010),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: selectedStatus != null
                    ? _getStatusBgColor(selectedStatus)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selectedStatus != null
                      ? _getStatusColor(selectedStatus)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  hint: Text('Select',
                      style: Styles.darkBlcW600.copyWith(
                          fontSize: 11, color: Colors.grey.shade600)),
                  isExpanded: true,
                  isDense: true,
                  icon: const SizedBox.shrink(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.sora().fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selectedStatus != null
                        ? _getStatusColor(selectedStatus)
                        : Colors.grey.shade600,
                  ),
                  onChanged: alreadyMarked
                      ? null
                      : (newValue) {
                    if (newValue != null) {
                      _updateAttendance(index, newValue);
                    }
                  },
                  items: options.map((status) {
                    final displayStatus = _displayStatus(status);
                    return DropdownMenuItem<String>(
                      value: displayStatus,
                      child: Center(
                        child: Text(
                          displayStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.sora().fontFamily,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: displayStatus == selectedStatus
                                ? _getStatusColor(displayStatus)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: alreadyMarked
                  ? null
                  : () => _showNoteDialog(index, student.remarks ?? ''),
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: alreadyMarked ? 0.5 : 1.0,
                  child: Icon(Icons.note_alt_outlined,
                      size: 22, color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}