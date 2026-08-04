import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/internal_marks_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import '../../../domain/models/subject_response.dart';
import 'internal_marks_presenter.dart';

class InternalMarksController extends GetxController {
  final InternalMarksPresenter presenter;

  InternalMarksController(this.presenter);

  // ===== LOADING STATES (renamed with underscore to avoid conflict) =====
  var isLoadingGroups = false.obs;
  var isLoadingTerms = false.obs;
  var isLoadingClasses = false.obs;
  var isLoadingSections = false.obs;
  var isLoadingSubjects = false.obs;
  final _isLoadingStudents = false.obs;
  final _isLoadingData = false.obs; // overall

  var hasChanges = false.obs;
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
  var internalMarksData = Rxn<InternalMarksResponse>();
  var subjects = <Subjects>[].obs;
  var selectedSubjectId = ''.obs;
  var selectedSubjectName = ''.obs;

  // ========== INTERNAL MARKS CONFIG ==========
  var internalCount = 0.obs;
  var internalLabels = <String>[].obs;
  var maxMarks = <int?>[].obs;

  // ========== STUDENTS ==========
  var studentList = <Map<String, dynamic>>[].obs;

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
    _checkAndFetchSubjectsAndMarks();
  }

  // ========== GET EXAM GROUPS ==========
  Future<void> getExamGroupData() async {
    try {
      isLoadingGroups.value = true;
      _isLoadingData.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var res = await presenter.getExamGroupData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );
      if (res != null && res.status == true && res.data != null && res.data.isNotEmpty) {
        examGroupData.value = res;
        selectedExamGroupId.value = res.data.first.id;
        selectedExamGroupName.value = res.data.first.groupName;
        await getExamTermData(examinationGroupId: selectedExamGroupId.value);
      } else {
        Get.snackbar('Info', 'No exam groups found.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ Error in getExamGroupData: $e");
    } finally {
      isLoadingGroups.value = false;
      _isLoadingData.value = false;
    }
  }

  // ========== GET EXAM TERMS ==========
  Future<void> getExamTermData({required String examinationGroupId}) async {
    try {
      isLoadingTerms.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getExamTermData(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
      );
      if (res != null && res.status == true && res.data != null && res.data.isNotEmpty) {
        examTermData.value = res;
        selectedTermId.value = res.data.first.id;
        selectedTermName.value = res.data.first.term;
      }
    } catch (e) {
      debugPrint("❌ Error in getExamTermData: $e");
    } finally {
      isLoadingTerms.value = false;
    }
  }

  // ========== GET CLASSES ==========
  Future<void> getTermClassData() async {
    try {
      isLoadingClasses.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var res = await presenter.getTermClassData(
        isLoading: false,
        token: token,
        branchId: branchId,
      );
      if (res != null && res.status == true && res.data != null && res.data.isNotEmpty) {
        termClassData.value = res;
        selectedClassId.value = res.data.first.id;
        selectedClassName.value = res.data.first.name;
        await getTermSectionData(classId: selectedClassId.value);
      } else {
        Get.snackbar('Info', 'No classes found.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ Error in getTermClassData: $e");
    } finally {
      isLoadingClasses.value = false;
    }
  }

  // ========== GET SECTIONS ==========
  Future<void> getTermSectionData({required String classId}) async {
    try {
      isLoadingSections.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getTermSectionData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
      );
      if (res != null && res.status == true && res.data != null && res.data.isNotEmpty) {
        termSectionData.value = res;
        selectedSectionId.value = res.data.first.id;
        selectedSectionName.value = res.data.first.name;
        _checkAndFetchSubjectsAndMarks();
      }
    } catch (e) {
      debugPrint("❌ Error in getTermSectionData: $e");
    } finally {
      isLoadingSections.value = false;
    }
  }

  // ========== GET SUBJECTS ==========
  Future<void> getSubjectData({
    required String classId,
    required String sectionId,
  }) async {
    try {
      if (classId.isEmpty || sectionId.isEmpty) return;
      isLoadingSubjects.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getSubjectData(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );
      if (res != null && res.status == true && res.data != null && res.data.isNotEmpty) {
        subjectData.value = res;
        subjects.value = res.data;
        selectedSubjectId.value = res.data.first.id;
        selectedSubjectName.value = res.data.first.name;
        await getInternalMarks();
      } else {
        subjects.clear();
        selectedSubjectId.value = '';
        selectedSubjectName.value = '';
        studentList.clear();
      }
    } catch (e) {
      debugPrint("❌ Error in getSubjectData: $e");
      subjects.clear();
      selectedSubjectId.value = '';
      selectedSubjectName.value = '';
      studentList.clear();
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  // ========== GET INTERNAL MARKS ==========
  Future<void> getInternalMarks() async {
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

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getInternalMarks(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
        subjectId: selectedSubjectId.value,
        markType: 'INTERNAL',
      );

      if (res != null && res.status == true && res.data != null) {
        internalMarksData.value = res;
        internalCount.value = res.data!.internalCount;
        internalLabels.value = res.data!.internalLabels;
        maxMarks.value = res.data!.maxMarks;

        final students = res.data!.students;
        studentList.assignAll(students.map((student) {
          final marksList = student.internalMarks.isNotEmpty
              ? student.internalMarks.map((e) => e.toString()).toList()
              : List<String>.filled(res.data!.internalCount, '0');
          return {
            'id': student.id,
            'name': student.fullName,
            'reg': student.registrationNumber,
            'roll': student.rollNumber,
            'marks': marksList,
            'isAbsent': student.isStudentAbsent,
          };
        }).toList());
        hasChanges.value = false;
      } else {
        studentList.clear();
        internalMarksData.value = null;
        internalCount.value = 0;
        internalLabels.clear();
        maxMarks.clear();
      }
    } catch (e) {
      debugPrint("❌ Error in getInternalMarks: $e");
      studentList.clear();
      internalMarksData.value = null;
      internalCount.value = 0;
      internalLabels.clear();
      maxMarks.clear();
    } finally {
      _isLoadingStudents.value = false;
    }
  }

  // ========== SAVE INTERNAL MARKS ==========
  Future<void> saveInternalMarks() async {
    try {
      if (studentList.isEmpty) {
        Get.snackbar('Error', 'No students to save.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final marks = studentList.map((student) {
        final marksList = student['marks'] as List<String>;
        final internalMarks = marksList.map((m) => int.tryParse(m) ?? 0).toList();
        return {
          'student_id': student['id'],
          'is_student_absent': student['isAbsent'] as bool,
          'internal_marks': internalMarks,
        };
      }).toList();

      final payload = {
        'examination_group_id': selectedExamGroupId.value,
        'examination_term_id': selectedTermId.value,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
        'subject_id': selectedSubjectId.value,
        'mark_type': 'INTERNAL',
        'marks': marks,
      };

      isSaving.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var res = await presenter.saveInternalMarks(
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
      getInternalMarks();
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
      internalMarksData.value = null;
      internalCount.value = 0;
      internalLabels.clear();
      maxMarks.clear();
    }
  }

  // ========== GETTERS ==========
  List<ExaminationGroup> get examGroups => examGroupData.value?.data ?? [];
  List<ExaminationTerm> get examTerms => examTermData.value?.data ?? [];
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  List<Subjects> get subjectList => subjects;
  bool get isLoadingData => _isLoadingData.value; // fixed
  bool get isLoadingStudents => _isLoadingStudents.value; // fixed
  bool get canSave => hasChanges.value && !isSaving.value;
}