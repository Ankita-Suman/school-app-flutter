import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/co_curricular_marks_response.dart';
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import 'curricular_marks_presenter.dart';

class CurricularMarksController extends GetxController {
  final CurricularMarksPresenter presenter;

  CurricularMarksController(this.presenter);

  // ===== LOADING STATES =====
  var isLoadingGroups = false.obs;
  var isLoadingTerms = false.obs;
  var isLoadingClasses = false.obs;
  var isLoadingSections = false.obs;
  final _isLoadingStudents = false.obs;
  final _isLoadingData = false.obs;

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

  // ========== CO-CURRICULAR DATA ==========
  var coCurricularMarksData = Rxn<CoCurricularMarksResponse>();
  var activities = <CoCurricularActivity>[].obs;
  var coCurricularStudents = <CoCurricularStudent>[].obs;

  // ========== UI COMPATIBILITY (columns, max marks) ==========
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
    _checkAndFetchMarks();
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
      if (res != null &&
          res.status == true &&
          res.data != null &&
          res.data.isNotEmpty) {
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
      if (res != null &&
          res.status == true &&
          res.data != null &&
          res.data.isNotEmpty) {
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
      if (res != null &&
          res.status == true &&
          res.data != null &&
          res.data.isNotEmpty) {
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
      if (res != null &&
          res.status == true &&
          res.data != null &&
          res.data.isNotEmpty) {
        termSectionData.value = res;
        selectedSectionId.value = res.data.first.id;
        selectedSectionName.value = res.data.first.name;
        _checkAndFetchMarks();
      }
    } catch (e) {
      debugPrint("❌ Error in getTermSectionData: $e");
    } finally {
      isLoadingSections.value = false;
    }
  }

  // ============================================================
  // ✅ GET CO-CURRICULAR MARKS
  // ============================================================
  Future<void> getCoCurricularMarks() async {
    try {
      if (selectedExamGroupId.isEmpty ||
          selectedTermId.isEmpty ||
          selectedClassId.isEmpty ||
          selectedSectionId.isEmpty) {
        _clearAllMarksState();
        return;
      }

      _isLoadingStudents.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getCoCurricularMarks(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        coCurricularMarksData.value = res;
        activities.value = res.data!.activities;
        coCurricularStudents.value = res.data!.students;

        internalCount.value = res.data!.activities.length;
        internalLabels.value =
            res.data!.activities.map((a) => a.title).toList();
        maxMarks.value =
            res.data!.activities.map((a) => a.maxMarks.toInt()).toList();

        final activityOrder = res.data!.activities.map((a) => a.id).toList();
        studentList.assignAll(res.data!.students.map((student) {
          final marksList = activityOrder
              .map((activityId) =>
              student.marksFor(activityId).toStringAsFixed(0))
              .toList();
          return {
            'id': student.id,
            'name': student.fullName,
            'reg': student.registrationNumber,
            'roll': student.rollNumber,
            'marks': marksList,
            'isAbsent': student.isStudentAbsent,
            'rawStudent': student,
          };
        }).toList());

        hasChanges.value = false;
      } else {
        _clearAllMarksState();
      }
    } catch (e) {
      debugPrint("❌ Error in getCoCurricularMarks: $e");
      _clearAllMarksState();
    } finally {
      _isLoadingStudents.value = false;
    }
  }

  void _clearAllMarksState() {
    studentList.clear();
    coCurricularMarksData.value = null;
    activities.clear();
    coCurricularStudents.clear();
    internalCount.value = 0;
    internalLabels.clear();
    maxMarks.clear();
  }

  // ============================================================
  // ✅ SAVE CO-CURRICULAR MARKS — with auto back navigation
  // ============================================================
  Future<void> saveCoCurricularMarks() async {
    try {
      if (studentList.isEmpty || activities.isEmpty) {
        Get.snackbar('Error', 'No students to save.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      // ✅ Build marks list (activityId → mark map)
      final activityIds = activities.map((a) => a.id).toList();
      final marks = studentList.map((student) {
        final marksList = (student['marks'] as List<String>?) ?? <String>[];
        final isAbsent = student['isAbsent'] as bool? ?? false;

        Map<String, int> activityMarks = {};
        if (!isAbsent) {
          for (int i = 0; i < activityIds.length && i < marksList.length; i++) {
            final m = int.tryParse(marksList[i]) ?? 0;
            activityMarks[activityIds[i]] = m;
          }
        }

        return {
          'student_id': student['id'],
          'is_student_absent': isAbsent,
          'activity_marks': activityMarks,
        };
      }).toList();

      final payload = {
        'examination_group_id': selectedExamGroupId.value,
        'examination_term_id': selectedTermId.value,
        'class_id': selectedClassId.value,
        'section_id': selectedSectionId.value,
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

      var res = await presenter.saveCoCurricularMarks(
        isLoading: false,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res != null && res.status == true) {
        Get.snackbar(
          'Success',
          res.message ?? 'Marks saved successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        hasChanges.value = false;

        // ✅ Screen back to previous page after short delay
        //    (delay so user can see snackbar)
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back();
        });
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to save marks.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ saveCoCurricularMarks error: $e");
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
    final group =
    examGroupData.value?.data.firstWhere((g) => g.id == newGroupId);
    if (group != null) {
      selectedExamGroupName.value = group.groupName;
      getExamTermData(examinationGroupId: newGroupId)
          .then((_) => _checkAndFetchMarks());
    }
  }

  void onTermChanged(String newTermId) {
    selectedTermId.value = newTermId;
    final term =
    examTermData.value?.data.firstWhere((t) => t.id == newTermId);
    if (term != null) {
      selectedTermName.value = term.term;
      _checkAndFetchMarks();
    }
  }

  void onClassChanged(String newClassId) {
    selectedClassId.value = newClassId;
    final classItem =
    termClassData.value?.data.firstWhere((c) => c.id == newClassId);
    if (classItem != null) {
      selectedClassName.value = classItem.name;
      getTermSectionData(classId: newClassId)
          .then((_) => _checkAndFetchMarks());
    }
  }

  void onSectionChanged(String newSectionId) {
    selectedSectionId.value = newSectionId;
    final section =
    termSectionData.value?.data.firstWhere((s) => s.id == newSectionId);
    if (section != null) {
      selectedSectionName.value = section.name;
      getCoCurricularMarks();
    }
  }

  void _checkAndFetchMarks() async {
    if (selectedExamGroupId.isNotEmpty &&
        selectedTermId.isNotEmpty &&
        selectedClassId.isNotEmpty &&
        selectedSectionId.isNotEmpty) {
      await getCoCurricularMarks();
    } else {
      _clearAllMarksState();
    }
  }

  // ========== GETTERS ==========
  List<ExaminationGroup> get examGroups => examGroupData.value?.data ?? [];
  List<ExaminationTerm> get examTerms => examTermData.value?.data ?? [];
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  bool get isLoadingData => _isLoadingData.value;
  bool get isLoadingStudents => _isLoadingStudents.value;
  bool get canSave => hasChanges.value && !isSaving.value;

  List<CoCurricularActivity> get activityList => activities;

  String get termDisplayName =>
      coCurricularMarksData.value?.data?.term?.term ?? selectedTermName.value;

  int get totalStudents =>
      coCurricularMarksData.value?.data?.totalStudents ?? 0;

  /// ✅ Single max marks (पहला element) — UI दिखाने के लिए
  int get singleMaxMark =>
      maxMarks.isNotEmpty ? (maxMarks.first ?? 0) : 0;
}