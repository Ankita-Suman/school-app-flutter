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

  bool _hasAttendanceChanged = false;

  List<String> get statusOptions {
    final students = controller.attendanceStudents;
    if (students != null && students.isNotEmpty) {
      final statuses = students.first.attendanceStatuses;
      if (statuses.isNotEmpty) {
        final unique = statuses.map((s) => s.toUpperCase()).toSet().toList();
        unique.sort((a, b) => a == 'PRESENT' ? -1 : (b == 'PRESENT' ? 1 : a.compareTo(b)));
        return unique;
      }
    }
    return ['PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'LEAVE'];
  }

  String get currentDate {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(MarkAttendanceController(Get.find()));
    ever(controller.classAttendanceData, (_) {
      setState(() => _hasAttendanceChanged = false);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT': return Colors.green;
      case 'LATE': return Colors.orange;
      case 'ABSENT': return Colors.red;
      case 'HALF_DAY': return Colors.purple;
      case 'LEAVE': return Colors.blue;
      default: return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT': return Colors.green.shade50;
      case 'LATE': return Colors.orange.shade50;
      case 'ABSENT': return Colors.red.shade50;
      case 'HALF_DAY': return Colors.purple.shade50;
      case 'LEAVE': return Colors.blue.shade50;
      default: return Colors.white;
    }
  }

  void _updateAttendance(int index, String status) {
    final students = controller.attendanceStudents;
    if (students == null || index >= students.length) return;

    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked. Cannot change.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() {
      students[index].currentStatus = status.toUpperCase();
      _hasAttendanceChanged = true;
    });
  }

  void _showNoteDialog(int index, String currentNote) {
    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked. Cannot add note.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final TextEditingController noteController = TextEditingController(text: currentNote);
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
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
                    child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final students = controller.attendanceStudents;
                      if (students != null && index < students.length) {
                        students[index].remarks = noteController.text.trim();
                        _hasAttendanceChanged = true;
                      }
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  void _saveAttendance() {
    if (controller.isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    controller.saveAttendance();
    setState(() => _hasAttendanceChanged = false);
  }

  void _loadMore() {
    if (controller.hasMorePages && !controller.isLoadingMoreData) {
      controller.loadMoreData();
    }
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.totalStudentCount} Students',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Date + Class + Section
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
                              Text('Date', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    currentDate,
                                    style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Class
                        Expanded(
                          child: Obx(() {
                            final classNames = controller.classNames;
                            if (classNames.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Class', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.shade300, width: 1),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Class', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey.shade300, width: 1),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.selectedClassId.value,
                                      items: classNames.map((classId) {
                                        final name = controller.classGroups[classId]?.first.className ?? classId;
                                        return DropdownMenuItem<String>(
                                          value: classId,
                                          child: Text(name, style: Styles.darkBlcW600.copyWith(fontSize: 12)),
                                        );
                                      }).toList(),
                                      onChanged: (newId) {
                                        if (newId != null) controller.onClassSelected(newId);
                                      },
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                      style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(width: 8),

                        // Section
                        Expanded(
                          child: Obx(() {
                            final sections = controller.classGroups[controller.selectedClassId.value] ?? [];
                            if (sections.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Section', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.shade300, width: 1),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              );
                            }
                            // Ensure selected section is valid
                            String currentSection = controller.selectedSectionId.value;
                            bool isValid = sections.any((item) => item.sectionId == currentSection);
                            if (!isValid && sections.isNotEmpty) {
                              currentSection = sections.first.sectionId;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (controller.selectedSectionId.value != currentSection) {
                                  controller.selectedSectionId.value = currentSection;
                                  controller.selectedSectionName.value = sections.first.sectionName;
                                }
                              });
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Section', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey.shade300, width: 1),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: currentSection,
                                      items: sections.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item.sectionId,
                                          child: Text(item.sectionName, style: Styles.darkBlcW600.copyWith(fontSize: 12)),
                                        );
                                      }).toList(),
                                      onChanged: (newId) {
                                        if (newId != null) controller.onSectionSelected(newId);
                                      },
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                      style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Student List
                Expanded(
                  child: Obx(() {
                    // Show loader while either class data or attendance data is loading
                    if (controller.isLoadingData || controller.isLoading.value) {
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
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          color: Colors.grey.shade100,
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text('Roll', style: Styles.darkBlackW60012)),
                              Expanded(flex: 3, child: Text('Student Name', style: Styles.darkBlackW60012)),
                              Expanded(flex: 2, child: Text('Status', style: Styles.darkBlackW60012)),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('Note', style: Styles.darkBlackW60012),
                                ),
                              ),
                            ],
                          ),
                        ),
                         Divider(height: 1, color: Colors.grey.shade300),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scroll) {
                              if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                                  controller.hasMorePages && !controller.isLoadingMoreData) {
                                _loadMore();
                              }
                              return false;
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: students.length + (controller.hasMorePages ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == students.length && controller.hasMorePages) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  );
                                }
                                final student = students[index];
                                return Column(
                                  children: [
                                    _buildStudentRow(student: student, index: index),
                                    if (index < students.length - 1)
                                       Divider(height: 1, color: Colors.grey.shade200),
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
                  if (controller.isLoadingData || controller.isLoading.value) return const SizedBox.shrink();
                  final students = controller.attendanceStudents;
                  if (students == null || students.isEmpty) return const SizedBox.shrink();
                  final bool alreadyMarked = controller.isAttendanceAlreadyMarked.value;
                  final bool allMarked = students.every((s) => s.currentStatus != null && s.currentStatus!.isNotEmpty);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, -4))],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Opacity(
                        opacity: alreadyMarked ? 0.5 : 1.0,
                        child: GradientButton(
                          onPressed: alreadyMarked ? (){} : _saveAttendance,
                          text: alreadyMarked
                              ? 'Already Marked ✓'
                              : (allMarked && !_hasAttendanceChanged ? 'All Marked ✓' : 'Save Attendance'),
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
  Widget _buildStudentRow({required AttendanceStudent student, required int index}) {
    final options = statusOptions;
    String? selected = student.currentStatus;
    if (selected != null && !options.contains(selected.toUpperCase())) {
      selected = null;
    }
    final currentStatus = selected ?? (options.contains('PRESENT') ? 'PRESENT' : options.first);
    final bool alreadyMarked = controller.isAttendanceAlreadyMarked.value;

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
                Text('Reg: ${student.registrationNumber}', style: Styles.darkBlueW40010),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: currentStatus != null ? _getStatusBgColor(currentStatus) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: currentStatus != null ? _getStatusColor(currentStatus) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentStatus,
                  isExpanded: true,
                  isDense: true,
                  icon: const SizedBox.shrink(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.sora().fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: currentStatus != null ? _getStatusColor(currentStatus) : Colors.grey.shade600,
                  ),
                  onChanged: alreadyMarked
                      ? null
                      : (newValue) {
                    if (newValue != null) _updateAttendance(index, newValue);
                  },
                  items: options.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Center(
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.sora().fontFamily,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: status == currentStatus ? _getStatusColor(status) : Colors.black87,
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
              onTap: alreadyMarked ? null : () => _showNoteDialog(index, student.remarks ?? ''),
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: alreadyMarked ? 0.5 : 1.0,
                  child: Icon(Icons.note_alt_outlined, size: 22, color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}