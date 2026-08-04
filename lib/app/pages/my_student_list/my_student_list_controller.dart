// pages/login/my_student_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/student_list_response.dart';
import 'my_student_list_presenter.dart';

class MyStudentListController extends GetxController {
  MyStudentListController(this.myStudentListPresenter);

  final MyStudentListPresenter myStudentListPresenter;

  var isLoading = false.obs;
  var studentData = Rxn<StudentsResponse>();

  // Store class and section IDs
  String classId = '';
  String sectionId = '';

  @override
  void onReady() {
    super.onReady();
    _getRouteArguments();
    getMyStudentData();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        classId = args['classId'] as String? ?? '';
        sectionId = args['sectionId'] as String? ?? '';
      }
    } catch (e) {
      debugPrint("❌ Error getting route arguments: $e");
    }
  }

  // ========== FETCH STUDENT DATA ==========
  Future<void> getMyStudentData() async {
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

      var res = await myStudentListPresenter.getAllStudentList(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
        classId: classId,
        sectionId: sectionId,
      );

      if (res != null && res.status == true && res.data != null) {
        studentData.value = res;

        if (res.data!.students != null && res.data!.students!.isNotEmpty) {
          for (var student in res.data!.students!) {
            debugPrint("  - ${student.studentName} (Roll: ${student.rollNumber})");
          }
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load student list.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading student list.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTER METHODS ==========

  // Student list
  List<StudentInfi>? get students => studentData.value?.data?.students;

  // Total students count (calculated from list length in the model)
  int get totalStudents => studentData.value?.data?.totalStudentCount ?? 0;

  // Class name - first student ke class info se (backend me top-level class_info nahi aata)
  String get className => (students != null && students!.isNotEmpty)
      ? students!.first.className
      : '';

  // Section name - first student ke section info se
  String get sectionName => (students != null && students!.isNotEmpty)
      ? students!.first.sectionName
      : '';

  // Full class name
  String get fullClassName => (students != null && students!.isNotEmpty)
      ? students!.first.fullClassName
      : '';

  // Loading state
  bool get isLoadingData => isLoading.value;

  // Check if data exists
  bool get hasData =>
      studentData.value?.data?.students != null &&
          studentData.value!.data!.students!.isNotEmpty;
}