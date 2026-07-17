import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/class_attendance_response.dart';
import '../../../domain/models/my_classes_response.dart';
import 'mark_attendance_presenter.dart';

class MarkAttendanceController extends GetxController {
  MarkAttendanceController(this.markAttendancePresenter);

  final MarkAttendancePresenter markAttendancePresenter;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var teacherClassData = Rxn<TeacherClassesResponse>();
  var classAttendanceData = Rxn<ClassAttendanceResponse>();

  // Grouped class data
  var classGroups = <String, List<ClassItem>>{}.obs;
  var classNames = <String>[].obs;
  var selectedClassId = ''.obs;
  var selectedSectionId = ''.obs;
  var selectedClassName = ''.obs;
  var selectedSectionName = ''.obs;

  // Store all students
  var allStudents = <AttendanceStudent>[].obs;

  // Flag: true if attendance already marked for this class
  var isAttendanceAlreadyMarked = false.obs;

  // Pagination
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var perPages = 10.obs;
  var totalStudents = 0.obs;
  var hasMoreData = false.obs;

  // ==================== HARDCODED (replace later) ====================
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
      print("📡📡📡 getMyClassData START");

      var res = await markAttendancePresenter.getMyClassData(
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

    if (classNames.isNotEmpty) {
      selectedClassId.value = classNames.first;
      final sections = map[classNames.first]!;
      if (sections.isNotEmpty) {
        selectedSectionId.value = sections.first.sectionId;
        selectedClassName.value = sections.first.className;
        selectedSectionName.value = sections.first.sectionName;
        _fetchAttendanceForCurrentSelection();
      } else {
        print("⚠️ No sections for class ${classNames.first}");
      }
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
      getClassAttendanceData(
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
        perPage: 10,
        isLoadMore: false,
      );
    }
  }

  // ========== GET CLASS ATTENDANCE ==========
  Future<void> getClassAttendanceData({
    required String classId,
    required String sectionId,
    int perPage = 10,
    bool isLoadMore = false,
  }) async {
    if (classId.isEmpty || sectionId.isEmpty) return;

    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        allStudents.clear();
        currentPage.value = 1;
        isAttendanceAlreadyMarked.value = false;
      }

      final now = DateTime.now();
      final attendanceDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      var res = await markAttendancePresenter.getClassAttendance(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        attendanceDate: attendanceDate,
        classId: classId,
        sectionId: sectionId,
        perPage: perPage,
        page: currentPage.value,
      );

      if (res != null && res.status == true && res.data != null) {
        classAttendanceData.value = res;
        currentPage.value = res.data!.currentPage ?? 1;
        lastPage.value = res.data!.lastPage ?? 1;
        perPages.value = res.data!.perPage ?? 10;
        totalStudents.value = res.data!.total ?? res.data!.students?.length ?? 0;
        hasMoreData.value = currentPage.value < lastPage.value;

        if (res.data!.students != null) {
          final studentsList = res.data!.students!;
          for (var student in studentsList) {
            // If currentStatus is null (not marked), set default to PRESENT
            if (student.currentStatus == null || student.currentStatus!.isEmpty) {
              student.currentStatus = 'PRESENT';
            }
          }
          if (isLoadMore) {
            allStudents.addAll(studentsList);
          } else {
            allStudents.value = studentsList;
          }
          // Check if all students have a status (i.e., already marked)
          isAttendanceAlreadyMarked.value = allStudents.every((s) => s.currentStatus != null && s.currentStatus!.isNotEmpty);
        }
        print("✅ Attendance loaded, students: ${allStudents.length}, already marked: ${isAttendanceAlreadyMarked.value}");
      } else {
        print("❌ Failed to load attendance: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getClassAttendanceData: $e");
    } finally {
      if (isLoadMore) isLoadingMore.value = false;
      else isLoading.value = false;
    }
  }

  // ========== SAVE ATTENDANCE ==========
  Future<void> saveAttendance() async {
    // If already marked, prevent save
    if (isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked for this class.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

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

      final now = DateTime.now();
      final attendanceDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> attendanceData = [];
      for (var student in students) {
        attendanceData.add({
          'student_id': student.studentId,
          'status': _getBackendStatus(student.currentStatus),
          'remarks': student.remarks ?? '', // ✅ include note
        });
      }

      final payload = {
        'attendance_date': attendanceDate,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
        'attendances': attendanceData,
      };

      isLoading.value = true;

      var res = await markAttendancePresenter.saveAttendance(
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
        isAttendanceAlreadyMarked.value = true;
        var repo = Get.find<DeviceRepository>();
        await repo.saveValueSecurely(DeviceConstants.lastAttendanceClassId, selectedClassId.value);
        await repo.saveValueSecurely(DeviceConstants.lastAttendanceSectionId, selectedSectionId.value);
        await repo.saveValueSecurely(DeviceConstants.lastAttendanceDate, attendanceDate);

        Get.back();
        Get.snackbar('Success', res.message ?? 'Attendance saved!',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', res.message ?? 'Failed to save.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("❌ Error saving: $e");
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  String _getBackendStatus(String? status) {
    if (status == null) return '';
    switch (status.toUpperCase()) {
      case 'PRESENT': return 'PRESENT';
      case 'ABSENT': return 'ABSENT';
      case 'LATE': return 'LATE';
      case 'HALF_DAY': return 'HALF DAY';
      case 'LEAVE': return 'LEAVE';
      default: return status.toUpperCase();
    }
  }

  // ========== LOAD MORE ==========
  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value) return;
    if (selectedClassId.isEmpty || selectedSectionId.isEmpty) return;
    currentPage.value++;
    await getClassAttendanceData(
      classId: selectedClassId.value,
      sectionId: selectedSectionId.value,
      perPage: perPages.value,
      isLoadMore: true,
    );
  }

  // ========== GETTERS ==========
  List<ClassItem>? get classList => teacherClassData.value?.data?.classes;
  bool get hasMorePages => hasMoreData.value;
  int get totalStudentCount => totalStudents.value > 0 ? totalStudents.value : allStudents.length;
  List<AttendanceStudent>? get attendanceStudents => allStudents;
  bool get isLoadingData => isLoading.value;
  bool get isLoadingMoreData => isLoadingMore.value;
}