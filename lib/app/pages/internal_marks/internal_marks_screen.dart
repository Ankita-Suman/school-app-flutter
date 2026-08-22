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

  // Persistent controllers and focus nodes: studentId -> list of controllers/nodes
  final Map<String, List<TextEditingController>> _markControllers = {};
  final Map<String, List<FocusNode>> _focusNodes = {};

  // Keep track of current student IDs to detect changes
  Set<String> _currentStudentIds = {};

  // ✅ removed hardcoded max marks – now using API values directly

  @override
  void initState() {
    super.initState();
    controller = Get.put(InternalMarksController(Get.find()));
  }

  @override
  void dispose() {
    for (var list in _markControllers.values) {
      for (var c in list) c.dispose();
    }
    for (var list in _focusNodes.values) {
      for (var f in list) f.dispose();
    }
    super.dispose();
  }

  // ✅ Returns the API max marks list as List<int> (null → 0)
  List<int> _getEffectiveMaxMarks(List<int?> apiMaxMarks, int fieldCount) {
    if (apiMaxMarks.isEmpty) return List.filled(fieldCount, 0);
    return apiMaxMarks.map((m) => m ?? 0).toList();
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
                    if (controller.isLoadingData &&
                        controller.examGroups.isEmpty &&
                        controller.termClasses.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final students = controller.studentList;
                    final fieldCount = controller.internalCount.value;
                    final labels = controller.internalLabels;
                    final apiMaxMarks = controller.maxMarks;
                    final effectiveMaxMarks = _getEffectiveMaxMarks(apiMaxMarks, fieldCount);

                    // Detect student list change (subject switch)
                    final currentIds = students.map((s) => s['id'] as String).toSet();
                    if (_currentStudentIds != currentIds) {
                      // Remove controllers for students that are gone
                      final toRemove = _currentStudentIds.difference(currentIds);
                      for (var id in toRemove) {
                        if (_markControllers.containsKey(id)) {
                          for (var c in _markControllers[id]!) c.dispose();
                          _markControllers.remove(id);
                        }
                        if (_focusNodes.containsKey(id)) {
                          for (var f in _focusNodes[id]!) f.dispose();
                          _focusNodes.remove(id);
                        }
                      }
                      // Add new students
                      for (var id in currentIds) {
                        if (!_markControllers.containsKey(id)) {
                          final initialMarks = students.firstWhere((s) => s['id'] == id)['marks'] as List<String>? ?? List<String>.filled(fieldCount, '0');
                          _markControllers[id] = initialMarks.map((m) {
                            final isZero = m == '0';
                            return TextEditingController(text: isZero ? '' : m);
                          }).toList();
                          _focusNodes[id] = List.generate(fieldCount, (_) => FocusNode());
                        } else {
                          // Update text only if not focused (to avoid cursor jump)
                          final controllers = _markControllers[id]!;
                          final currentMarks = students.firstWhere((s) => s['id'] == id)['marks'] as List<String>? ?? List<String>.filled(fieldCount, '0');
                          for (int i = 0; i < controllers.length; i++) {
                            final node = _focusNodes[id]![i];
                            if (!node.hasFocus && controllers[i].text != currentMarks[i]) {
                              final isZero = currentMarks[i] == '0';
                              controllers[i].text = isZero ? '' : currentMarks[i];
                            }
                          }
                        }
                      }
                      _currentStudentIds = currentIds;
                    }

                    // Now build the student rows
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Select Criteria card (unchanged)
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
                                Text('Select Criteria', style: Styles.darkBlcW60015),
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
                          ),

                          const SizedBox(height: 16),

                          if (students.isEmpty && !controller.isLoadingStudents)
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
                          else if (controller.isLoadingStudents)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else ...[
                              // Header row – shows REAL max marks from API
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Enter Internal Marks', style: Styles.darkBlcW60015),
                                  Text(
                                    'Max Marks: ${effectiveMaxMarks.join(', ')}',
                                    style: Styles.darkBlackW60012,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Students list
                              if (fieldCount == 1)
                                _buildSingleFieldStudents(students, effectiveMaxMarks)
                              else
                                _buildMultiFieldStudents(students, labels, effectiveMaxMarks),
                            ],

                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ),

                // Save Button with validation (computes invalid on the fly)
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
                    bool hasInvalidMarks = false;
                    final students = controller.studentList;
                    final fieldCount = controller.internalCount.value;
                    final effectiveMax = _getEffectiveMaxMarks(controller.maxMarks, fieldCount);

                    for (var student in students) {
                      final isAbsent = student['isAbsent'] as bool? ?? false;
                      if (!isAbsent) {
                        final marksList = student['marks'] as List<String>? ?? [];
                        for (int i = 0; i < marksList.length && i < fieldCount; i++) {
                          final markStr = marksList[i];
                          if (markStr.isNotEmpty) {
                            final mark = int.tryParse(markStr);
                            final max = (i < effectiveMax.length) ? effectiveMax[i] : 0;
                            if (mark != null && max > 0 && mark > max) {
                              hasInvalidMarks = true;
                              break;
                            }
                          }
                        }
                      }
                      if (hasInvalidMarks) break;
                    }

                    final bool canSave = controller.canSave && controller.studentList.isNotEmpty && !hasInvalidMarks;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Opacity(
                        opacity: canSave ? 1.0 : 0.5,
                        child: GradientButton(
                          onPressed: canSave ? () { controller.saveInternalMarks(); } : () {},
                          text: controller.isSaving.value ? 'Saving...' : 'Save Marks',
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

  // ========== DROPDOWN WITH LOADING INDICATOR (unchanged) ==========
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
        isLoading
            ? Container(
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
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        )
            : Builder(
          builder: (btnContext) {
            return GestureDetector(
              onTap: () {
                if (items.isEmpty) return;
                final RenderBox renderBox = btnContext.findRenderObject() as RenderBox;
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
                  if (newValue != null) onChanged(newValue);
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

  // ===== SINGLE‑FIELD LAYOUT using the new _InvalidMarkField =====
  Widget _buildSingleFieldStudents(List<Map<String, dynamic>> students, List<int> maxMarks) {
    final max = maxMarks.isNotEmpty ? maxMarks.first : 0; // ✅ real API value or 0
    return Column(
      children: students.map((student) {
        final id = student['id'] as String;
        final controllers = _markControllers[id]![0];
        final focusNode = _focusNodes[id]![0];
        final index = students.indexWhere((s) => s['id'] == id);

        return Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
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
                    controller.studentList[index]['marks'] = [''];
                    controllers.text = '';
                  });
                  controller.markChanges();
                  controller.studentList.refresh();
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
              // Use the new _InvalidMarkField for single field
              _InvalidMarkField(
                controller: controllers,
                focusNode: focusNode,
                maxMark: max,
                isAbsent: student['isAbsent'] as bool? ?? false,
                onChanged: (value) {
                  controller.studentList[index]['marks'] = [value.isEmpty ? '0' : value];
                  controller.markChanges();
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===== MULTI‑FIELD LAYOUT using the new _InvalidMarkField =====
  Widget _buildMultiFieldStudents(
      List<Map<String, dynamic>> students,
      List<String> labels,
      List<int> maxMarks,
      ) {
    return Column(
      children: students.map((student) {
        final id = student['id'] as String;
        final controllers = _markControllers[id]!;
        final focusNodes = _focusNodes[id]!;
        final index = students.indexWhere((s) => s['id'] == id);

        final List<Widget> markWidgets = [];
        for (int i = 0; i < controllers.length; i++) {
          final max = (i < maxMarks.length) ? maxMarks[i] : 0; // ✅ real API value
          markWidgets.add(
            _buildMarkFieldWrapper(
              controllers: controllers[i],
              focusNode: focusNodes[i],
              isAbsent: student['isAbsent'] as bool? ?? false,
              index: index,
              fieldIndex: i,
              label: labels.length > i ? labels[i] : 'M${i+1}',
              maxMark: max,
            ),
          );
        }

        // Arrange fields in pairs
        List<Widget> rows = [];
        for (int i = 0; i < markWidgets.length; i += 2) {
          final first = markWidgets[i];
          final second = (i + 1 < markWidgets.length) ? markWidgets[i + 1] : null;
          rows.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
          margin: const EdgeInsets.only(top: 10, bottom: 12),
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
                      controller.studentList.refresh();
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

  // Wrapper for a single mark field in multi‑field layout
  Widget _buildMarkFieldWrapper({
    required TextEditingController controllers,
    required FocusNode focusNode,
    required bool isAbsent,
    required int index,
    required int fieldIndex,
    required String label,
    required int maxMark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  maxMark > 0 ? '(Max: $maxMark)' : '(Max: -)',
                  style: const TextStyle(fontSize: 8, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Use the new _InvalidMarkField
            _InvalidMarkField(
              controller: controllers,
              focusNode: focusNode,
              maxMark: maxMark,
              isAbsent: isAbsent,
              width: 70,
              height: 48,
              onChanged: (value) {
                final marksList = controller.studentList[index]['marks'] as List<String>;
                marksList[fieldIndex] = value.isEmpty ? '0' : value;
                controller.markChanges();
              },
            ),
          ],
        ),
      ],
    );
  }
}

// ===== NEW WIDGET: Self‑contained text field with red border based on current text =====
class _InvalidMarkField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxMark;
  final bool isAbsent;
  final double? width;
  final double? height;
  final ValueChanged<String> onChanged;

  const _InvalidMarkField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.maxMark,
    required this.isAbsent,
    this.width,
    this.height,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final text = value.text;
        bool isInvalid = false;
        if (text.isNotEmpty && maxMark > 0) {
          final mark = int.tryParse(text);
          if (mark != null && mark > maxMark) {
            isInvalid = true;
          }
        }

        return SizedBox(
          width: width ?? 55,
          height: height ?? 48,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
            enabled: !isAbsent,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: isInvalid ? Colors.red : Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isInvalid ? Colors.red : Colors.grey.shade300,
                  width: isInvalid ? 1.5 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isInvalid ? Colors.red : Colors.blue.shade700,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isInvalid ? Colors.red : Colors.grey.shade300,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              isDense: true,
              hintText: '0',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            onChanged: (value) {
              onChanged(value);
            },
          ),
        );
      },
    );
  }
}