// pages/login/staff_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/student_profile/student_profile_presenter.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/profile_response.dart';

class StudentProfileController extends GetxController {
  StudentProfileController(this.studentProfilePresenter);

  final StudentProfilePresenter studentProfilePresenter;

  var profileData = Rxn<ProfileData>();
  var isLoadingProfile = false.obs;

  // Student ID - Route se milega
  String studentId = '';

  @override
  void onInit() {
    super.onInit();
    _getRouteArguments();
    getProfileDetailsWithLoader();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;

      if (args != null) {
        studentId = args['studentId'] as String? ?? '';
      } else {
        debugPrint("❌ No arguments received");
      }
    } catch (e) {
      debugPrint("❌ Error getting route arguments: $e");
    }
  }

  // ========== FETCH PROFILE WITH DYNAMIC CREDENTIALS ==========
  Future<void> getProfileDetailsWithLoader() async {
    // Check if studentId is available
    if (studentId.isEmpty) {
      isLoadingProfile.value = false;
      return;
    }

    try {
      isLoadingProfile.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoadingProfile.value = false;
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // ✅ Pass studentId to API with dynamic token and branchId
      var res = await studentProfilePresenter.getProfileDetailsAPI(
        isLoading: false,
        token: token,          // ✅ dynamic
        branchId: branchId,    // ✅ dynamic
        studentId: studentId,  // Route se mili studentId
      );

      if (res != null && res.status == true) {
        profileData.value = res.data;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load profile.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading profile.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ========== GETTER METHODS ==========

  String get studentName => profileData.value?.personal.name ?? '';

  String get admissionNumber =>
      profileData.value?.personal.admissionNumber ?? '';

  String get rollNumber => profileData.value?.personal.rollNumber ?? '';

  String get photo => profileData.value?.personal.photo ?? '';

  bool get hasPhoto => photo.isNotEmpty;

  bool get isLoading => isLoadingProfile.value;

  bool get hasData => profileData.value != null;
}