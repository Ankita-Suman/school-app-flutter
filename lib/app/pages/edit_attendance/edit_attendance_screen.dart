import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/get_student_attendance_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'edit_attendance_controller.dart';

class EditAttendanceScreen extends StatefulWidget {
  const EditAttendanceScreen({super.key});

  @override
  State<EditAttendanceScreen> createState() => _EditAttendanceScreenState();
}

class _EditAttendanceScreenState extends State<EditAttendanceScreen> {
  late final EditAttendanceController controller;

  bool _hasAttendanceChanged = false;

  String get currentDate {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;
    return '$day/$month/$year';
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditAttendanceController(Get.find()));
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
    controller.updateStudentAttendance(index, status);
    setState(() => _hasAttendanceChanged = true);
  }

  void _showNoteDialog(int index, String currentNote) {
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
                      controller.updateStudentNote(index, noteController.text.trim());
                      setState(() => _hasAttendanceChanged = true);
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

  void _saveChanges() {
    controller.updateAttendance();
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
                          Text('Edit Attendance', style: Styles.whiteBold),
                        ],
                      ),
                      Obx(() {
                        final count = controller.totalStudents;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count Students',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ========== DATE + CLASS + SECTION (with dropdowns) ==========
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
                                    controller.attendanceDate.isNotEmpty
                                        ? _formatDate(controller.attendanceDate)
                                        : currentDate,
                                    style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Class Dropdown
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

                        // Section Dropdown
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

                // Warning
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 25),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'You are modifying a submitted attendance record.',
                            style: Styles.orange12500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Student list with table header
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.students;
                    if (students.isEmpty) {
                      return const Center(
                        child: Text(
                          'No students found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Header
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

                        // List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
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
                      ],
                    );
                  }),
                ),

                // Update button
                Obx(() {
                  if (!controller.hasData) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                        onPressed: _hasAttendanceChanged ? _saveChanges : (){},
                        text: 'Update Changes',
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
  Widget _buildStudentRow({required StudentAttendance student, required int index}) {
    final options = controller.getAttendanceOptions();
    String? selectedStatus = student.attendance?.status;
    if (selectedStatus != null && !options.any((s) => s.toUpperCase() == selectedStatus!.toUpperCase())) {
      selectedStatus = null;
    }
    final currentStatus = selectedStatus ?? (options.contains('PRESENT') ? 'PRESENT' : options.first);
    final String note = student.attendance?.remarks ?? '';

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
                Text(student.fullName, style: Styles.darkBlcW60013),
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
                  onChanged: (newValue) {
                    if (newValue != null) _updateAttendance(index, newValue);
                  },
                  items: options.map((status) {
                    final isSelected = status.toUpperCase() == currentStatus;
                    return DropdownMenuItem<String>(
                      value: status.toUpperCase(),
                      child: Center(
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.sora().fontFamily,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? _getStatusColor(status) : Colors.black87,
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
              onTap: () => _showNoteDialog(index, note),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.note_alt_outlined, size: 22, color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      if (date.contains('-')) {
        final parts = date.split('-');
        if (parts.length == 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}