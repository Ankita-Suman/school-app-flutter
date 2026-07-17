import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // ========== HARDCODED (replace later) ==========
  final String hardcodedToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODQxODA2ODgsImV4cCI6MTc4NDM1MzQ4OCwibmJmIjoxNzg0MTgwNjg4LCJqdGkiOiJKY3IzSmVOdmVWVk5TMllMIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.Mdpb7QcnglMLL5B5cph0vKDQQ546iY0I_YkJA-Cl82E';
  final String hardcodedBranchId = '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a';

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
      print("📡📡📡 getExamGroupData START");

      var res = await termAttendancePresenter.getExamGroupData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
      );

      if (res != null && res.status == true && res.data != null) {
        examGroupData.value = res;
        print("✅ Exam Groups loaded: ${res.data.length}");
        if (res.data.isNotEmpty) {
          selectedExamGroupId.value = res.data.first.id;
          selectedExamGroupName.value = res.data.first.groupName;
          await getExamTermData(examinationGroupId: selectedExamGroupId.value);
        }
      } else {
        print("❌ Failed to load exam groups: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getExamGroupData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET EXAM TERMS ==========
  Future<void> getExamTermData({required String examinationGroupId}) async {
    try {
      isLoading.value = true;
      print("📡📡📡 getExamTermData START for group: $examinationGroupId");

      var res = await termAttendancePresenter.getExamTermData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        examinationGroupId: examinationGroupId,
      );

      if (res != null && res.status == true && res.data != null) {
        examTermData.value = res;
        print("✅ Exam Terms loaded: ${res.data.length}");
        if (res.data.isNotEmpty) {
          selectedTermId.value = res.data.first.id;
          selectedTermName.value = res.data.first.term;
        }
      } else {
        print("❌ Failed to load exam terms: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getExamTermData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET CLASSES ==========
  Future<void> getTermClassData() async {
    try {
      isLoading.value = true;
      print("📡📡📡 getTermClassData START");

      var res = await termAttendancePresenter.getTermClassData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
      );

      if (res != null && res.status == true && res.data != null) {
        termClassData.value = res;
        print("✅ Classes loaded: ${res.data.length}");
        classNames.value = res.data.map((e) => e.name).toList();
        if (res.data.isNotEmpty) {
          selectedClassId.value = res.data.first.id;
          selectedClassName.value = res.data.first.name;
          await getTermSectionData(classId: selectedClassId.value);
        }
      } else {
        print("❌ Failed to load classes: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getTermClassData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET SECTIONS ==========
  Future<void> getTermSectionData({required String classId}) async {
    try {
      isLoading.value = true;
      print("📡📡📡 getTermSectionData START for class: $classId");

      var res = await termAttendancePresenter.getTermSectionData(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        classId: classId,
      );

      if (res != null && res.status == true && res.data != null) {
        termSectionData.value = res;
        print("✅ Sections loaded: ${res.data.length}");
        sectionNames.value = res.data.map((e) => e.name).toList();
        if (res.data.isNotEmpty) {
          selectedSectionId.value = res.data.first.id;
          selectedSectionName.value = res.data.first.name;
        }
      } else {
        print("❌ Failed to load sections: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getTermSectionData: $e");
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
      print("⚠️ Missing required selections");
    }
  }

  Future<void> getTermAttendanceStudents() async {
    try {
      if (selectedExamGroupId.isEmpty ||
          selectedTermId.isEmpty ||
          selectedClassId.isEmpty ||
          selectedSectionId.isEmpty) {
        print("⚠️ Missing required selections to fetch students");
        return;
      }

      isLoading.value = true;
      print("📡📡📡 getTermAttendanceStudents START");

      var res = await termAttendancePresenter.getTermAttendanceStudents(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        studentData.value = res;
        if (res.data!.students.isNotEmpty) {
          studentList.value = res.data!.students;
          // ✅ Initialize attendance map with existing values or 0
          for (var student in res.data!.students) {
            attendanceMap[student.studentId] = student.existingAttendance ?? 0;
          }
          print("✅ Students loaded: ${studentList.length}");
        } else {
          studentList.clear();
          attendanceMap.clear();
          print("⚠️ No students found");
        }
      } else {
        print("❌ Failed to load students: ${res?.message}");
        studentList.clear();
        attendanceMap.clear();
      }
    } catch (e) {
      print("❌ Error in getTermAttendanceStudents: $e");
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
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (studentList.isEmpty) {
        Get.snackbar('Error', 'No students to save.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
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

      print("📤 Sending Term Attendance Payload: $payload");

      isLoading.value = true;

      var res = await termAttendancePresenter.saveTermAttendance(
        isLoading: false,
        token: hardcodedToken,
        branchId: hardcodedBranchId,
        payload: payload,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', res.message ?? 'Attendance saved successfully!',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
        // Optionally, refresh data or navigate back
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to save attendance.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("❌ Error saving term attendance: $e");
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== HANDLE EXAM GROUP CHANGE ==========
  void onExamGroupChanged(String newGroupId) {
    selectedExamGroupId.value = newGroupId;
    final group = examGroupData.value?.data.firstWhere((g) => g.id == newGroupId);
    if (group != null) {
      selectedExamGroupName.value = group.groupName;
      getExamTermData(examinationGroupId: newGroupId).then((_) => _checkAndFetchStudents());
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
    final classItem = termClassData.value?.data.firstWhere((c) => c.id == newClassId);
    if (classItem != null) {
      selectedClassName.value = classItem.name;
      getTermSectionData(classId: newClassId).then((_) => _checkAndFetchStudents());
    }
  }

  void onSectionChanged(String newSectionId) {
    selectedSectionId.value = newSectionId;
    final section = termSectionData.value?.data.firstWhere((s) => s.id == newSectionId);
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
}