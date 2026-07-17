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

  // ✅ Student ID - Route se milega
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
        print("📚 Student ID: $studentId");
      } else {
        print("❌ No arguments received");
      }
    } catch (e) {
      print("❌ Error getting route arguments: $e");
    }
  }

  Future<void> getProfileDetailsWithLoader() async {
    // ✅ Check if studentId is available
    if (studentId.isEmpty) {
      print("❌ Student ID is empty");
      isLoadingProfile.value = false;
      return;
    }

    try {
      isLoadingProfile.value = true;
      print("📡📡📡 getProfileDetailsWithLoader START - API HIT WITH LOADER 📡📡📡");
      print("📚 Student ID: $studentId");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoadingProfile.value = false;
        return;
      }

      // ✅ Pass studentId to API
      var res = await studentProfilePresenter.getProfileDetailsAPI(
        isLoading: false,
         token :'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODM5Njk5NzcsImV4cCI6MTc4NDE0Mjc3NywibmJmIjoxNzgzOTY5OTc3LCJqdGkiOiI5Mmd6WTRabGd3ckNTRzRkIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.G8ODXvgAtbbs_YIpgRQ8lSBX8s0GNblId3ZgJ_oWvrk',
        branchId: '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a',
        studentId: studentId,  // ✅ Route se mili studentId
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;
        print("✅ Profile loaded: ${res.data?.personal?.name}");
        // print("📚 Class: ${res.data?.classInfo?.className} - ${res.data?.classInfo?.sectionName}");
        // print("📚 Student ID: ${res.data?.personal?.studentId}");
      } else {
        print("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      print("Error in getProfileDetailsWithLoader: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ========== GETTER METHODS ==========

  String get studentName => profileData.value?.personal?.name ?? '';
  // String get studentIdFromProfile => profileData.value?.personal?.studentId ?? '';
  // String get classInfo => profileData.value?.classInfo?.fullName ?? '';
  String get admissionNumber => profileData.value?.personal?.admissionNumber ?? '';
  String get rollNumber => profileData.value?.personal?.rollNumber ?? '';
  String get photo => profileData.value?.personal?.photo ?? '';
  bool get hasPhoto => photo.isNotEmpty;

  bool get isLoading => isLoadingProfile.value;
  bool get hasData => profileData.value != null;

  @override
  void onClose() {
    super.onClose();
  }
}