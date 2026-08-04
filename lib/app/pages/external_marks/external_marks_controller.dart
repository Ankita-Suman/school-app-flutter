import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/external_marks_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import '../../../domain/models/subject_response.dart';
import 'external_marks_presenter.dart';

class ExternalMarksController extends GetxController {
  final ExternalMarksPresenter presenter;

  ExternalMarksController(this.presenter);

  var isLoading = false.obs;
  var hasChanges = false.obs; // track changes
  var isSaving = false.obs;

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
  var selectedClassId = ''.obs;
  var selectedClassName = ''.obs;

  // ========== SECTIONS ==========
  var termSectionData = Rxn<TermSectionResponse>();
  var selectedSectionId = ''.obs;
  var selectedSectionName = ''.obs;

  // ========== SUBJECTS ==========
  var subjectData = Rxn<SubjectResponse>();
  var externalMarksData = Rxn<ExternalMarksResponse>();
  var subjects = <Subjects>[].obs;
  var selectedSubjectId = ''.obs;
  var selectedSubjectName = ''.obs;

  // ========== STUDENTS (EXTERNAL MARKS) ==========
  var studentList = <Map<String, dynamic>>[].obs;
  final _isLoadingStudents = false.obs;

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

      var res = await presenter.getExamGroupData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );
      if (res != null && res.status == true && res.data != null) {
        examGroupData.value = res;
        if (res.data.isNotEmpty) {
          selectedExamGroupId.value = res.data.first.id;
          selectedExamGroupName.value = res.data.first.groupName;
          await getExamTermData(examinationGroupId: selectedExamGroupId.value);
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getExamGroupData: $e");
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

      var res = await presenter.getExamTermData(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
      );
      if (res != null && res.status == true && res.data != null) {
        examTermData.value = res;
        if (res.data.isNotEmpty) {
          selectedTermId.value = res.data.first.id;
          selectedTermName.value = res.data.first.term;
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getExamTermData: $e");
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

      var res = await presenter.getTermClassData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );
      if (res != null && res.status == true && res.data != null) {
        termClassData.value = res;
        if (res.data.isNotEmpty) {
          selectedClassId.value = res.data.first.id;
          selectedClassName.value = res.data.first.name;
          await getTermSectionData(classId: selectedClassId.value);
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getTermClassData: $e");
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

      var res = await presenter.getTermSectionData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
      );
      if (res != null && res.status == true && res.data != null) {
        termSectionData.value = res;
        if (res.data.isNotEmpty) {
          selectedSectionId.value = res.data.first.id;
          selectedSectionName.value = res.data.first.name;
          await getSubjectData(
            classId: selectedClassId.value,
            sectionId: selectedSectionId.value,
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getTermSectionData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET SUBJECTS ==========
  Future<void> getSubjectData({
    required String classId,
    required String sectionId,
  }) async {
    try {
      if (classId.isEmpty || sectionId.isEmpty) return;
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

      var res = await presenter.getSubjectData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );
      if (res != null && res.status == true && res.data != null) {
        subjectData.value = res;
        subjects.value = res.data;
        if (res.data.isNotEmpty) {
          selectedSubjectId.value = res.data.first.id;
          selectedSubjectName.value = res.data.first.name;
          await getExternalMarks();
        } else {
          selectedSubjectId.value = '';
          selectedSubjectName.value = '';
          studentList.clear();
        }
      } else {
        subjects.clear();
        subjectData.value = null;
        selectedSubjectId.value = '';
        selectedSubjectName.value = '';
        studentList.clear();
      }
    } catch (e) {
      debugPrint("❌ Error in getSubjectData: $e");
      subjects.clear();
      subjectData.value = null;
      selectedSubjectId.value = '';
      selectedSubjectName.value = '';
      studentList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GET EXTERNAL MARKS ==========
  Future<void> getExternalMarks() async {
    try {
      if (selectedExamGroupId.isEmpty ||
          selectedTermId.isEmpty ||
          selectedClassId.isEmpty ||
          selectedSectionId.isEmpty ||
          selectedSubjectId.isEmpty) {
        studentList.clear();
        return;
      }

      _isLoadingStudents.value = true;
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

      var res = await presenter.getExternalMarks(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
        subjectId: selectedSubjectId.value,
        markType: 'EXTERNAL',
        internalCount: '1',
      );

      if (res != null && res.status == true && res.data != null) {
        externalMarksData.value = res;
        final students = res.data!.students;

        // ✅ Correct mapping: use theory_obtained (or practical_obtained if needed)
        studentList.assignAll(students.map((student) {
          return {
            'id': student.id,
            'name': student.fullName,
            'reg': student.registrationNumber,
            'roll': student.rollNumber,
            // ✅ Use theory_obtained instead of internalMarks
            'marks': (student.theoryObtained ?? 0).toString(),
            'isAbsent': student.isStudentAbsent,
          };
        }).toList());
        hasChanges.value = false;
      } else {
        studentList.clear();
        externalMarksData.value = null;
      }
    } catch (e) {
      debugPrint("❌ Error in getExternalMarks: $e");
      studentList.clear();
      externalMarksData.value = null;
    } finally {
      _isLoadingStudents.value = false;
    }
  }

  // ========== SAVE EXTERNAL MARKS ==========
  Future<void> saveExternalMarks() async {
    try {
      if (studentList.isEmpty) {
        Get.snackbar('Error', 'No students to save.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final marks = studentList.map((student) {
        return {
          'student_id': student['id'],
          'is_student_absent': student['isAbsent'] as bool,
          'theory_obtained': int.tryParse(student['marks'] as String) ?? 0,
        };
      }).toList();

      final payload = {
        'examination_group_id': selectedExamGroupId.value,
        'examination_term_id': selectedTermId.value,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
        'subject_id': selectedSubjectId.value,
        'mark_type': 'EXTERNAL',
        'has_practical': false,
        'marks': marks,
      };

      isSaving.value = true;
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

      var res = await presenter.saveExternalMarks(
        isLoading: false,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', res.message ?? 'Marks saved successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        hasChanges.value = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(closeOverlays: true);
        });
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to save marks.',
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
      isSaving.value = false;
    }
  }

  // ========== MARK CHANGES ==========
  void markChanges() {
    hasChanges.value = true;
  }

  // ========== HANDLE DROPDOWN CHANGES ==========
  void onExamGroupChanged(String newGroupId) {
    selectedExamGroupId.value = newGroupId;
    final group = examGroupData.value?.data.firstWhere((g) => g.id == newGroupId);
    if (group != null) {
      selectedExamGroupName.value = group.groupName;
      getExamTermData(examinationGroupId: newGroupId)
          .then((_) => _checkAndFetchSubjectsAndMarks());
    }
  }

  void onTermChanged(String newTermId) {
    selectedTermId.value = newTermId;
    final term = examTermData.value?.data.firstWhere((t) => t.id == newTermId);
    if (term != null) {
      selectedTermName.value = term.term;
      _checkAndFetchSubjectsAndMarks();
    }
  }

  void onClassChanged(String newClassId) {
    selectedClassId.value = newClassId;
    final classItem = termClassData.value?.data.firstWhere((c) => c.id == newClassId);
    if (classItem != null) {
      selectedClassName.value = classItem.name;
      getTermSectionData(classId: newClassId)
          .then((_) => _checkAndFetchSubjectsAndMarks());
    }
  }

  void onSectionChanged(String newSectionId) {
    selectedSectionId.value = newSectionId;
    final section = termSectionData.value?.data.firstWhere((s) => s.id == newSectionId);
    if (section != null) {
      selectedSectionName.value = section.name;
      getSubjectData(
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      ).then((_) => _checkAndFetchSubjectsAndMarks());
    }
  }

  void onSubjectChanged(String newSubjectId) {
    selectedSubjectId.value = newSubjectId;
    final subject = subjects.firstWhere((s) => s.id == newSubjectId);
    if (subject != null) {
      selectedSubjectName.value = subject.name;
      getExternalMarks();
    }
  }

  void _checkAndFetchSubjectsAndMarks() async {
    if (selectedExamGroupId.isNotEmpty &&
        selectedTermId.isNotEmpty &&
        selectedClassId.isNotEmpty &&
        selectedSectionId.isNotEmpty) {
      await getSubjectData(
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );
    } else {
      subjects.clear();
      subjectData.value = null;
      selectedSubjectId.value = '';
      selectedSubjectName.value = '';
      studentList.clear();
      externalMarksData.value = null;
    }
  }

  // ========== GETTERS ==========
  List<ExaminationGroup> get examGroups => examGroupData.value?.data ?? [];
  List<ExaminationTerm> get examTerms => examTermData.value?.data ?? [];
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  List<Subjects> get subjectList => subjects;
  bool get isLoadingData => isLoading.value;
  bool get isLoadingStudents => _isLoadingStudents.value;
  bool get canSave => hasChanges.value && !isSaving.value;
}