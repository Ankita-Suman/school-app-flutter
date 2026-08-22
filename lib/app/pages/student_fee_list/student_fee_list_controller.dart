// student_fee_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/student_fee_list/student_fee_list_presenter.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/student_fee_status_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';

class StudentFeeListController extends GetxController {
  final StudentFeeListPresenter presenter;

  StudentFeeListController(this.presenter);

  var isLoading = false.obs;

  // ========== CLASSES ==========
  var termClassData = Rxn<TermClassResponse>();
  var selectedClassId = ''.obs;
  var selectedClassName = ''.obs;

  // ========== SECTIONS ==========
  var termSectionData = Rxn<TermSectionResponse>();
  var selectedSectionId = ''.obs;
  var selectedSectionName = ''.obs;

  // ========== FEE STATUS RESPONSE ==========
  var feeStatusResponse = Rxn<StudentFeeStatusResponse>();

  // ========== FILTER ==========
  var selectedFilter = 'All'.obs;

  // ========== GETTERS ==========
  List<StudentFeeStudent> get allStudents =>
      feeStatusResponse.value?.data?.students ?? [];

  StudentFeeSummary? get summary => feeStatusResponse.value?.data?.summary;

  List<StudentFeeStudent> get filteredStudents {
    if (selectedFilter.value == 'All') return allStudents;
    return allStudents
        .where((s) => s.status.toUpperCase() == selectedFilter.value.toUpperCase())
        .toList();
  }

  Map<String, int> get statusCounts {
    final counts = <String, int>{};
    for (var s in allStudents) {
      counts[s.status] = (counts[s.status] ?? 0) + 1;
    }
    return counts;
  }

  // ========== LIFECYCLE ==========
  @override
  void onInit() {
    super.onInit();
    everAll([selectedClassId, selectedSectionId], (_) {
      _checkAndFetchFeeList();
    });
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await getTermClassData();
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

  // ========== FETCH FEE LIST (FIXED) ==========
  Future<void> _checkAndFetchFeeList() async {
    if (selectedClassId.isNotEmpty && selectedSectionId.isNotEmpty) {
      await fetchFeeList();
    } else {
      feeStatusResponse.value = null;
    }
  }

  Future<void> fetchFeeList() async {
    try {
      if (selectedClassId.isEmpty || selectedSectionId.isEmpty) return;

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

      // ✅ presenter returns StudentFeeStatusResponse
      var res = await presenter.getStudentFeeList(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        // ✅ assign the whole response (not res.data)
        feeStatusResponse.value = res;
      } else {
        feeStatusResponse.value = null;
      }
    } catch (e) {
      debugPrint("❌ Error in fetchFeeList: $e");
      feeStatusResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ========== HANDLE DROPDOWN CHANGES ==========
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

  // ========== FILTER METHOD ==========
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ========== GETTERS ==========
  List<SimpleClass> get termClasses => termClassData.value?.data ?? [];
  List<SimpleSection> get termSections => termSectionData.value?.data ?? [];
  bool get isLoadingData => isLoading.value;
}