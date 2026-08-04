import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/term_attendance_student_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'term_attendance_controller.dart';

class TermAttendanceScreen extends StatefulWidget {
  const TermAttendanceScreen({super.key});

  @override
  State<TermAttendanceScreen> createState() => _TermAttendanceScreenState();
}

class _TermAttendanceScreenState extends State<TermAttendanceScreen> {
  late final TermAttendanceController controller;
  final List<TextEditingController> _inputControllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    controller = Get.put(TermAttendanceController(Get.find()));
  }

  @override
  void dispose() {
    for (var c in _inputControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
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
                          Text('Term Attendance', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.studentList;

                    // Ensure we have enough controllers
                    while (_inputControllers.length < students.length) {
                      _inputControllers.add(TextEditingController(
                        text: students[_inputControllers.length]
                            .existingAttendance
                            ?.toString() ??
                            '0',
                      ));
                      _focusNodes.add(FocusNode());
                    }
                    while (_inputControllers.length > students.length) {
                      _inputControllers.removeLast().dispose();
                      _focusNodes.removeLast().dispose();
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== SELECT CRITERIA CONTAINER =====
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

                                // Row 1: Exam Group & Term
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Exam Group',
                                        value: controller
                                            .selectedExamGroupName.value,
                                        items: controller.examGroups
                                            .map((g) => g.groupName)
                                            .toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            final group = controller.examGroups
                                                .firstWhere(
                                                  (g) => g.groupName == newValue,
                                              orElse: () =>
                                              controller.examGroups.first,
                                            );
                                            controller
                                                .onExamGroupChanged(group.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Term',
                                        value:
                                        controller.selectedTermName.value,
                                        items: controller.examTerms
                                            .map((t) => t.term)
                                            .toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            final term =
                                            controller.examTerms.firstWhere(
                                                  (t) => t.term == newValue,
                                              orElse: () =>
                                              controller.examTerms.first,
                                            );
                                            controller.onTermChanged(term.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Row 2: Class & Section
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Class',
                                        value:
                                        controller.selectedClassName.value,
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
                                            controller
                                                .onClassChanged(classItem.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Section',
                                        value: controller
                                            .selectedSectionName.value,
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
                                            controller
                                                .onSectionChanged(section.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ===== ENTER ATTENDANCE with Max Attendance =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Enter Attendance', style: Styles.darkBlcW60015),
                              Text(
                                'Max Days: ${controller.maxAttendanceDisplay}',
                                style: Styles.darkBlueW400,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ===== STUDENT CARDS =====
                          students.isEmpty
                              ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'No students found for the selected criteria.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return _buildStudentCard(student, index);
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ),

                // ===== SAVE BUTTON =====
                Container(
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
                  child: Obx(() {
                    final bool isValid = controller.selectedExamGroupId.isNotEmpty &&
                        controller.selectedTermId.isNotEmpty &&
                        controller.selectedClassId.isNotEmpty &&
                        controller.selectedSectionId.isNotEmpty &&
                        controller.studentList.isNotEmpty;

                    final bool isSaving = controller.isLoading.value;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                        onPressed: (isValid && !isSaving)
                            ? () {
                          controller.saveTermAttendance();
                        }
                            : (){},
                        text: isSaving ? 'Saving...' : 'Save Term Attendance',
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

  // ========== DROPDOWN FIELD ==========
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isNotEmpty ? value : null,
              hint: Text('Select', style: Styles.darkBlcW600),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: Styles.darkBlcW600),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ========== STUDENT CARD (with improved input) ==========
  Widget _buildStudentCard(TermAttendanceStudent student, int index) {
    final controller = this.controller;
    final textController = _inputControllers[index];
    final focusNode = _focusNodes[index];

    // Update the controller's map when the text changes
    void updateAttendance(String value) {
      final int intValue = int.tryParse(value) ?? 0;
      controller.updateStudentAttendance(student.studentId, intValue);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          // Student Name & Reg
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: Styles.darkBlcW70013,
                ),
                Text(
                  'Reg: ${student.registrationNumber}',
                  style: Styles.darkBlueW400,
                ),
              ],
            ),
          ),
          // Attended Days Input
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Styles.skyBlueW60012,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                onChanged: (value) {
                  updateAttendance(value);
                },
                onTap: () {
                  // Clear the field when tapped if it contains only "0"
                  if (textController.text == '0') {
                    textController.clear();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}