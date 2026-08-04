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

  // ---------- original statuses/remarks for revert ----------
  final Map<String, String> originalStatuses = {};
  final Map<String, String> originalRemarks = {};

  // ---------- flag for first load ----------
  var _isFirstLoad = true.obs;

  // Expose isFirstLoad to screen
  bool get isFirstLoad => _isFirstLoad.value;

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

      var res = await markAttendancePresenter.getMyClassData(
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
      selectedClassId.value = classNames.first;
      final sections = map[classNames.first]!;
      if (sections.isNotEmpty) {
        selectedSectionId.value = sections.first.sectionId;
        selectedClassName.value = sections.first.className;
        selectedSectionName.value = sections.first.sectionName;
        _fetchAttendanceForCurrentSelection();
      } else {
        debugPrint("⚠️ No sections for class ${classNames.first}");
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
      final selected =
      classItems.firstWhere((item) => item.sectionId == sectionId);
      selectedClassName.value = selected.className;
      selectedSectionName.value = selected.sectionName;
      _fetchAttendanceForCurrentSelection();
    }
  }

  void _fetchAttendanceForCurrentSelection() {
    if (selectedClassId.value.isNotEmpty &&
        selectedSectionId.value.isNotEmpty) {
      _isFirstLoad.value = true; // mark that we are starting a fresh load
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
        originalStatuses.clear();
        originalRemarks.clear();
      }

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        if (isLoadMore) {
          isLoadingMore.value = false;
        } else {
          isLoading.value = false;
          _isFirstLoad.value = false; // no data, show empty state
        }
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final now = DateTime.now();
      final attendanceDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      var res = await markAttendancePresenter.getClassAttendance(
        isLoading: false,
        token: token,
        branchId: branchId,
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

          // ---------- CONVERT "HALF_DAY" TO "HALF DAY" FOR DISPLAY ----------
          for (var student in studentsList) {
            if (student.currentStatus != null &&
                student.currentStatus!.toUpperCase() == 'HALF_DAY') {
              student.currentStatus = 'HALF DAY';
            }
          }

          if (isLoadMore) {
            allStudents.addAll(studentsList);
          } else {
            allStudents.value = studentsList;
          }

          // Check if attendance is already marked
          isAttendanceAlreadyMarked.value = allStudents.every(
                (s) => s.currentStatus != null && s.currentStatus!.isNotEmpty,
          );

          // If NOT marked, set default status to 'PRESENT'
          if (!isAttendanceAlreadyMarked.value && allStudents.isNotEmpty) {
            for (var student in allStudents) {
              if (student.currentStatus == null || student.currentStatus!.isEmpty) {
                student.currentStatus = 'PRESENT';
              }
            }
          }

          // Store original statuses & remarks
          for (var student in allStudents) {
            originalStatuses[student.studentId] = student.currentStatus ?? '';
            originalRemarks[student.studentId] = student.remarks ?? '';
          }
        }

        // ---------- FIRST LOAD COMPLETE ----------
        if (!isLoadMore) {
          _isFirstLoad.value = false;
        }
      } else {
        allStudents.clear();
        isAttendanceAlreadyMarked.value = false;
        if (!isLoadMore) {
          _isFirstLoad.value = false;
        }
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load attendance.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      allStudents.clear();
      isAttendanceAlreadyMarked.value = false;
      if (!isLoadMore) {
        _isFirstLoad.value = false;
      }
      Get.snackbar(
        'Error',
        'Something went wrong while loading attendance.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (isLoadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  // ---------- revert all changes ----------
  void revertChanges() {
    for (var student in allStudents) {
      student.currentStatus = originalStatuses[student.studentId] ?? '';
      student.remarks = originalRemarks[student.studentId] ?? '';
    }
  }

  // ---------- compute status counts for dialog ----------
  Map<String, int> getStatusCounts() {
    Map<String, int> counts = {};
    for (var student in allStudents) {
      final status = student.currentStatus;
      if (status != null && status.isNotEmpty) {
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }
    return counts;
  }

  // ========== SAVE ATTENDANCE ==========
  Future<void> saveAttendance() async {
    if (isAttendanceAlreadyMarked.value) {
      Get.snackbar('Info', 'Attendance already marked for this class.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

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

      final now = DateTime.now();
      final attendanceDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> attendanceData = [];
      for (var student in students) {
        String status = student.currentStatus ?? '';
        if (status.isEmpty) {
          status = 'PRESENT';
        }
        // Convert display status to backend format
        String backendStatus = _getBackendStatus(status);
        attendanceData.add({
          'student_id': student.studentId,
          'status': backendStatus,
          'remarks': student.remarks ?? '',
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
        isAttendanceAlreadyMarked.value = true;
        await deviceRepo.saveValueSecurely(
            DeviceConstants.lastAttendanceClassId, selectedClassId.value);
        await deviceRepo.saveValueSecurely(
            DeviceConstants.lastAttendanceSectionId, selectedSectionId.value);
        await deviceRepo.saveValueSecurely(
            DeviceConstants.lastAttendanceDate, attendanceDate);

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
    if (status == null) return '';
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

  int get totalStudentCount =>
      totalStudents.value > 0 ? totalStudents.value : allStudents.length;

  List<AttendanceStudent>? get attendanceStudents => allStudents;

  bool get isLoadingData => isLoading.value;

  bool get isLoadingMoreData => isLoadingMore.value;
}