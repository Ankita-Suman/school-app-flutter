import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/domain/models/my_classes_response.dart';
import '../../../domain/models/get_attendance_report_response.dart';
import '../../app.dart';
import 'attendance_report_controller.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  late final AttendanceReportController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AttendanceReportController(Get.find()));
  }

  // ========== NEW: MONTH PICKER DIALOG ==========
  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthPickerDialog(
        initialSelectedDate: controller.selectedDate.value, // 👈 yeh line important
      ),
    );
    if (picked != null) {
      // Set selected date to first day of that month
      final firstDay = DateTime(picked.year, picked.month, 1);
      controller.onDateChanged(firstDay);
    }
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
                          Text('Attendance Report', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    final isLoading = controller.isLoadingData;
                    final hasData = controller.hasReportData;
                    final selectedClassId = controller.selectedClassId.value;
                    final selectedSectionId =
                        controller.selectedSectionId.value;
                    final sections =
                        controller.classGroups[selectedClassId] ?? [];

                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== TOP ROW =====
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ---------- MONTH (instead of Date) ----------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Month',
                                          style: Styles.darkBlueW400
                                              .copyWith(fontSize: 10)),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () => _selectMonth(context),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 1),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _formatMonthYear(controller
                                                  .selectedDate.value),
                                              style: Styles.darkBlcW600
                                                  .copyWith(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // ---------- CLASS ----------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Class',
                                          style: Styles.darkBlueW400
                                              .copyWith(fontSize: 10)),
                                      const SizedBox(height: 4),
                                      Builder(
                                        builder: (btnContext) {
                                          return GestureDetector(
                                            onTap: () {
                                              final allClasses = controller.uniqueClassList;
                                              if (allClasses == null || allClasses.isEmpty) return;

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
                                                items: _buildClassMenuItems(allClasses),
                                              ).then((newValue) {
                                                if (newValue != null) {
                                                  controller.onClassChanged(newValue);
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: Colors.grey.shade400, width: 1),
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
                                                      controller.selectedClassName.value.isNotEmpty
                                                          ? controller.selectedClassName.value
                                                          : '--',
                                                      style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Icon(Icons.keyboard_arrow_down,
                                                      size: 16, color: Colors.grey),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(width: 8),

                                // ---------- SECTION ----------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Section',
                                          style: Styles.darkBlueW400
                                              .copyWith(fontSize: 10)),
                                      const SizedBox(height: 4),
                                      sections.isEmpty
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
                    child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    )
                                          : Builder(
                                        builder: (btnContext) {
                                          return GestureDetector(
                                            onTap: () {
                                              final RenderBox renderBox =
                                              btnContext.findRenderObject() as RenderBox;
                                              final Offset offset = renderBox.localToGlobal(Offset.zero);
                                              final Size size = renderBox.size;   // ✅ box ka actual width/height

                                              showMenu<String>(
                                                context: btnContext,
                                                color: Colors.white,               // ✅ background white
                                                surfaceTintColor: Colors.transparent,   // ✅ M3 ka pink/purple tint hataya
                                                position: RelativeRect.fromLTRB(
                                                  offset.dx,
                                                  offset.dy + size.height,          // ✅ box ke bilkul niche se attach
                                                  offset.dx + size.width,
                                                  offset.dy + size.height + 100,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                elevation: 4,
                                                constraints: BoxConstraints(
                                                  minWidth: size.width,             // ✅ menu ki width box jitni
                                                  maxWidth: size.width,
                                                ),
                                                items: _buildSectionMenuItems(sections),
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
                                                  Text(
                                                    sections
                                                        .firstWhere(
                                                          (s) => s.sectionId == selectedSectionId,
                                                      orElse: () => sections.first,
                                                    )
                                                        .sectionName,
                                                    style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                                  ),
                                                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ---------- CONTENT ----------
                          if (!hasData)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bar_chart,
                                      size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No attendance data available',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please select a class and month',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            _buildAttendanceReportCard(),
                            const SizedBox(height: 30),
                            Text('Top Defaulters', style: Styles.darkBlcW700),
                            const SizedBox(height: 12),
                            _buildDefaultersList(),
                            const SizedBox(height: 20),
                          ],
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

  // ========== BUILD ATTENDANCE REPORT CARD ==========
  Widget _buildAttendanceReportCard() {
    final data = controller.reportData;
    if (data == null) return const SizedBox.shrink();

    final summary = data.attendanceSummary;
    if (summary == null) return const SizedBox.shrink();

    final stats = data.attendanceStats ?? [];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.people, size: 18, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Total Students: ${summary.totalStudents ?? 0}',
                  style: Styles.darkBlcW70014.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(120, 120),
                            painter: DonutChartPainter(
                              present: summary.present?.count ?? 0,
                              absent: summary.absent?.count ?? 0,
                              leave: summary.leave?.count ?? 0,
                              late: summary.late?.count ?? 0,
                              halfDay: summary.halfDay?.count ?? 0,
                              total: summary.totalStudents ?? 1,
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${summary.overallAttendancePercentage ?? 0}%',
                                  style: Styles.darkBlcW70020,
                                ),
                                Text('Attendance', style: Styles.darkBlueW40010),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: stats.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 6),
                      child: Row(
                        children: [
                          Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  color: item.colorValue, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(item.label ?? '',
                                  style: Styles.darkBlueW400)),
                          Text('${item.count ?? 0} (${item.percentage ?? 0}%)',
                              style: Styles.darkBlcW600),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== BUILD DEFAULTERS LIST ==========
  Widget _buildDefaultersList() {
    final defaulters = controller.topDefaulters;
    if (defaulters == null || defaulters.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text('No defaulters found',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: defaulters.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade200, height: 1),
        itemBuilder: (context, index) {
          final item = defaulters[index];
          return _buildDefaulterItem(item);
        },
      ),
    );
  }

  Widget _buildDefaulterItem(TopDefaulter item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                item.initials ?? '?',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: item.statusColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.studentName ?? 'Unknown',
                    style: Styles.darkBlcW60015),
                Text('Roll: ${item.rollNumber ?? 'N/A'}',
                    style: Styles.darkBlueW400),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.attendancePercentage ?? 0}%',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: item.statusColor)),
              Text('${item.presentDays ?? 0}/${item.totalDays ?? 0} days',
                  style: Styles.darkBlueW40010),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // ========== BUILD SECTION MENU ITEMS WITH DIVIDER ==========
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

  // ========== BUILD CLASS MENU ITEMS WITH DIVIDER ==========
  List<PopupMenuEntry<String>> _buildClassMenuItems(List<dynamic> classes) {
    final List<PopupMenuEntry<String>> items = [];

    for (int i = 0; i < classes.length; i++) {
      final classItem = classes[i];
      items.add(
        PopupMenuItem<String>(
          value: '${classItem.className} - ${classItem.sectionName}',
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

}

// ========== MONTH PICKER DIALOG ==========
class MonthPickerDialog extends StatefulWidget {
  final DateTime initialSelectedDate;
  const MonthPickerDialog({super.key, required this.initialSelectedDate});

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int _viewingYear;

  @override
  void initState() {
    super.initState();
    _viewingYear = widget.initialSelectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                _viewingYear--;
              });
            },
          ),
          Text(
            '$_viewingYear',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                _viewingYear++;
              });
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(12, (index) {
            final month = index + 1;
            // 👇 Check karo ki ye month aur year currently selected hai ya nahi
            bool isSelected = _viewingYear == widget.initialSelectedDate.year &&
                month == widget.initialSelectedDate.month;

            return GestureDetector(
              onTap: () {
                // Selected month return karo
                Navigator.pop(context, DateTime(_viewingYear, month, 1));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _monthName(month),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// ========== DONUT CHART PAINTER (unchanged) ==========
class DonutChartPainter extends CustomPainter {
  final int present;
  final int absent;
  final int leave;
  final int late;
  final int halfDay;
  final int total;

  DonutChartPainter({
    required this.present,
    required this.absent,
    required this.leave,
    required this.late,
    required this.halfDay,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 20.0;

    final List<Map<String, dynamic>> segments = [
      {'value': present.toDouble(), 'color': Colors.green},
      {'value': absent.toDouble(), 'color': Colors.red},
      {'value': leave.toDouble(), 'color': Colors.orange},
      {'value': late.toDouble(), 'color': Colors.blue},
      {'value': halfDay.toDouble(), 'color': Colors.purple},
    ];

    double startAngle = -90 * (3.141592653589793 / 180);

    for (var segment in segments) {
      final sweepAngle = (segment['value'] / total) * 2 * 3.141592653589793;

      final paint = Paint()
        ..color = segment['color']
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}