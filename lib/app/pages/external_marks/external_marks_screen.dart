import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'external_marks_controller.dart';

class ExternalMarksScreen extends StatefulWidget {
  const ExternalMarksScreen({super.key});

  @override
  State<ExternalMarksScreen> createState() => _ExternalMarksScreenState();
}

class _ExternalMarksScreenState extends State<ExternalMarksScreen> {
  late final ExternalMarksController controller;
  final List<TextEditingController> markControllers = [];
  final List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExternalMarksController(Get.find()));
  }

  @override
  void dispose() {
    for (var c in markControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
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
                          Text('External Marks', style: Styles.whiteBold),
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

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== SELECT CRITERIA =====
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

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Exam Group',
                                        value: controller
                                            .selectedExamGroupName.value,
                                        items: controller.examGroups
                                            .map((g) => g.groupName)
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            final group = controller.examGroups
                                                .firstWhere((g) =>
                                            g.groupName == val);
                                            controller.onExamGroupChanged(
                                                group.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Term',
                                        value: controller
                                            .selectedTermName.value,
                                        items: controller.examTerms
                                            .map((t) => t.term)
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            final term = controller.examTerms
                                                .firstWhere((t) =>
                                            t.term == val);
                                            controller.onTermChanged(term.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Class',
                                        value: controller
                                            .selectedClassName.value,
                                        items: controller.termClasses
                                            .map((c) => c.name)
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            final classItem = controller
                                                .termClasses
                                                .firstWhere((c) =>
                                            c.name == val);
                                            controller.onClassChanged(
                                                classItem.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdown(
                                        label: 'Section',
                                        value: controller
                                            .selectedSectionName.value,
                                        items: controller.termSections
                                            .map((s) => s.name)
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            final section = controller
                                                .termSections
                                                .firstWhere((s) =>
                                            s.name == val);
                                            controller.onSectionChanged(
                                                section.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text('Subject',
                                        style: Styles.darkBlueW40010),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedSubjectName
                                              .value.isNotEmpty
                                              ? controller
                                              .selectedSubjectName.value
                                              : null,
                                          hint: Text('Select Subject',
                                              style: Styles.darkBlcW600),
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Colors.grey.shade600),
                                          items: controller.subjectList
                                              .map((subject) {
                                            return DropdownMenuItem<String>(
                                              value: subject.name,
                                              child: Text(subject.name,
                                                  style: Styles.darkBlcW600),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              final subject = controller
                                                  .subjectList
                                                  .firstWhere((s) =>
                                              s.name == val);
                                              controller.onSubjectChanged(
                                                  subject.id);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text('Enter External Marks',
                              style: Styles.darkBlcW60015),
                          const SizedBox(height: 12),

                          Obx(() {
                            if (controller.isLoadingStudents) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final students = controller.studentList;
                            if (students.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                  child: Text(
                                    'No students found.\nPlease select all criteria and a subject.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }

                            // Ensure controllers
                            while (markControllers.length < students.length) {
                              markControllers.add(TextEditingController(
                                  text: students[markControllers.length]
                                  ['marks'] ??
                                      '0'));
                              focusNodes.add(FocusNode());
                            }
                            while (markControllers.length > students.length) {
                              markControllers.removeLast().dispose();
                              focusNodes.removeLast().dispose();
                            }

                            return Column(
                              children: students.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 1),
                                  ),
                                  child: _buildStudentRow(
                                    index: index,
                                    name: student['name'] as String? ?? '',
                                    reg: student['reg'] as String? ?? '',
                                    roll: student['roll'] as String? ?? '',
                                    isAbsent:
                                    student['isAbsent'] as bool? ?? false,
                                  ),
                                );
                              }).toList(),
                            );
                          }),

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
                    final bool canSave = controller.canSave;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                        onPressed: canSave
                            ? () {
                          controller.saveExternalMarks();
                        }
                            : (){},
                        text: controller.isSaving.value
                            ? 'Saving...'
                            : 'Save Marks',
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

  // ========== DROPDOWN BUILDER ==========
  Widget _buildDropdown({
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

  // ========== STUDENT ROW ==========
  Widget _buildStudentRow({
    required int index,
    required String name,
    required String reg,
    required String roll,
    required bool isAbsent,
  }) {
    final focusNode = focusNodes[index];
    final textController = markControllers[index];

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Styles.darkBlcW70013),
              Text('$reg $roll', style: Styles.darkBlueW400),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            final current =
                controller.studentList[index]['isAbsent'] as bool? ?? false;
            controller.studentList[index]['isAbsent'] = !current;
            // Update controller data and local controller
            setState(() {
              if (controller.studentList[index]['isAbsent'] as bool) {
                textController.text = '';
              } else {
                textController.text = '0';
              }
            });
            controller.markChanges(); // ✅ mark change
          },
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isAbsent ? Colors.blue.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isAbsent ? Colors.blue.shade700 : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isAbsent
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                'Absent',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isAbsent ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 55,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Styles.skyBlueW60012,
            enabled: !isAbsent,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            focusNode: focusNode
              ..addListener(() {
                if (focusNode.hasFocus && textController.text == '0') {
                  textController.clear();
                }
              }),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hintText: '0',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            onChanged: (value) {
              controller.studentList[index]['marks'] = value.isEmpty ? '0' : value;
              controller.markChanges(); // ✅ mark change
            },
          ),
        ),
      ],
    );
  }
}