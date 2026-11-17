import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/staff_attendance_record/staff_attendance_record_controller.dart';
import 'package:school_app/app/pages/staff_attendance_record/staff_attendance_record_presenter.dart';
import '../../utils/asset_constants.dart';
import '../../../domain/usecases/home_usecases.dart';

class StaffAttendanceRecordScreen extends StatelessWidget {
  const StaffAttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StaffAttendanceRecordController controller = Get.put(
      StaffAttendanceRecordController(
        StaffAttendanceRecordPresenter(Get.find<HomeUseCases>()),
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight * 0.48;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          // ===== 1. BLUE BACKGROUND IMAGE =====
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

          // ===== 2. MAIN CONTENT =====
          SafeArea(
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Attendance Record',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // --- TOP DESIGN ---
                _buildTopSummary(controller),

                const SizedBox(height: 20),

                // --- CALENDAR & LEGEND ---
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1E293B),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                      child: Column(
                        children: [
                          _buildCalendarSection(controller),
                          const SizedBox(height: 20),
                          _buildLegend(),
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

  // ================= TOP SUMMARY DESIGN (With Half Day Added) =================
  Widget _buildTopSummary(StaffAttendanceRecordController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Side: Big Present Circle Card
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PRESENT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Obx(() => CircularProgressIndicator(
                            value: controller.overallPercentage.value / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4ADE80),
                            ),
                            strokeCap: StrokeCap.round,
                          )),
                        ),
                        Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${controller.presentCount.value}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'of ${controller.workingDaysCount.value} days',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right Side: Grid (Now 3 rows to fit 5 items)
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSmallInfoCard('${controller.workingDaysCount.value}', 'Working days'),
                        const SizedBox(width: 10),
                        _buildSmallInfoCard('${controller.lateCount.value}', 'Late arrivals'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSmallInfoCard('${controller.leaveCount.value}', 'On leave'),
                        const SizedBox(width: 10),
                        _buildSmallInfoCard('${controller.absentCount.value}', 'Absent'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Added Half Day Row
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSmallInfoCard('${controller.halfDayCount.value}', 'Half Day'),
                        const SizedBox(width: 10),
                        const Expanded(child: SizedBox()), // Empty space to keep grid alignment
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallInfoCard(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ================= CALENDAR SECTION =================
  Widget _buildCalendarSection(StaffAttendanceRecordController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.grey),
                onPressed: () => controller.previousMonth(),
              ),
              Obx(() => Text(
                controller.monthName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              )),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.grey),
                onPressed: () => controller.nextMonth(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('M', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('W', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('F', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // Calendar Grid
          Obx(() {
            int totalDays = controller.daysInMonth;
            int offset = controller.firstWeekdayOfMonth;
            int totalCells = totalDays + offset;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox.shrink();
                }

                int day = index - offset + 1;
                String status = controller.getStatusForDay(day);

                return _buildDayCell(day, status);
              },
            );
          }),
        ],
      ),
    );
  }

  // ================= DAY CELL (With Beautiful Colors) =================
  Widget _buildDayCell(int dayNumber, String status) {
    Color bgColor = Colors.white;
    Color textColor = const Color(0xFF64748B); // Default Grey
    Border? border;

    switch (status.toLowerCase()) {
      case 'present':
        bgColor = const Color(0xFF0D7B5E); // Dark Green
        textColor = Colors.white;
        break;
      case 'absent':
        bgColor = Colors.white;
        textColor = const Color(0xFFD92D20); // Red Text
        border = Border.all(color: const Color(0xFFD92D20), width: 1.5); // Red Border
        break;
      case 'late':
        bgColor = const Color(0xFFF97316); // Orange
        textColor = Colors.white;
        break;
      case 'half_day':
      case 'half day':
      case 'halfday':
        bgColor = const Color(0xFFFBBF24); // Amber / Yellow
        textColor = Colors.white;
        break;
      case 'leave':
        bgColor = const Color(0xFF1D4ED8); // Dark Blue
        textColor = Colors.white;
        break;
      case 'holiday':
        bgColor = const Color(0xFFF0F9FF); // Light Blue
        textColor = const Color(0xFF64748B);
        break;
      default: // Not marked / Future
        bgColor = Colors.transparent;
        textColor = const Color(0xFF64748B);
        border = Border.all(color: Colors.grey.shade300, width: 1);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      child: Center(
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ================= LEGEND (With Half Day Added) =================
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildLegendItem(const Color(0xFF0D7B5E), 'Present'),
          _buildLegendItem(const Color(0xFFF97316), 'Late arrival'),
          _buildLegendItem(const Color(0xFFFBBF24), 'Half Day'), // ✅ Added Half Day
          _buildLegendItem(Colors.white, 'Absent', borderColor: const Color(0xFFD92D20)),
          _buildLegendItem(const Color(0xFF1D4ED8), 'On leave'),
          _buildLegendItem(const Color(0xFFF0F9FF), 'Holiday', borderColor: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, {Color? borderColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}