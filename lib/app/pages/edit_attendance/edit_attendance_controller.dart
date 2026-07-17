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

  // ========== HARDCODED (replace later) ==========
  final String hardcodedToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODQxODA2ODgsImV4cCI6MTc4NDM1MzQ4OCwibmJmIjoxNzg0MTgwNjg4LCJqdGkiOiJKY3IzSmVOdmVWVk5TMllMIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.Mdpb7QcnglMLL5B5cph0vKDQQ546iY0I_YkJA-Cl82E';
  final String hardcodedBranchId = '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a';

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
      print("📡📡📡 EditAttendance - getMyClassData START");

      var res = await editAttendancePresenter.getMyClassData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
      );

      if (res != null && res.status == true && res.data != null) {
        teacherClassData.value = res;
        print("✅ My Classes loaded successfully");
      } else {
        print("❌ Failed to load classes: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getMyClassData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== BUILD CLASS GROUPS ==========
  void buildClassGroups() {
    final classes = teacherClassData.value?.data?.classes;
    if (classes == null || classes.isEmpty) {
      print("⚠️ No classes found to group");
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
    print("📦 Class groups built: ${classNames.length} classes");

    _loadStoredDataAndSetSelection();
  }

  // ========== LOAD STORED DATA & SET DEFAULT SELECTION ==========
  Future<void> _loadStoredDataAndSetSelection() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      storedClassId = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceClassId) ?? '';
      storedSectionId = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceSectionId) ?? '';
      storedDate = await deviceRepo.getSecuredValue(DeviceConstants.lastAttendanceDate) ?? '';

      print("📦📦📦 Stored Data Loaded:");
      print("Class ID: $storedClassId");
      print("Section ID: $storedSectionId");
      print("Date: $storedDate");

      if (classNames.isEmpty) {
        print("❌ No classes available");
        return;
      }

      if (storedClassId != null && storedClassId!.isNotEmpty && classGroups.containsKey(storedClassId)) {
        selectedClassId.value = storedClassId!;
        final sections = classGroups[storedClassId]!;
        if (sections.isNotEmpty) {
          if (storedSectionId != null && storedSectionId!.isNotEmpty) {
            final sectionExists = sections.any((item) => item.sectionId == storedSectionId);
            if (sectionExists) {
              selectedSectionId.value = storedSectionId!;
              final selected = sections.firstWhere((item) => item.sectionId == storedSectionId);
              selectedClassName.value = selected.className;
              selectedSectionName.value = selected.sectionName;
            } else {
              selectedSectionId.value = sections.first.sectionId;
              selectedClassName.value = sections.first.className;
              selectedSectionName.value = sections.first.sectionName;
            }
          } else {
            selectedSectionId.value = sections.first.sectionId;
            selectedClassName.value = sections.first.className;
            selectedSectionName.value = sections.first.sectionName;
          }
        }
      } else {
        final firstClassId = classNames.first;
        selectedClassId.value = firstClassId;
        final sections = classGroups[firstClassId]!;
        if (sections.isNotEmpty) {
          selectedSectionId.value = sections.first.sectionId;
          selectedClassName.value = sections.first.className;
          selectedSectionName.value = sections.first.sectionName;
        }
      }

      print("✅ Default selection set: ${selectedClassName.value} - ${selectedSectionName.value}");
      _fetchAttendanceForCurrentSelection();

    } catch (e) {
      print("❌ Error loading stored data: $e");
    }
  }

  // ========== CLASS SELECTION ==========
  void onClassSelected(String classId) {
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
    selectedSectionId.value = sectionId;
    final classItems = classGroups[selectedClassId.value];
    if (classItems != null) {
      final selected = classItems.firstWhere((item) => item.sectionId == sectionId);
      selectedClassName.value = selected.className;
      selectedSectionName.value = selected.sectionName;
      _fetchAttendanceForCurrentSelection();
    }
  }

  void _fetchAttendanceForCurrentSelection() {
    if (selectedClassId.value.isNotEmpty && selectedSectionId.value.isNotEmpty) {
      final date = storedDate ?? _getCurrentDate();
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
    try {
      isLoading.value = true;
      print("📡📡📡 EditAttendance - getClassAttendanceData START");
      print("📚 Class ID: $classId, Section ID: $sectionId, Date: $date");

      var res = await editAttendancePresenter.getStudentListData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        classId: classId,
        sectionId: sectionId,
        date: date,
      );

      if (res != null && res.status == true && res.data != null) {
        allStudents.value = res.data!;
        print("✅ Students loaded: ${allStudents.length}");
        for (var student in allStudents) {
          print("📚 ${student.fullName}: ${student.attendance?.status ?? 'Not Marked'}");
        }
      } else {
        print("❌ Failed to load attendance: ${res?.message}");
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load attendance data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error in getClassAttendanceData: $e");
      Get.snackbar(
        'Error',
        'Something went wrong while loading attendance.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  // ========== UPDATE ATTENDANCE (no orange alert) ==========
  Future<void> updateAttendance() async {
    try {
      if (selectedClassId.isEmpty || selectedSectionId.isEmpty) {
        Get.snackbar('Error', 'Class or Section not selected.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final students = allStudents;
      if (students.isEmpty) {
        Get.snackbar('Error', 'No students found.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // ✅ No unmarked check – all students are guaranteed to have a status
      // (either from API or defaulted to PRESENT)

      final now = DateTime.now();
      final attendanceDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> attendanceData = [];
      for (var student in students) {
        // Use the status from attendance object; if null (shouldn't happen), fallback to PRESENT
        final status = student.attendance?.status ?? 'PRESENT';
        attendanceData.add({
          'student_id': student.studentId,
          'status': status,
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
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        payload: payload,
      );

      if (res == null) {
        Get.snackbar('Error', 'No response from server.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (res.status == true) {
        Get.back();
        Get.snackbar('Success', res.message ?? 'Attendance updated successfully!',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', res.message ?? 'Failed to update attendance.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("❌ Error updating attendance: $e");
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
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
}