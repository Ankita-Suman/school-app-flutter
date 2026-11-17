import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/asset_constants.dart';
import 'attendance_record_controller.dart';
import 'attendance_record_presenter.dart';
import '../../../domain/usecases/home_usecases.dart'; // ✅ इसे इम्पोर्ट करें

class AttendanceRecordScreen extends StatelessWidget {
  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Presenter को HomeUseCases के साथ इनिशियलाइज़ करें
    final AttendanceRecordController controller = Get.put(
      AttendanceRecordController(
        AttendanceRecordPresenter(Get.find<HomeUseCases>()),
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

                const SizedBox(height: 20),

                // --- OVERALL PROGRESS ---
                _buildOverallProgress(controller),

                const SizedBox(height: 20),

                // --- STATS ROW ---
                _buildStatsRow(controller),

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
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
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

  Widget _buildOverallProgress(AttendanceRecordController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Obx(() => CircularProgressIndicator(
            value: controller.overallPercentage.value / 100,
            strokeWidth: 12,
            backgroundColor: Colors.white.withOpacity(0.15),
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
              '${controller.overallPercentage.value}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const Text(
              'OVERALL',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white70,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildStatsRow(AttendanceRecordController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => _buildStatItem('${controller.presentCount.value}', 'Present')),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.2)),
          Obx(() => _buildStatItem('${controller.absentCount.value}', 'Absent')),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.2)),
          Obx(() => _buildStatItem('${controller.halfDayCount.value}', 'Half Day')),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(AttendanceRecordController controller) {
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
          const SizedBox(height: 16),
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

  Widget _buildDayCell(int dayNumber, String status) {
    Color bgColor = Colors.transparent;
    Color textColor = const Color(0xFF1E293B);

    // API से आने वाले स्टेटस के अनुसार रंग
    switch (status.toLowerCase()) {
      case 'present':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        break;
      case 'absent':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      case 'half_day':
      case 'half day':
      case 'halfday':
        bgColor = const Color(0xFFFFEDD5);
        textColor = const Color(0xFFEA580C);
        break;
      case 'leave':
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF2563EB);
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.05);
        textColor = const Color(0xFF64748B);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
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

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(const Color(0xFF4ADE80), 'Present'),
          _buildLegendItem(const Color(0xFFF87171), 'Absent'),
          _buildLegendItem(const Color(0xFFFBBF24), 'Half Day'),
          _buildLegendItem(const Color(0xFF60A5FA), 'Leave'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}