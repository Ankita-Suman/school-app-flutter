import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/get_attendance_report_response.dart';
import '../../../domain/models/my_classes_response.dart';
import 'attendance_report_presenter.dart';

class AttendanceReportController extends GetxController {
  AttendanceReportController(this.attendanceReportPresenter);

  final AttendanceReportPresenter attendanceReportPresenter;

  var isLoading = false.obs;
  var attendanceReportResponse = Rxn<AttendanceReportResponse>();
  var teacherClassData = Rxn<TeacherClassesResponse>();

  // ========== GROUPED CLASS DATA (Reactive) ==========
  var classGroups = <String, List<ClassItem>>{}.obs;
  var classNames = <String>[].obs;
  var selectedClassId = ''.obs;
  var selectedSectionId = ''.obs;
  var selectedClassName = ''.obs;
  var selectedSectionName = ''.obs;

  // ========== DISPLAY VALUE ==========
  String get selectedClassDisplay =>
      '${selectedClassName.value} - ${selectedSectionName.value}';

  // ========== DATE ==========
  var selectedDate = DateTime.now().obs;

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

      var res = await attendanceReportPresenter.getMyClassData(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
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
      }
    }
  }

  // ========== CLASS SELECTION ==========
  void onClassChanged(String newValue) {
    final classes = classList;
    if (classes == null) return;

    final selected = classes.firstWhere(
          (item) => '${item.className} - ${item.sectionName}' == newValue,
    );

    selectedClassId.value = selected.classId;
    selectedClassName.value = selected.className;
    selectedSectionName.value = selected.sectionName;

    // Also set first section of that class as default
    final sections = classGroups[selected.classId];
    if (sections != null && sections.isNotEmpty) {
      selectedSectionId.value = sections.first.sectionId;
      selectedSectionName.value = sections.first.sectionName;
    }
    _fetchAttendanceForCurrentSelection();
  }

  void onSectionSelected(String sectionId) {
    selectedSectionId.value = sectionId;
    final classItems = classGroups[selectedClassId.value];
    if (classItems != null) {
      final selected =
      classItems.firstWhere((item) => item.sectionId == sectionId);
      selectedSectionName.value = selected.sectionName;
    }
    _fetchAttendanceForCurrentSelection();
  }

  // ========== DATE CHANGED ==========
  void onDateChanged(DateTime newDate) {
    selectedDate.value = newDate;
    _fetchAttendanceForCurrentSelection();
  }

  // ========== FETCH ATTENDANCE REPORT ==========
  void _fetchAttendanceForCurrentSelection() {
    if (selectedClassId.isNotEmpty && selectedSectionId.isNotEmpty) {
      fetchClassAttendanceReport();
    }
  }

  Future<void> fetchClassAttendanceReport() async {
    if (selectedClassId.isEmpty || selectedSectionId.isEmpty) {
      return;
    }

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

      var res = await attendanceReportPresenter.fetchClassAttendanceReport(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
        date: _formatDateForAPI(selectedDate.value),
      );

      if (res != null && res.status == true && res.data != null) {
        attendanceReportResponse.value = res;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load attendance report.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading attendance report.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== FORMAT DATE FOR API ==========
  String _formatDateForAPI(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  // ========== GETTERS ==========
  List<ClassItem>? get classList => teacherClassData.value?.data?.classes;

  bool get hasData => classList != null && classList!.isNotEmpty;

  bool get isLoadingData => isLoading.value;

  bool get hasReportData => attendanceReportResponse.value?.data != null;

  AttendanceReportData? get reportData => attendanceReportResponse.value?.data;

  String get month => reportData?.reportInfo?.month ?? '';
  List<AttendanceStat>? get attendanceStats => reportData?.attendanceStats;
  List<TopDefaulter>? get topDefaulters => reportData?.topDefaulters;
  List<ClassItem> get uniqueClassList {
    final result = <ClassItem>[];
    for (var classId in classGroups.keys) {
      final sections = classGroups[classId];
      if (sections != null && sections.isNotEmpty) {
        result.add(sections.first);
      }
    }
    return result;
  }
}