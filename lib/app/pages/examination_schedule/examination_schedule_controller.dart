import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import '../../../domain/models/exam_schedule_response.dart';
import 'examination_schedule_presenter.dart';

class ExaminationScheduleController extends GetxController {
  final ExaminationSchedulePresenter presenter;

  ExaminationScheduleController(this.presenter);

  var isLoading = false.obs;

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

  // ========== EXAM SCHEDULE ==========
  var examScheduleData = Rxn<ExamScheduleResponse>();
  var scheduleList = <ExamScheduleItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ Listen to changes in all four selected IDs – auto‑fetch when all are filled
    everAll([
      selectedExamGroupId,
      selectedTermId,
      selectedClassId,
      selectedSectionId,
    ], (_) {
      _checkAndFetchSchedule();
    });
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([
      getExamGroupData(),
      getTermClassData(),
    ]);
    // ✅ The everAll listener above will automatically trigger schedule fetch
    // once all selections are populated.
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
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getTermSectionData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== FETCH EXAM SCHEDULE ==========
  Future<void> _checkAndFetchSchedule() async {
    if (selectedExamGroupId.isNotEmpty &&
        selectedTermId.isNotEmpty &&
        selectedClassId.isNotEmpty &&
        selectedSectionId.isNotEmpty) {
      await getExamSchedule();
    } else {
      scheduleList.clear();
      examScheduleData.value = null;
    }
  }

  Future<void> getExamSchedule() async {
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

      var res = await presenter.getExamSchedule(
        isLoading: false,
        token: token,
        branchId: branchId,
        examinationGroupId: selectedExamGroupId.value,
        examinationTermId: selectedTermId.value,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        examScheduleData.value = res;
        scheduleList.value = res.data!.schedule;
      } else {
        scheduleList.clear();
        examScheduleData.value = null;
      }
    } catch (e) {
      scheduleList.clear();
      examScheduleData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ========== HANDLE DROPDOWN CHANGES ==========
  void onExamGroupChanged(String newGroupId) {
    selectedExamGroupId.value = newGroupId;
    final group = examGroupData.value?.data.firstWhere((g) => g.id == newGroupId);
    if (group != null) {
      selectedExamGroupName.value = group.groupName;
      getExamTermData(examinationGroupId: newGroupId);
    }
  }

  void onTermChanged(String newTermId) {
    selectedTermId.value = newTermId;
    final term = examTermData.value?.data.firstWhere((t) => t.id == newTermId);
    if (term != null) {
      selectedTermName.value = term.term;
    }
  }

  void onClassChanged(String newClassId) {
    selectedClassId.value = newClassId;
    final classItem = termClassData.value?.data.firstWhere((c) => c.id == newClassId);
    if (classItem != null) {
      selectedClassName.value = classItem.name;
      getTermSectionData(classId: newClassId);
    }
  }

  void onSectionChanged(String newSectionId) {
    selectedSectionId.value = newSectionId;
    final section = termSectionData.value?.data.firstWhere((s) => s.id == newSectionId);
    if (section != null) {
      selectedSectionName.value = section.name;
    }
  }

  // ========== GETTERS ==========
  List<ExaminationGroup> get examGroups => examGroupData.value?.data ?? [];
  List<ExaminationTerm> get examTerms => examTermData.value?.data ?? [];
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  List<ExamScheduleItem> get schedule => scheduleList;
  bool get isLoadingData => isLoading.value;
}