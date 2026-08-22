// edit_attendance_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/get_student_attendance_response.dart';
import '../../../domain/models/my_classes_response.dart';
import 'edit_attendance_presenter.dart';

class EditAttendanceController extends GetxController {
  EditAttendanceController(this.editAttendancePresenter);

  final EditAttendancePresenter editAttendancePresenter;

  // ========== LOADING ==========
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  // ========== CLASS DATA ==========
  var teacherClassData = Rxn<TeacherClassesResponse>();
  var classGroups = <String, List<ClassItem>>{}.obs;
  var classNames = <String>[].obs;
  var selectedClassId = ''.obs;
  var selectedSectionId = ''.obs;
  var selectedClassName = ''.obs;
  var selectedSectionName = ''.obs;

  // ========== STUDENTS ==========
  var allStudents = <StudentAttendance>[].obs;

  // ========== STORED SELECTION (from shared prefs) ==========
  String? storedClassId;
  String? storedSectionId;
  String? storedDate;

  // ========== ORIGINAL STATUSES & REMARKS FOR REVERT ==========
  final Map<String, String> originalStatuses = {};
  final Map<String, String> originalRemarks = {};

  // ========== ATTENDANCE MARKED FLAG ==========
  var isAttendanceMarkedForToday = false.obs;
  var attendanceStatusMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getMyClassData();
    ever(teacherClassData, (_) => buildClassGroups());
  }

  // ========== GET MY CLASSES ==========
  Future<void> getMyClassData() async {
    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var res = await editAttendancePresenter.getMyClassData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );

      if (res != null && res.status == true && res.data != null) {
        teacherClassData.value = res;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load classes.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading classes.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== BUILD CLASS GROUPS ==========
  void buildClassGroups() {
    final classes = teacherClassData.value?.data?.classes;
    if (classes == null || classes.isEmpty) {
      debugPrint("⚠️ No classes found to group");
      return;
    }
    Map<String, List<ClassItem>> map = {};
    for (var item in classes) {
      if (!map.containsKey(item.classId)) {
        map[item.classId] = [];
      }
      map[item.classId]!.add(item);
    }
    classGroups.value = map;
    classNames.value = map.keys.toList();

    if (classNames.isNotEmpty) {
      if (selectedClassId.value.isEmpty || !classNames.contains(selectedClassId.value)) {
        selectedClassId.value = classNames.first;
      }
      final sections = map[selectedClassId.value]!;
      if (sections.isNotEmpty) {
        bool sectionValid = sections.any((s) => s.sectionId == selectedSectionId.value);
        if (!sectionValid) {
          selectedSectionId.value = sections.first.sectionId;
          selectedSectionName.value = sections.first.sectionName;
          selectedClassName.value = sections.first.className;
        } else {
          final selected = sections.firstWhere((s) => s.sectionId == selectedSectionId.value);
          selectedClassName.value = selected.className;
          selectedSectionName.value = selected.sectionName;
        }
        _fetchAttendanceForCurrentSelection();
      } else {
        selectedSectionId.value = '';
        selectedClassName.value = '';
        selectedSectionName.value = '';
      }
    } else {
      selectedClassId.value = '';
      selectedSectionId.value = '';
      selectedClassName.value = '';
      selectedSectionName.value = '';
    }

    _loadStoredDataAndSetSelection();
  }

  // ========== LOAD STORED DATA & SET DEFAULT SELECTION ==========
  Future<void> _loadStoredDataAndSetSelection() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      storedClassId = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceClassId);
      storedSectionId = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceSectionId);
      storedDate = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceDate);

      if (classNames.isEmpty) return;

      if (storedClassId != null && storedClassId!.isNotEmpty && classGroups.containsKey(storedClassId)) {
        final sections = classGroups[storedClassId]!;
        if (sections.isNotEmpty) {
          selectedClassId.value = storedClassId!;
          if (storedSectionId != null && storedSectionId!.isNotEmpty && sections.any((s) => s.sectionId == storedSectionId)) {
            selectedSectionId.value = storedSectionId!;
            final selected = sections.firstWhere((s) => s.sectionId == storedSectionId);
            selectedClassName.value = selected.className;
            selectedSectionName.value = selected.sectionName;
          } else {
            selectedSectionId.value = sections.first.sectionId;
            selectedClassName.value = sections.first.className;
            selectedSectionName.value = sections.first.sectionName;
          }
          _fetchAttendanceForCurrentSelection();
          return;
        }
      }

      final firstClassId = classNames.first;
      selectedClassId.value = firstClassId;
      final sections = classGroups[firstClassId]!;
      if (sections.isNotEmpty) {
        selectedSectionId.value = sections.first.sectionId;
        selectedClassName.value = sections.first.className;
        selectedSectionName.value = sections.first.sectionName;
        _fetchAttendanceForCurrentSelection();
      }
    } catch (e) {
      debugPrint("❌ Error loading stored data: $e");
    }
  }

  // ========== CLASS SELECTION ==========
  void onClassSelected(String classId) {
    if (!classGroups.containsKey(classId)) return;
    selectedClassId.value = classId;
    final sections = classGroups[classId]!;
    if (sections.isNotEmpty) {
      selectedSectionId.value = sections.first.sectionId;
      selectedClassName.value = sections.first.className;
      selectedSectionName.value = sections.first.sectionName;
      _fetchAttendanceForCurrentSelection();
    } else {
      selectedSectionId.value = '';
      selectedClassName.value = '';
      selectedSectionName.value = '';
    }
  }

  void onSectionSelected(String sectionId) {
    final classItems = classGroups[selectedClassId.value];
    if (classItems != null) {
      final selected = classItems.firstWhere((item) => item.sectionId == sectionId);
      selectedSectionId.value = sectionId;
      selectedClassName.value = selected.className;
      selectedSectionName.value = selected.sectionName;
      _fetchAttendanceForCurrentSelection();
    }
  }

  // ========== FETCH WITH DATE FALLBACK ==========
  void _fetchAttendanceForCurrentSelection() {
    if (selectedClassId.value.isNotEmpty && selectedSectionId.value.isNotEmpty) {
      final date = (storedDate != null && storedDate!.isNotEmpty)
          ? storedDate!
          : _getCurrentDate();
      getClassAttendanceData(
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
        date: date,
      );
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // ========== GET CLASS ATTENDANCE DATA ==========
  Future<void> getClassAttendanceData({
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    String effectiveDate = (date.isNotEmpty) ? date : _getCurrentDate();

    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var res = await editAttendancePresenter.getStudentListData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: effectiveDate,
      );

      if (res != null && res.status == true && res.data != null) {
        allStudents.value = res.data!;

        // ---------- STORE ORIGINAL STATUSES & REMARKS ----------
        originalStatuses.clear();
        originalRemarks.clear();
        for (var student in allStudents) {
          final status = student.attendance?.status ?? '';
          final remarks = student.attendance?.remarks ?? '';
          originalStatuses[student.studentId] = status;
          originalRemarks[student.studentId] = remarks;
        }

        // ---------- CHECK IF ATTENDANCE IS MARKED ----------
        if (allStudents.isNotEmpty) {
          bool marked = allStudents.any((s) =>
          s.attendance != null &&
              s.attendance!.status != null &&
              s.attendance!.status!.isNotEmpty);
          isAttendanceMarkedForToday.value = marked;
          if (!marked) {
            attendanceStatusMessage.value = 'You haven\'t marked attendance for today yet. Please mark attendance first.';
          } else {
            attendanceStatusMessage.value = '';
          }
        } else {
          isAttendanceMarkedForToday.value = false;
          attendanceStatusMessage.value = 'No students found for this class/section.';
        }

        for (var student in allStudents) {
          debugPrint("📚 ${student.fullName}: ${student.attendance?.status ?? 'Not Marked'}");
        }
      } else {
        // Error or no data
        allStudents.clear();
        isAttendanceMarkedForToday.value = false;
        attendanceStatusMessage.value = 'No attendance data found.';
        if (res?.message != null && !res!.message.toLowerCase().contains('attendance date is required')) {
          Get.snackbar(
            'Error',
            res.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ getClassAttendanceData error: $e');
      allStudents.clear();
      isAttendanceMarkedForToday.value = false;
      attendanceStatusMessage.value = 'Failed to load attendance data.';
    } finally {
      isLoading.value = false;
    }
  }

  // ========== UPDATE STUDENT ATTENDANCE ==========
  void updateStudentAttendance(int index, String status) {
    if (index < allStudents.length) {
      final student = allStudents[index];
      final currentAttendance = student.attendance;

      AttendanceInfo? newAttendance;
      if (currentAttendance?.status?.toUpperCase() == status.toUpperCase()) {
        newAttendance = null;
      } else {
        newAttendance = AttendanceInfo(
          attendanceId: currentAttendance?.attendanceId,
          attendanceDate: currentAttendance?.attendanceDate,
          status: status.toUpperCase(),
          remarks: currentAttendance?.remarks,
          markedAt: currentAttendance?.markedAt,
        );
      }

      final updatedStudent = StudentAttendance(
        studentId: student.studentId,
        registrationNumber: student.registrationNumber,
        admissionNumber: student.admissionNumber,
        rollNumber: student.rollNumber,
        fullName: student.fullName,
        photo: student.photo,
        classInfo: student.classInfo,
        sectionInfo: student.sectionInfo,
        attendance: newAttendance,
      );

      allStudents[index] = updatedStudent;
      allStudents.refresh();
    }
  }

  // ---------- REVERT ALL CHANGES ----------
  void revertChanges() {
    for (int i = 0; i < allStudents.length; i++) {
      final student = allStudents[i];
      final originalStatus = originalStatuses[student.studentId] ?? '';
      final originalRemarksValue = originalRemarks[student.studentId] ?? '';

      AttendanceInfo? newAttendance;
      if (originalStatus.isEmpty && originalRemarksValue.isEmpty) {
        newAttendance = null;
      } else {
        final currentAttendance = student.attendance;
        newAttendance = AttendanceInfo(
          attendanceId: currentAttendance?.attendanceId,
          attendanceDate: currentAttendance?.attendanceDate,
          status: originalStatus,
          remarks: originalRemarksValue,
          markedAt: currentAttendance?.markedAt,
        );
      }

      final updatedStudent = StudentAttendance(
        studentId: student.studentId,
        registrationNumber: student.registrationNumber,
        admissionNumber: student.admissionNumber,
        rollNumber: student.rollNumber,
        fullName: student.fullName,
        photo: student.photo,
        classInfo: student.classInfo,
        sectionInfo: student.sectionInfo,
        attendance: newAttendance,
      );

      allStudents[i] = updatedStudent;
    }
    allStudents.refresh();
  }

  // ---------- COMPUTE STATUS COUNTS FOR DIALOG ----------
  Map<String, int> getStatusCounts() {
    Map<String, int> counts = {};
    for (var student in allStudents) {
      final status = student.attendance?.status;
      if (status != null && status.isNotEmpty) {
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }
    return counts;
  }

  // ---------- CHECK IF ANY CHANGES ----------
  bool hasChanges() {
    for (var student in allStudents) {
      final currentStatus = student.attendance?.status ?? '';
      final originalStatus = originalStatuses[student.studentId] ?? '';
      final currentRemarks = student.attendance?.remarks ?? '';
      final originalRemarksValue = originalRemarks[student.studentId] ?? '';
      if (currentStatus != originalStatus || currentRemarks != originalRemarksValue) {
        return true;
      }
    }
    return false;
  }

  // ========== UPDATE ATTENDANCE ==========
  Future<void> updateAttendance() async {
    try {
      if (selectedClassId.isEmpty || selectedSectionId.isEmpty) {
        Get.snackbar('Error', 'Class or Section not selected.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final students = allStudents;
      if (students.isEmpty) {
        Get.snackbar('Error', 'No students found.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final String attendanceDate = (storedDate != null && storedDate!.isNotEmpty)
          ? storedDate!
          : _getCurrentDate();

      final List<Map<String, dynamic>> attendanceData = [];
      for (var student in students) {
        String status = student.attendance?.status ?? '';
        if (status.isEmpty) status = 'PRESENT';
        attendanceData.add({
          'student_id': student.studentId,
          'status': _getBackendStatus(status),
          'remarks': student.attendance?.remarks ?? '',
        });
      }

      final payload = {
        'attendance_date': attendanceDate,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
        'attendances': attendanceData,
      };

      isLoading.value = true;

      var res = await editAttendancePresenter.updateAttendance(
        isLoading: true,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res == null) {
        Get.snackbar('Error', 'No response from server.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      if (res.status == true) {
        Get.back();
        Get.snackbar('Success', res.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', res.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== STATUS CONVERTER ==========
  String _getBackendStatus(String? status) {
    if (status == null) return 'PRESENT';
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return 'PRESENT';
      case 'ABSENT':
        return 'ABSENT';
      case 'LATE':
        return 'LATE';
      case 'HALF DAY':
        return 'HALF_DAY';
      case 'LEAVE':
        return 'LEAVE';
      default:
        return status.toUpperCase();
    }
  }

  // ========== UPDATE STUDENT NOTE ==========
  void updateStudentNote(int index, String note) {
    if (index < allStudents.length) {
      final student = allStudents[index];
      final currentAttendance = student.attendance;

      AttendanceInfo newAttendance;
      if (currentAttendance == null) {
        newAttendance = AttendanceInfo(
          attendanceId: null,
          attendanceDate: null,
          status: 'PRESENT',
          remarks: note,
          markedAt: null,
        );
      } else {
        newAttendance = AttendanceInfo(
          attendanceId: currentAttendance.attendanceId,
          attendanceDate: currentAttendance.attendanceDate,
          status: currentAttendance.status,
          remarks: note,
          markedAt: currentAttendance.markedAt,
        );
      }

      final updatedStudent = StudentAttendance(
        studentId: student.studentId,
        registrationNumber: student.registrationNumber,
        admissionNumber: student.admissionNumber,
        rollNumber: student.rollNumber,
        fullName: student.fullName,
        photo: student.photo,
        classInfo: student.classInfo,
        sectionInfo: student.sectionInfo,
        attendance: newAttendance,
      );

      allStudents[index] = updatedStudent;
      allStudents.refresh();
    }
  }

  // ========== GET ATTENDANCE OPTIONS ==========
  List<String> getAttendanceOptions() {
    return ['PRESENT', 'ABSENT', 'LATE', 'HALF DAY', 'LEAVE'];
  }

  // ========== GETTERS ==========
  List<StudentAttendance> get students => allStudents;
  bool get hasData => allStudents.isNotEmpty;
  int get totalStudents => allStudents.length;
  String get attendanceDate => storedDate ?? '';
  String get className => selectedClassName.value.isNotEmpty ? selectedClassName.value : '';
  String get sectionName => selectedSectionName.value.isNotEmpty ? selectedSectionName.value : '';
  List<ClassItem>? get classList => teacherClassData.value?.data?.classes;
  bool get isAttendanceMarked => isAttendanceMarkedForToday.value;
  String get attendanceMessage => attendanceStatusMessage.value;
}