import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'internal_marks_controller.dart';

class InternalMarksScreen extends StatefulWidget {
  const InternalMarksScreen({super.key});

  @override
  State<InternalMarksScreen> createState() => _InternalMarksScreenState();
}

class _InternalMarksScreenState extends State<InternalMarksScreen> {
  late final InternalMarksController controller;

  // For multi‑field layout (2D controllers)
  final List<List<TextEditingController>> markControllers = [];
  final List<List<FocusNode>> focusNodes = [];

  // For single‑field layout (1D controllers)
  final List<TextEditingController> singleControllers = [];
  final List<FocusNode> singleFocusNodes = [];

  @override
  void initState() {
    super.initState();
    controller = Get.put(InternalMarksController(Get.find()));
  }

  @override
  void dispose() {
    for (var list in markControllers) {
      for (var c in list) c.dispose();
    }
    for (var list in focusNodes) {
      for (var f in list) f.dispose();
    }
    for (var c in singleControllers) c.dispose();
    for (var f in singleFocusNodes) f.dispose();
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
                          Text('Internal Marks', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: Obx(() {
                    // ✅ Fixed: removed .value – isLoadingData is already a bool
                    if (controller.isLoadingData &&
                        controller.examGroups.isEmpty &&
                        controller.termClasses.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.studentList;
                    final fieldCount = controller.internalCount.value;
                    final labels = controller.internalLabels;
                    final maxMarks = controller.maxMarks;

                    // Build controllers based on layout
                    if (fieldCount == 1) {
                      while (singleControllers.length < students.length) {
                        final initialMark = students[singleControllers.length]['marks'] as List<String>?;
                        final text = (initialMark != null && initialMark.isNotEmpty) ? initialMark.first : '0';
                        final isZero = text == '0';
                        singleControllers.add(TextEditingController(text: isZero ? '' : text));
                        singleFocusNodes.add(FocusNode());
                      }
                      while (singleControllers.length > students.length) {
                        singleControllers.removeLast().dispose();
                        singleFocusNodes.removeLast().dispose();
                      }
                    } else {
                      while (markControllers.length < students.length) {
                        final studentMarks = students[markControllers.length]['marks'] as List<String>?;
                        final defaultMarks = List<String>.filled(fieldCount, '0');
                        final initialMarks = (studentMarks != null && studentMarks.length == fieldCount)
                            ? studentMarks
                            : defaultMarks;
                        final controllers = initialMarks.map((m) {
                          final isZero = m == '0';
                          return TextEditingController(text: isZero ? '' : m);
                        }).toList();
                        markControllers.add(controllers);
                        focusNodes.add(List.generate(fieldCount, (_) => FocusNode()));
                      }
                      while (markControllers.length > students.length) {
                        markControllers.removeLast().forEach((c) => c.dispose());
                        focusNodes.removeLast().forEach((f) => f.dispose());
                      }
                    }

                    final bool isSingleField = fieldCount == 1;

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
                                      child: _buildDropdownWithLoading(
                                        label: 'Exam Group',
                                        value: controller.selectedExamGroupName.value,
                                        items: controller.examGroups.map((g) => g.groupName).toList(),
                                        isLoading: controller.isLoadingGroups.value,
                                        onChanged: (val) {
                                          if (val != null) {
                                            final group = controller.examGroups
                                                .firstWhere((g) => g.groupName == val);
                                            controller.onExamGroupChanged(group.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownWithLoading(
                                        label: 'Term',
                                        value: controller.selectedTermName.value,
                                        items: controller.examTerms.map((t) => t.term).toList(),
                                        isLoading: controller.isLoadingTerms.value,
                                        onChanged: (val) {
                                          if (val != null) {
                                            final term = controller.examTerms
                                                .firstWhere((t) => t.term == val);
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
                                      child: _buildDropdownWithLoading(
                                        label: 'Class',
                                        value: controller.selectedClassName.value,
                                        items: controller.termClasses.map((c) => c.name).toList(),
                                        isLoading: controller.isLoadingClasses.value,
                                        onChanged: (val) {
                                          if (val != null) {
                                            final classItem = controller.termClasses
                                                .firstWhere((c) => c.name == val);
                                            controller.onClassChanged(classItem.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownWithLoading(
                                        label: 'Section',
                                        value: controller.selectedSectionName.value,
                                        items: controller.termSections.map((s) => s.name).toList(),
                                        isLoading: controller.isLoadingSections.value,
                                        onChanged: (val) {
                                          if (val != null) {
                                            final section = controller.termSections
                                                .firstWhere((s) => s.name == val);
                                            controller.onSectionChanged(section.id);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   // Text('Subject', style: Styles.darkBlueW40010),
                                    const SizedBox(height: 4),
                                    _buildDropdownWithLoading(
                                      label: 'Select Subject',
                                      value: controller.selectedSubjectName.value,
                                      items: controller.subjectList.map((s) => s.name).toList(),
                                      isLoading: controller.isLoadingSubjects.value,
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
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (students.isEmpty && !controller.isLoadingStudents) // ✅ fixed
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  'No students found.\nPlease select all criteria and a subject.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else if (controller.isLoadingStudents) // ✅ fixed
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else ...[
                              Text(
                                'Enter Internal Marks',
                                style: Styles.darkBlcW60015,
                              ),
                              const SizedBox(height: 12),
                              if (isSingleField)
                                _buildSingleFieldStudents(students)
                              else
                                _buildMultiFieldStudents(students, labels, maxMarks),
                            ],

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
                    final bool canSave = controller.canSave && controller.studentList.isNotEmpty;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                        onPressed: canSave ? () { controller.saveInternalMarks(); } : (){},
                        text: controller.isSaving.value ? 'Saving...' : 'Save Marks',
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

  // ========== DROPDOWN WITH LOADING INDICATOR ==========
  Widget _buildDropdownWithLoading({
    required String label,
    required String value,
    required List<String> items,
    required bool isLoading,
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
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: isLoading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ),
                  )
                      : DropdownButton<String>(
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
          ),
        ),
      ],
    );
  }

  // ===== SINGLE‑FIELD LAYOUT (internalCount == 1) =====
  Widget _buildSingleFieldStudents(List<Map<String, dynamic>> students) {
    return Column(
      children: students.asMap().entries.map((entry) {
        final index = entry.key;
        final student = entry.value;
        final TextEditingController controllers = singleControllers[index];
        final FocusNode focusNode = singleFocusNodes[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['name'] ?? '', style: Styles.darkBlcW70013),
                    Text(
                      'Roll: ${student['roll']} | Adm: ${student['reg']}',
                      style: Styles.darkBlueW400,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  final current = student['isAbsent'] as bool? ?? false;
                  controller.studentList[index]['isAbsent'] = !current;
                  setState(() {
                    controllers.text = '';
                    final marksList = controller.studentList[index]['marks'] as List<String>?;
                    if (marksList != null && marksList.isNotEmpty) {
                      marksList[0] = '';
                    } else {
                      controller.studentList[index]['marks'] = [''];
                    }
                  });
                  controller.markChanges();
                },
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: (student['isAbsent'] as bool? ?? false)
                            ? Colors.blue.shade700
                            : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: (student['isAbsent'] as bool? ?? false)
                              ? Colors.blue.shade700
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: (student['isAbsent'] as bool? ?? false)
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Absent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: (student['isAbsent'] as bool? ?? false)
                            ? Colors.blue.shade700
                            : Colors.grey.shade600,
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
                  controller: controllers,
                  focusNode: focusNode
                    ..addListener(() {
                      if (focusNode.hasFocus && controllers.text == '0') {
                        controllers.clear();
                      }
                    }),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Styles.skyBlueW60012,
                  enabled: !(student['isAbsent'] as bool? ?? false),
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
                    final marksList = controller.studentList[index]['marks'] as List<String>?;
                    if (marksList != null && marksList.isNotEmpty) {
                      marksList[0] = value;
                    } else {
                      controller.studentList[index]['marks'] = [value];
                    }
                    controller.markChanges();
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===== MULTI‑FIELD LAYOUT (internalCount > 1) =====
  Widget _buildMultiFieldStudents(
      List<Map<String, dynamic>> students,
      List<String> labels,
      List<int?> maxMarks,
      ) {
    return Column(
      children: students.asMap().entries.map((entry) {
        final index = entry.key;
        final student = entry.value;
        final controllers = markControllers[index];
        final nodes = focusNodes[index];

        final List<Widget> markWidgets = [];
        for (int i = 0; i < controllers.length; i++) {
          markWidgets.add(
            _buildMarkField(
              controller: controllers[i],
              focusNode: nodes[i],
              isAbsent: student['isAbsent'] as bool? ?? false,
              index: index,
              fieldIndex: i,
              label: labels.length > i ? labels[i] : 'M${i+1}',
              maxMark: maxMarks.length > i ? maxMarks[i] : null,
            ),
          );
        }

        List<Widget> rows = [];
        for (int i = 0; i < markWidgets.length; i += 2) {
          final first = markWidgets[i];
          final second = (i + 1 < markWidgets.length) ? markWidgets[i + 1] : null;
          rows.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: first),
                  if (second != null) const SizedBox(width: 8),
                  if (second != null) Expanded(child: second) else Expanded(child: Container()),
                ],
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      student['name']?.isNotEmpty == true
                          ? student['name'][0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['name'] ?? '', style: Styles.darkBlcW70013),
                        Text(
                          'Roll: ${student['roll']} | Adm: ${student['reg']}',
                          style: Styles.darkBlueW400,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final current = student['isAbsent'] as bool? ?? false;
                      controller.studentList[index]['isAbsent'] = !current;
                      setState(() {
                        if (controller.studentList[index]['isAbsent'] as bool) {
                          for (var c in controllers) c.text = '';
                        } else {
                          for (var c in controllers) c.text = '0';
                        }
                      });
                      controller.markChanges();
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: (student['isAbsent'] as bool? ?? false)
                                ? Colors.blue.shade700
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: (student['isAbsent'] as bool? ?? false)
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: (student['isAbsent'] as bool? ?? false)
                              ? const Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Absent',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: (student['isAbsent'] as bool? ?? false)
                                ? Colors.blue.shade700
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(children: rows),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===== SINGLE MARK FIELD =====
  Widget _buildMarkField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isAbsent,
    required int index,
    required int fieldIndex,
    required String label,
    required int? maxMark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: Styles.darkBlcW600,
              textAlign: TextAlign.center,
            ),
            Text(
              maxMark != null ? '(Max: $maxMark)' : '(Max: -)',
              style: const TextStyle(fontSize: 8, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(width: 8),
        _buildMarkInput(
          textController: controller,
          focusNode: focusNode,
          isAbsent: isAbsent,
          index: index,
          fieldIndex: fieldIndex,
        ),
      ],
    );
  }

  // ===== MARK INPUT =====
  Widget _buildMarkInput({
    required TextEditingController textController,
    required FocusNode focusNode,
    required bool isAbsent,
    required int index,
    required int fieldIndex,
  }) {
    return SizedBox(
      width: 40,
      height: 30,
      child: TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          isDense: true,
          hintText: '0',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        onChanged: (value) {
          final marksList = controller.studentList[index]['marks'] as List<String>;
          marksList[fieldIndex] = value.isEmpty ? '0' : value;
          controller.markChanges();
        },
      ),
    );
  }
}