import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

// ✅ दोनों मॉडल्स को अलग-अलग एलियास (as) के साथ इम्पोर्ट किया गया है
// ⚠️ ध्यान दें: अपनी फाइलों का सही नाम/पाथ यहाँ इस्तेमाल करें
import '../../../domain/models/staff_announcement_response.dart' as my_model;
import '../../../domain/models/staff_other_announcement_response.dart' as other_model;

import 'staff_announcements_presenter.dart';

class StaffAnnouncementsController extends GetxController {
  StaffAnnouncementsController(this.presenter);

  final StaffAnnouncementsPresenter presenter;

  var isLoadingMy = false.obs;
  var isLoadingOther = false.obs;

  // ✅ लिस्ट अब सीधे StaffNotice को होल्ड करेगी, Response को नहीं
  var myAnnouncements = <my_model.StaffMyNotice>[].obs;
  var otherAnnouncements = <other_model.StaffNotice>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyAnnouncements();
  }

  Future<void> fetchMyAnnouncements() async {
    try {
      isLoadingMy.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getStaffAnnouncementDetailsAPI(
        isLoading: false,
        token: token,
        branchId: branchId,
        tab: 'my',
      );

      if (res != null && !res.hasError && res.data != null) {
        dynamic rawData = res.data;
        if (rawData is String) rawData = jsonDecode(rawData);

        if (rawData is Map<String, dynamic>) {
          // ✅ my_model का उपयोग करके पार्स करें
          my_model.StaffNoticeResponse response = my_model.StaffNoticeResponse.fromJson(rawData);

          if (response.status == true && response.data != null) {
            myAnnouncements.value = response.data!.notices ?? [];
            debugPrint("✅ My Data Set: ${myAnnouncements.length}");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching my announcements: $e");
    } finally {
      isLoadingMy.value = false;
    }
  }

  Future<void> fetchOtherAnnouncements() async {
    try {
      isLoadingOther.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) return;

      var res = await presenter.getStaffAnnouncementDetailsAPI(
        isLoading: false,
        token: token,
        branchId: branchId,
        tab: 'other',
      );

      debugPrint("🔍 Other API Hit Status: ${res?.hasError}");

      if (res != null && !res.hasError && res.data != null) {
        dynamic rawData = res.data;
        if (rawData is String) rawData = jsonDecode(rawData);

        if (rawData is Map<String, dynamic>) {
          // ✅ other_model का उपयोग करके पार्स करें
          other_model.StaffOtherNoticeResponse response = other_model.StaffOtherNoticeResponse.fromJson(rawData);

          if (response.status == true && response.data != null) {
            otherAnnouncements.value = response.data!.notices ?? [];
            debugPrint("✅ Other Data Set: ${otherAnnouncements.length}");
          } else {
            debugPrint("⚠️ Other data parsed but status is false or null.");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching other announcements: $e");
    } finally {
      isLoadingOther.value = false;
    }
  }
}