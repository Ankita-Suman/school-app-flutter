import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/get_attendance_report_response.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.onDateChanged(picked);
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
                    final classNames = controller.classNames;
                    final selectedClassId = controller.selectedClassId.value;
                    final selectedSectionId = controller.selectedSectionId.value;
                    final sections = controller.classGroups[selectedClassId] ?? [];

                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                // ---------- DATE ----------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Date', style: Styles.darkBlueW400.copyWith(fontSize: 10)),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
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
                                              controller.month.isNotEmpty
                                                  ? controller.month
                                                  : _formatMonthYear(controller.selectedDate.value),
                                              style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // ---------- CLASS (only class name) ----------
                                Expanded(
                                  child: Column(
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
                                        child: Row(
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
                                            PopupMenuButton<String>(
                                              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                              padding: EdgeInsets.zero,
                                              position: PopupMenuPosition.under,
                                              offset: const Offset(0, 0),
                                              onSelected: controller.onClassChanged,
                                              itemBuilder: (context) {
                                                final allClasses = controller.classList;
                                                return allClasses?.map((classItem) {
                                                  // Display only class name, e.g. "1st", "2nd"
                                                  final displayValue = classItem.className;
                                                  return PopupMenuItem<String>(
                                                    value: '${classItem.className} - ${classItem.sectionName}',
                                                    child: Container(
                                                      width: 220,
                                                      child: Text(
                                                        displayValue,
                                                        style: Styles.darkBlcW600,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }).toList() ?? [];
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // ---------- SECTION (only section name) ----------
                                Expanded(
                                  child: Column(
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
                                        child: sections.isEmpty
                                            ? const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('--', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        )
                                            : DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectedSectionId,
                                            items: sections.map((item) {
                                              return DropdownMenuItem<String>(
                                                value: item.sectionId,
                                                child: Text(
                                                  item.sectionName,
                                                  style: Styles.darkBlcW600.copyWith(fontSize: 12),
                                                ),
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
                                  Icon(Icons.bar_chart, size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No attendance data available',
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please select a class and date',
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
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
      child: Row(
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
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: item.colorValue, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item.label ?? '', style: Styles.darkBlueW400)),
                      Text('${item.count ?? 0} (${item.percentage ?? 0}%)', style: Styles.darkBlcW600),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD DEFAULTES LIST ==========
  Widget _buildDefaultersList() {
    final defaulters = controller.topDefaulters;
    if (defaulters == null || defaulters.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text('No defaulters found', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: defaulters.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: item.statusColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.studentName ?? 'Unknown', style: Styles.darkBlcW60015),
                Text('Roll: ${item.rollNumber ?? 'N/A'}', style: Styles.darkBlueW400),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.attendancePercentage ?? 0}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: item.statusColor)),
              Text('${item.presentDays ?? 0}/${item.totalDays ?? 0} days', style: Styles.darkBlueW40010),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// ========== DONUT CHART PAINTER ==========
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
    final strokeWidth = 20.0;

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