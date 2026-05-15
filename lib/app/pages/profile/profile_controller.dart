import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/profile/profile_presenter.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/profile_response.dart';
import 'dart:convert';

import '../../navigators/routes_management.dart';
import '../../utils/strings/string_constants.dart';
import '../../utils/utility.dart';

class ProfileController extends GetxController {
  ProfileController(this.profilePresenter);
  final ProfilePresenter profilePresenter;

  var isLoading = false.obs;
  var profileData = Rxn<ProfileData>();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    //getProfileDetails();
  }

  // Future<void> getProfileDetails() async {
  //   try {
  //     var deviceRepo = Get.find<DeviceRepository>();
  //     var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
  //     var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
  //
  //     // 🔴 FIX: Use null-aware operators
  //     var res = await profilePresenter.getProfileDetailsAPI(
  //       isLoading: true,
  //       token:  token.toString(),
  //       branchId: branchId?.toString() ?? '',
  //     );
  //
  //     // 🔴 FIX: Add null checks before accessing
  //     if (res != null && res.status == true && res.data != null) {
  //       profileData.value = res.data;
  //
  //       // 🔴 FIX: Check if data is not null before encoding
  //       if (res.data != null) {
  //         String jsonString = jsonEncode(res.data!.toJson());
  //         await _storage.write('profile_data', jsonString);
  //         print("✅ Profile loaded: ${res.data?.username}");
  //       }
  //     } else {
  //       print("❌ Failed to load profile: ${res?.message}");
  //     }
  //
  //   } catch (e) {
  //     print("Error in getProfileDetails: $e");
  //   }
  // }

  // Future<void> logoutAPI({
  //   required bool isLoading,
  // }) async {
  //   try {
  //     Utility.showLoader();
  //     // Call logout API
  //     var res = await profilePresenter.logoutAPI(isLoading: isLoading);
  //     debugPrint('Logout response: $res');
  //     var repo = Get.find<DeviceRepository>();
  //     repo.deleteAllSecuredValues();
  //     repo.deleteBox();
  //     repo.deleteSecuredValue(DeviceConstants.profileData);
  //     Utility.closeLoader();
  //
  //     // Navigate to login screen
  //     RouteManagement.goToLoginStudentWithParam(role: 'student');
  //     update();
  //
  //   } catch (e) {
  //     print("Logout error: $e");
  //     var repo = Get.find<DeviceRepository>();
  //     repo.deleteAllSecuredValues();
  //     repo.deleteBox();
  //     repo.deleteSecuredValue(DeviceConstants.profileData);
  //     Utility.closeLoader();
  //     RouteManagement.goToLoginStudentWithParam(role: 'student');
  //     update();
  //   }
  // }

  // String get(String field) {
  //   final data = profileData.value;
  //   if (data == null) return 'Loading...';
  //
  //   // switch (field) {
  //   //   case 'name': return data.username ?? 'N/A';
  //   //   case 'email': return data.email ?? 'N/A';
  //   //   case 'role': return data.role ?? 'N/A';
  //   //   default: return 'N/A';
  //   // }
  // }
}