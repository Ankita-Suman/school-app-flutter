import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/term_attendance_student_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import 'term_attendance_presenter.dart';

class TermAttendanceController extends GetxController {
  TermAttendanceController(this.termAttendancePresenter);

  final TermAttendancePresenter termAttendancePresenter;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  // ========== EXAM GROUPS ==========
  var examGroupData = Rxn<ExaminationGroupResponse>();
  var selectedExamGroupId = ''.obs;
  var selectedExamGroupName = ''.obs;

  // ========== EXAM TERMS ==========
  var examTermData = Rxn<ExaminationTermResponse>();
  var selectedTermId = ''.obs;
  var selectedTermName = ''.obs;

  // ========== CLASSES ==========
  var termClassData = Rxn<TermClassResponse>();
  var classNames = <String>[].obs;
  var selectedClassId = ''.obs;
  var selectedClassName = ''.obs;

  // ========== SECTIONS ==========
  var termSectionData = Rxn<TermSectionResponse>();
  var sectionNames = <String>[].obs;
  var selectedSectionId = ''.obs;
  var selectedSectionName = ''.obs;

  // ========== STUDENTS ==========
  var studentData = Rxn<TermAttendanceStudentsResponse>();
  var studentList = <TermAttendanceStudent>[].obs;

  // ========== ATTENDANCE MAP (student_id -> attendance days) ==========
  var attendanceMap = <String, int>{}.obs;

  // ========== HARDCODED REMOVED – now dynamic ==========

  @override
  void onInit() {
    super.onInit();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([
      getExamGroupData(),
      getTermClassData(),
    ]);
    _checkAndFetchStudents();
  }

  // ========== GET EXAM GROUPS ==========
  Future<void> getExamGroupData() async {
    try {
      isLoading.value = true;

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

      var res = await termAttendancePresenter.getExamGroupData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );

      if (res != null && res.status == true) {
        examGroupData.value = res;
        if (res.data.isNotEmpty) {
          selectedExamGroupId.value = res.data.first.id;
          selectedExamGroupName.value = res.data.first.groupName;
          await getExamTermData(examinationGroupId: selectedExamGroupId.value);
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load exam groups.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading exam groups.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET EXAM TERMS ==========
  Future<void> getExamTermData({required String examinationGroupId}) async {
    try {
      isLoading.value = true;

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

      var res = await termAttendancePresenter.getExamTermData(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
      );

      if (res != null && res.status == true) {
        examTermData.value = res;
        if (res.data.isNotEmpty) {
          selectedTermId.value = res.data.first.id;
          selectedTermName.value = res.data.first.term;
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load exam terms.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading exam terms.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET CLASSES ==========
  Future<void> getTermClassData() async {
    try {
      isLoading.value = true;

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

      var res = await termAttendancePresenter.getTermClassData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );

      if (res != null && res.status == true) {
        termClassData.value = res;
        classNames.value = res.data.map((e) => e.name).toList();
        if (res.data.isNotEmpty) {
          selectedClassId.value = res.data.first.id;
          selectedClassName.value = res.data.first.name;
          await getTermSectionData(classId: selectedClassId.value);
        }
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

  // ========== GET SECTIONS ==========
  Future<void> getTermSectionData({required String classId}) async {
    try {
      isLoading.value = true;

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

      var res = await termAttendancePresenter.getTermSectionData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
      );

      if (res != null && res.status == true) {
        termSectionData.value = res;
        sectionNames.value = res.data.map((e) => e.name).toList();
        if (res.data.isNotEmpty) {
          selectedSectionId.value = res.data.first.id;
          selectedSectionName.value = res.data.first.name;
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load sections.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading sections.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== FETCH STUDENTS ==========
  Future<void> _checkAndFetchStudents() async {
    if (selectedExamGroupId.isNotEmpty &&
        selectedTermId.isNotEmpty &&
        selectedClassId.isNotEmpty &&
        selectedSectionId.isNotEmpty) {
      await getTermAttendanceStudents();
    } else {
      debugPrint("⚠️ Missing required selections");
    }
  }

  Future<void> getTermAttendanceStudents() async {
    try {
      if (selectedExamGroupId.isEmpty ||
          selectedTermId.isEmpty ||
          selectedClassId.isEmpty ||
          selectedSectionId.isEmpty) {
        return;
      }

      isLoading.value = true;

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

      var res = await termAttendancePresenter.getTermAttendanceStudents(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        studentData.value = res;
        if (res.data!.students.isNotEmpty) {
          studentList.value = res.data!.students;
          // Initialize attendance map with existing values or 0
          for (var student in res.data!.students) {
            attendanceMap[student.studentId] = student.existingAttendance ?? 0;
          }
        } else {
          studentList.clear();
          attendanceMap.clear();
        }
      } else {
        studentList.clear();
        attendanceMap.clear();
      }
    } catch (e) {
      studentList.clear();
      attendanceMap.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ========== UPDATE STUDENT ATTENDANCE ==========
  void updateStudentAttendance(String studentId, int value) {
    attendanceMap[studentId] = value;
  }

  // ========== SAVE TERM ATTENDANCE ==========
  Future<void> saveTermAttendance() async {
    try {
      if (selectedExamGroupId.isEmpty ||
          selectedTermId.isEmpty ||
          selectedClassId.isEmpty ||
          selectedSectionId.isEmpty) {
        Get.snackbar('Error', 'Please select all criteria before saving.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      if (studentList.isEmpty) {
        Get.snackbar('Error', 'No students to save.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      // Build attendance list from the map
      final List<Map<String, dynamic>> attendances = [];
      for (var student in studentList) {
        final attendanceValue = attendanceMap[student.studentId] ?? 0;
        attendances.add({
          'student_id': student.studentId,
          'attendance': attendanceValue,
        });
      }

      final payload = {
        'examination_group_id': selectedExamGroupId.value,
        'examination_term_id': selectedTermId.value,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
        'attendances': attendances,
      };

      isLoading.value = true;

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

      var res = await termAttendancePresenter.saveTermAttendance(
        isLoading: false,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', res.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        // Optionally, refresh data or navigate back
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(closeOverlays: true);
        });
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to save attendance.',
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

  // ========== HANDLE EXAM GROUP CHANGE ==========
  void onExamGroupChanged(String newGroupId) {
    selectedExamGroupId.value = newGroupId;
    final group =
    examGroupData.value?.data.firstWhere((g) => g.id == newGroupId);
    if (group != null) {
      selectedExamGroupName.value = group.groupName;
      getExamTermData(examinationGroupId: newGroupId)
          .then((_) => _checkAndFetchStudents());
    }
  }

  void onTermChanged(String newTermId) {
    selectedTermId.value = newTermId;
    final term = examTermData.value?.data.firstWhere((t) => t.id == newTermId);
    if (term != null) {
      selectedTermName.value = term.term;
      _checkAndFetchStudents();
    }
  }

  void onClassChanged(String newClassId) {
    selectedClassId.value = newClassId;
    final classItem =
    termClassData.value?.data.firstWhere((c) => c.id == newClassId);
    if (classItem != null) {
      selectedClassName.value = classItem.name;
      getTermSectionData(classId: newClassId)
          .then((_) => _checkAndFetchStudents());
    }
  }

  void onSectionChanged(String newSectionId) {
    selectedSectionId.value = newSectionId;
    final section =
    termSectionData.value?.data.firstWhere((s) => s.id == newSectionId);
    if (section != null) {
      selectedSectionName.value = section.name;
      _checkAndFetchStudents();
    }
  }

  // ========== GETTERS ==========
  List<ExaminationGroup> get examGroups => examGroupData.value?.data ?? [];
  List<ExaminationTerm> get examTerms => examTermData.value?.data ?? [];
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  bool get isLoadingData => isLoading.value;

  // ========== MAX ATTENDANCE ==========
  int? get maxAttendance => studentData.value?.data?.maxAttendance;
  String get maxAttendanceDisplay => maxAttendance != null ? maxAttendance.toString() : '--';
}