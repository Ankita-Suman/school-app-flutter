import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/attendance_response.dart';
import 'attendance_record_presenter.dart';

class AttendanceRecordController extends GetxController {
  AttendanceRecordController(this.attendanceRecordPresenter);

  final AttendanceRecordPresenter attendanceRecordPresenter;

  // Current viewing month and year (Default: Current Month)
  var currentDate = DateTime.now().obs;

  // Loading State
  var isLoading = false.obs;

  // Overall Stats (Reactive)
  var overallPercentage = 0.obs;
  var presentCount = 0.obs;
  var absentCount = 0.obs;
  var halfDayCount = 0.obs;

  // Calendar Data Map: 'YYYY-MM-DD' : 'Status'
  var attendanceData = <String, String>{}.obs;

  // Variables to store dynamic IDs
  var studentId = ''.obs;
  var branchId = ''.obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // स्क्रीन ओपन होते ही डेटा फेच करें
    _getUserDataAndFetchAttendance();
  }

  // --- Calendar Logic ---
  void nextMonth() {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month + 1, 1);
    fetchAttendance(); // महीना बदलते ही API हिट करें
  }

  void previousMonth() {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month - 1, 1);
    fetchAttendance(); // महीना बदलते ही API हिट करें
  }

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[currentDate.value.month - 1]} ${currentDate.value.year}';
  }

  int get daysInMonth {
    return DateTime(currentDate.value.year, currentDate.value.month + 1, 0).day;
  }

  int get firstWeekdayOfMonth {
    return DateTime(currentDate.value.year, currentDate.value.month, 1).weekday % 7;
  }

  String getStatusForDay(int day) {
    String dateStr = '${currentDate.value.year}-${currentDate.value.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    return attendanceData[dateStr] ?? '';
  }

  // ========== 1. GET DATA FROM SHARED PREFERENCES & CALL API ==========
  Future<void> _getUserDataAndFetchAttendance() async {
    try {
      isLoading.value = true;
      var deviceRepo = Get.find<DeviceRepository>();

      // SharedPreferences से डेटा निकालें
      token.value = await deviceRepo.getSecuredValue(DeviceConstants.token);
      branchId.value = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      // ⚠️ यहाँ DeviceConstants.studentId का इस्तेमाल करें (अगर आपके प्रोजेक्ट में है)
      // अगर नहीं है तो आपको 'studentId' को लॉगिन के समय SharedPreferences में सेव करना होगा।
      studentId.value = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.value.isEmpty || branchId.value.isEmpty || studentId.value.isEmpty) {
        isLoading.value = false;
        Get.snackbar('Error', 'User data missing. Please login again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // डेटा मिलने के बाद API कॉल करें
      fetchAttendance();

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load user session data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ========== 2. FETCH ATTENDANCE API ==========
  Future<void> fetchAttendance() async {
    if (token.value.isEmpty || studentId.value.isEmpty) return;

    try {
      isLoading.value = true;

      // Format Month for API (YYYY-MM)
      String formattedMonth = '${currentDate.value.year}-${currentDate.value.month.toString().padLeft(2, '0')}';

      // Presenter के ज़रिए API कॉल करें
      var res = await attendanceRecordPresenter.getAttendanceRecordAPI(
        isLoading: false,
        token: token.value,
        branchId: branchId.value,
        studentId: studentId.value,
        month: formattedMonth,
      );

      // Response प्रोसेस करें
      if (res != null && res.status == true && res.data != null) {
        _processData(res.data!);
      } else {
        _clearData();
        Get.snackbar('Error', res?.message ?? 'Failed to load attendance.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      _clearData();
      Get.snackbar('Error', 'Something went wrong while loading attendance.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== 3. PROCESS API DATA ==========
  void _processData(AttendanceData data) {
    // 1. Update Top Stats
    if (data.summary != null) {
      presentCount.value = data.summary!.present ?? 0;
      absentCount.value = data.summary!.absent ?? 0;
      halfDayCount.value = data.summary!.halfDay ?? 0;
      overallPercentage.value = data.summary!.percentage?.toInt() ?? 0;
    }

    // 2. Map Days for Calendar
    Map<String, String> newMap = {};
    if (data.days != null) {
      for (var day in data.days!) {
        if (day.date != null) {
          if (day.isFuture == true) {
            newMap[day.date!] = 'future';
          } else if (day.status != null && day.status!.isNotEmpty) {
            newMap[day.date!] = day.status!.toLowerCase();
          } else {
            newMap[day.date!] = 'not_marked';
          }
        }
      }
    }
    attendanceData.value = newMap;
  }

  void _clearData() {
    presentCount.value = 0;
    absentCount.value = 0;
    halfDayCount.value = 0;
    overallPercentage.value = 0;
    attendanceData.clear();
  }
}