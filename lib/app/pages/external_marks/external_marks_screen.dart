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

  // Persistent maps keyed by student id → controller / focus node
  final Map<String, TextEditingController> _markControllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  // Temporary hardcoded max marks until backend is fixed
  static const int maxMarks = 80;

  // Keep track of current student ids to clean up removed ones
  Set<String> _currentStudentIds = {};

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExternalMarksController(Get.find()));
  }

  @override
  void dispose() {
    for (var c in _markControllers.values) c.dispose();
    for (var f in _focusNodes.values) f.dispose();
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
                          // ---------- SELECT CRITERIA ----------
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
                                _buildDropdown(
                                  label: 'Subject',
                                  value: controller.selectedSubjectName.value,
                                  items: controller.subjectList
                                      .map((s) => s.name)
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      final subject = controller.subjectList
                                          .firstWhere((s) => s.name == val);
                                      controller.onSubjectChanged(subject.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ---------- HEADER WITH MAX MARKS ----------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Enter External Marks',
                                  style: Styles.darkBlcW60015),
                              Text(
                                'Max Marks: $maxMarks',
                                style: Styles.darkBlueW500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ---------- STUDENT LIST ----------
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

                            // Clean up controllers for students no longer in the list
                            final currentIds =
                            students.map((s) => s['id'] as String).toSet();
                            final toRemove = _currentStudentIds
                                .difference(currentIds)
                                .toList();
                            for (var id in toRemove) {
                              _markControllers[id]?.dispose();
                              _markControllers.remove(id);
                              _focusNodes[id]?.dispose();
                              _focusNodes.remove(id);
                            }
                            _currentStudentIds = currentIds;

                            // Ensure controllers for all students
                            for (var student in students) {
                              final id = student['id'] as String;
                              if (!_markControllers.containsKey(id)) {
                                final initialMark = student['marks'] ?? '0';
                                _markControllers[id] =
                                    TextEditingController(text: initialMark);
                                _focusNodes[id] = FocusNode();
                              } else {
                                final newMark = student['marks'] ?? '0';
                                final controller = _markControllers[id]!;
                                if (!_focusNodes[id]!.hasFocus &&
                                    controller.text != newMark) {
                                  controller.text = newMark;
                                }
                              }
                            }

                            return Column(
                              children: students.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                final id = student['id'] as String;
                                final textController = _markControllers[id]!;
                                final focusNode = _focusNodes[id]!;

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
                                    studentId: id,
                                    name: student['name'] as String? ?? '',
                                    reg: student['reg'] as String? ?? '',
                                    roll: student['roll'] as String? ?? '',
                                    isAbsent:
                                    student['isAbsent'] as bool? ?? false,
                                    textController: textController,
                                    focusNode: focusNode,
                                    onMarkChanged: (value) {
                                      controller.studentList[index]['marks'] =
                                      value.isEmpty ? '0' : value;
                                      controller.studentList.refresh();
                                      controller.markChanges();
                                    },
                                    onAbsentToggled: () {
                                      final current = controller
                                          .studentList[index]['isAbsent']
                                      as bool? ??
                                          false;
                                      controller.studentList[index]
                                      ['isAbsent'] = !current;
                                      if (controller.studentList[index]
                                      ['isAbsent'] as bool) {
                                        textController.text = '';
                                      } else {
                                        textController.text = '0';
                                      }
                                      controller.studentList.refresh();
                                      controller.markChanges();
                                    },
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

                // ---------- SAVE BUTTON (with validation) ----------
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
                    // Check if any student has an invalid mark (exceeds maxMarks)
                    bool hasInvalidMarks = false;
                    final students = controller.studentList;
                    for (var student in students) {
                      final isAbsent = student['isAbsent'] as bool? ?? false;
                      if (!isAbsent) {
                        final markStr = student['marks'] as String? ?? '0';
                        final mark = int.tryParse(markStr);
                        if (mark != null && mark > maxMarks) {
                          hasInvalidMarks = true;
                          break;
                        }
                      }
                    }

                    final bool canSave = controller.canSave && !hasInvalidMarks;
                    final bool isSaving = controller.isSaving.value;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Opacity(
                        opacity: canSave ? 1.0 : 0.5,
                        child: GradientButton(
                          onPressed: canSave
                              ? () {
                            controller.saveExternalMarks();
                          }
                              : () {},
                          text: isSaving ? 'Saving...' : 'Save Marks',
                        ),
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

  // ========== DROPDOWN BUILDER (unchanged) ==========
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

  // ========== GENERIC MENU ITEMS (unchanged) ==========
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

  // ========== STUDENT ROW (unchanged) ==========
  Widget _buildStudentRow({
    required String studentId,
    required String name,
    required String reg,
    required String roll,
    required bool isAbsent,
    required TextEditingController textController,
    required FocusNode focusNode,
    required ValueChanged<String> onMarkChanged,
    required VoidCallback onAbsentToggled,
  }) {
    // Validate mark against max
    final String markStr = textController.text;
    bool isInvalid = false;
    if (markStr.isNotEmpty) {
      final mark = int.tryParse(markStr);
      if (mark != null && mark > maxMarks) {
        isInvalid = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Main row ----------
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Student info
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
            // Absent toggle
            GestureDetector(
              onTap: onAbsentToggled,
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
            // Marks input
            Container(
              width: 55,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isInvalid ? Colors.red : Colors.grey.shade300,
                  width: isInvalid ? 1.5 : 1,
                ),
              ),
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Styles.skyBlueW60012,
                enabled: !isAbsent,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                onChanged: (value) {
                  onMarkChanged(value);
                },
              ),
            ),
          ],
        ),

        // ---------- Error message (right‑aligned below the text field) ----------
        if (isInvalid)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Max marks is $maxMarks',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}