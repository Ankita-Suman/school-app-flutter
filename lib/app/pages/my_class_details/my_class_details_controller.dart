// pages/login/my_class_details_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/class_details_response.dart';
import 'my_class_details_presenter.dart';

class MyClassDetailsController extends GetxController {
  MyClassDetailsController(this.myClassesDetailsPresenter);

  final MyClassDetailsPresenter myClassesDetailsPresenter;
  var selectedTab = 0.obs;

  var isLoading = false.obs;
  var classDetailsData = Rxn<ClassDetailsResponse>();

  // Variables to store class and section IDs from route
  String classId = '';
  String sectionId = '';

  // Static timetable times
  final List<String> timetableTimes = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    _getRouteArguments();
    getMyClassDetailsData();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;

      if (args != null) {
        classId = args['classId'] as String? ?? '';
        sectionId = args['sectionId'] as String? ?? '';
      } else {
        debugPrint("❌ No arguments received");
      }
    } catch (e) {
      debugPrint("❌ Error getting route arguments: $e");
    }
  }

  // ========== FETCH CLASS DETAILS ==========
  Future<void> getMyClassDetailsData() async {
    if (classId.isEmpty || sectionId.isEmpty) {
      isLoading.value = false;
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

      var res = await myClassesDetailsPresenter.getMyClassDetailsData(
        isLoading: true,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
        classId: classId,
        sectionId: sectionId,
      );

      if (res != null && res.status == true && res.data != null) {
        classDetailsData.value = res;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load class details.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading class details.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTER METHODS FOR UI ==========

  String get className =>
      classDetailsData.value?.data?.classInfo?.className ?? '';

  String get sectionName =>
      classDetailsData.value?.data?.classInfo?.sectionName ?? '';

  String get fullClassName => classDetailsData.value?.data?.fullClassName ?? '';

  int get totalStudents => classDetailsData.value?.data?.totalStudents ?? 0;

  List<SubjectAllocation>? get subjects =>
      classDetailsData.value?.data?.subjectAllocation;

  ClassStrength? get classStrength =>
      classDetailsData.value?.data?.classStrength;

  // Get timetable with static times
  List<Map<String, String>> get timetableWithTimes {
    final subjectList = subjects ?? [];
    final List<Map<String, String>> result = [];

    for (int i = 0; i < timetableTimes.length && i < subjectList.length; i++) {
      result.add({
        'time': timetableTimes[i],
        'subject': subjectList[i].subject,
        'teacher': subjectList[i].teacherName,
      });
    }

    // Agar subjects kam hain toh remaining times show "Free"
    if (subjectList.length < timetableTimes.length) {
      for (int i = subjectList.length; i < timetableTimes.length; i++) {
        result.add({
          'time': timetableTimes[i],
          'subject': 'Free',
          'teacher': '',
        });
      }
    }

    return result;
  }

  // Get student count by gender (if available)
  int get boysCount => classStrength?.boys ?? 0;

  int get girlsCount => classStrength?.girls ?? 0;

  // Get subject allocation list
  List<SubjectAllocation> get subjectAllocationList => subjects ?? [];
}