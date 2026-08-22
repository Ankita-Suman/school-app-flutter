// edit_attendance_screen.dart
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
      case 'PRESENT':
        return Colors.green;
      case 'LATE':
        return Colors.orange;
      case 'ABSENT':
        return Colors.red;
      case 'HALF_DAY':
        return Colors.purple;
      case 'LEAVE':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _displayStatus(String status) {
    if (status.toUpperCase() == 'HALF_DAY') return 'HALF DAY';
    return status.toUpperCase();
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Colors.green.shade50;
      case 'LATE':
        return Colors.orange.shade50;
      case 'ABSENT':
        return Colors.red.shade50;
      case 'HALF_DAY':
        return Colors.purple.shade50;
      case 'LEAVE':
        return Colors.blue.shade50;
      default:
        return Colors.transparent;
    }
  }

  void _updateAttendance(int index, String status) {
    controller.updateStudentAttendance(index, status);
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

  // ========== CONFIRMATION DIALOG ==========
  void _showConfirmationDialog() {
    final students = controller.students;
    if (students.isEmpty) return;

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
                'Confirm Changes',
                style: Styles.darkBlcW700.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Students: ${students.length}',
                style: Styles.darkBlueW400,
              ),
              const SizedBox(height: 16),
              ...statusCounts.entries.map((entry) {
                final displayStatus = entry.key;
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
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        controller.updateAttendance();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  // ========== SAVE ACTION ==========
  void _saveChanges() {
    if (!controller.hasChanges()) {
      Get.snackbar('Info', 'No changes to save.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }
    _showConfirmationDialog();
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
                      // ----- Student Count – hidden when no data -----
                      Obx(() {
                        if (!controller.isAttendanceMarked || controller.students.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final count = controller.totalStudents;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count Students',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        );
                      }),
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
                                  ),
                                ],
                              );
                            }
                            String? selectedId = controller.selectedClassId.value;
                            if (selectedId.isEmpty || !classNames.contains(selectedId)) {
                              selectedId = classNames.isNotEmpty ? classNames.first : null;
                              if (selectedId != null && selectedId != controller.selectedClassId.value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.onClassSelected(selectedId!);
                                });
                              }
                            }
                            final selectedName =
                                controller.classGroups[selectedId]?.first.className ?? selectedId ?? '--';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Class', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                const SizedBox(height: 4),
                                Builder(
                                  builder: (btnContext) {
                                    return GestureDetector(
                                      onTap: () {
                                        final currentNames = controller.classNames;
                                        if (currentNames.isEmpty) return;

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
                                          items: _buildClassMenuItems(currentNames),
                                        ).then((newId) {
                                          if (newId != null) {
                                            controller.onClassSelected(newId);
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
                                                selectedName,
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
                                  ),
                                ],
                              );
                            }
                            String? selectedSection = controller.selectedSectionId.value;
                            bool isValid = sections.any((s) => s.sectionId == selectedSection);
                            if (!isValid && sections.isNotEmpty) {
                              selectedSection = sections.first.sectionId;
                              if (selectedSection != controller.selectedSectionId.value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.onSectionSelected(selectedSection!);
                                });
                              }
                            }
                            final selectedSectionName = sections
                                .firstWhere(
                                  (s) => s.sectionId == selectedSection,
                              orElse: () => sections.first,
                            )
                                .sectionName;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Section', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                const SizedBox(height: 4),
                                Builder(
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
                                                selectedSectionName,
                                                style: Styles.darkBlcW600.copyWith(fontSize: 12),
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
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                // ===== WARNING CONTAINER – shown only when students exist =====
                Obx(() {
                  if (!controller.isAttendanceMarked || controller.students.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  );
                }),

                // Student List (with attendance marked check)
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ---------- CHECK IF ATTENDANCE IS MARKED ----------
                    if (!controller.isAttendanceMarked) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 64,
                                color: Colors.orange.shade300,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Attendance is not marked for today. Please mark attendance first using the \'Mark Attendance\' screen.',
                                style: Styles.darkBlackW400,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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

                // ========== UPDATE BUTTON – hidden if attendance not marked ==========
                Obx(() {
                  if (!controller.hasData || !controller.isAttendanceMarked) return const SizedBox.shrink();
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
                        onPressed: _saveChanges,
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
    String? selectedStatus = student.attendance?.status != null
        ? _displayStatus(student.attendance!.status!)
        : null;
    final currentStatus = selectedStatus ?? (options.contains('PRESENT') ? 'PRESENT' : options.first);
    final String note = student.attendance?.remarks ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 40, child: Text(student.rollNumber, style: Styles.darkBlcW60013)),
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

  // ========== BUILD CLASS MENU ITEMS ==========
  List<PopupMenuEntry<String>> _buildClassMenuItems(List<String> classIds) {
    final List<PopupMenuEntry<String>> items = [];

    for (int i = 0; i < classIds.length; i++) {
      final classId = classIds[i];
      final name = controller.classGroups[classId]?.first.className ?? classId;
      items.add(
        PopupMenuItem<String>(
          value: classId,
          height: 40,
          child: SizedBox(
            width: 220,
            child: Text(
              name,
              style: Styles.darkBlcW600.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      if (i != classIds.length - 1) {
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
}