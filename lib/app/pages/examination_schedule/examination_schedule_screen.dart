import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../../domain/models/exam_schedule_response.dart';
import 'examination_schedule_controller.dart';

class ExaminationScheduleScreen extends StatefulWidget {
  const ExaminationScheduleScreen({super.key});

  @override
  State<ExaminationScheduleScreen> createState() =>
      _ExaminationScheduleScreenState();
}

class _ExaminationScheduleScreenState extends State<ExaminationScheduleScreen> {
  late final ExaminationScheduleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExaminationScheduleController(Get.find()));
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
                          Text('Examination Schedule', style: Styles.whiteBold),
                        ],
                      ),
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

                    final schedule = controller.schedule;
                    final examData = controller.examScheduleData.value?.data;

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

                                // Row 1: Exam Group & Term
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Exam Group',
                                        value: controller.selectedExamGroupName.value,
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
                                            controller.onExamGroupChanged(group.id);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Term',
                                        value: controller.selectedTermName.value,
                                        items: controller.examTerms
                                            .map((t) => t.term)
                                            .toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            final term = controller.examTerms
                                                .firstWhere(
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

                          // ===== TIME TABLE TITLE (dynamic) =====
                          Text('Time Table',
                            style: Styles.darkBlcW70014,
                          ),
                          const SizedBox(height: 12),

                          // ===== EXAM SCHEDULE LIST (from API) =====
                          if (schedule.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  'No schedule found for the selected criteria.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: schedule.length,
                              itemBuilder: (context, index) {
                                final item = schedule[index];
                                return _buildExamCard(item);
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

  // ========== BUILD DROPDOWN FIELD ==========
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

// ========== BUILD GENERIC MENU ITEMS WITH DIVIDER ==========
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

  // ========== BUILD EXAM CARD (using ExamScheduleItem) ==========
  Widget _buildExamCard(ExamScheduleItem item) {
    // Format time from "HH:mm" to "hh:mm AM/PM"
    String formatTime(String? time) {
      if (time == null || time.isEmpty) return '';
      try {
        final parts = time.split(':');
        if (parts.length != 2) return time;
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final ampm = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $ampm';
      } catch (_) {
        return time;
      }
    }

    final timeString = '${formatTime(item.startTime)} - ${formatTime(item.endTime)}';
    final dateDisplay = item.examDate != null
        ? _formatDate(item.examDate!)
        : 'Date TBD';

    // Pick a color based on index or subject hash – we'll use a list of colors
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.indigo];
    final colorIndex = item.subjectName.hashCode.abs() % colors.length;
    final color = colors[colorIndex];

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== MIDDLE: Subject & Time ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subjectName,
                  style: Styles.darkBlcW60015,
                ),
                const SizedBox(height: 4),
                Text(timeString, style: Styles.darkBlueW400),
              ],
            ),
          ),

          // ========== RIGHT SIDE: Date & Day ==========
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateDisplay,
                style: Styles.skyBlueW70014,
              ),
              const SizedBox(height: 4),
              Text(
                item.dayName ?? '',
                style: Styles.darkBlueW400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to format date from "YYYY-MM-DD" to "DD MMM" (e.g., "06 Jul")
  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length != 3) return dateStr;
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      final monthAbbr = <String>[
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${day.toString().padLeft(2, '0')} ${monthAbbr[month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }
}