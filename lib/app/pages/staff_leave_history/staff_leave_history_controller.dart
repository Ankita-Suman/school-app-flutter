// pages/login/staff_leave_history_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/leave_history_response.dart';
import 'staff_leave_history_presenter.dart';

class StaffLeaveHistoryController extends GetxController {
  StaffLeaveHistoryController(this.staffLeaveHistoryPresenter);

  final StaffLeaveHistoryPresenter staffLeaveHistoryPresenter;

  var isLoading = false.obs;
  var leaveHistoryItems = <LeaveHistoryItem>[].obs;
  var leaveHistoryResponse = Rxn<LeaveHistoryResponse>();

  @override
  void onInit() {
    super.onInit();
    _fetchLeaveHistory();
  }

  Future<void> _fetchLeaveHistory() async {
    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();

      // ✅ Fetch all required values from secure storage
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var staffId = await deviceRepo.getSecuredValue(DeviceConstants.staffId);

      // ✅ Validate all values
      if (token.isEmpty || branchId.isEmpty || staffId.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Missing authentication or staff ID. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // ✅ Send dynamic values to the API
      var res = await staffLeaveHistoryPresenter.getLeaveHistory(
        isLoading: false,
        token: token,        // ✅ dynamic
        branchId: branchId,  // ✅ dynamic
        staffId: staffId,    // ✅ dynamic (fetched from storage)
      );

      if (res != null && res.status == true && res.data != null) {
        leaveHistoryResponse.value = res;
        leaveHistoryItems.assignAll(res.data!);
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load leave history.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading leave history.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTERS ==========
  bool get hasData => leaveHistoryItems.isNotEmpty;
  int get totalCount => leaveHistoryResponse.value?.data?.length ?? 0;
}