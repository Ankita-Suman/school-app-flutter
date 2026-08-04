// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/leave_balance_response.dart';
import 'leave_balance_presenter.dart';

class LeaveBalanceController extends GetxController {
  LeaveBalanceController(this.leaveBalancePresenter);

  final LeaveBalancePresenter leaveBalancePresenter;

  var isLoading = false.obs;
  var leaveBalanceData = Rxn<LeaveBalanceResponse>();

  @override
  void onInit() {
    super.onInit();
    getLeaveBalanceAPI();
  }

  // ========== FETCH LEAVE BALANCE ==========
  Future<void> getLeaveBalanceAPI() async {
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

      var res = await leaveBalancePresenter.getLeaveBalanceAPI(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
      );

      if (res != null && res.status == true && res.data != null) {
        leaveBalanceData.value = res;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load leave balance data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading leave balance.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTERS ==========
  bool get hasData => leaveBalanceData.value?.data != null;
  int get totalRemaining => leaveBalanceData.value?.data?.totalRemaining ?? 0;
  int get totalQuota => leaveBalanceData.value?.data?.totalQuota ?? 0;
  int get totalUsed => leaveBalanceData.value?.data?.totalUsed ?? 0;
  List<LeaveBreakdown> get breakdown => leaveBalanceData.value?.data?.breakdown ?? [];

  // Helper to get specific leave type
  LeaveBreakdown? getLeaveByType(String type) {
    return breakdown.firstWhereOrNull(
          (item) => item.leaveType.toUpperCase() == type.toUpperCase(),
    );
  }

  // Quick access for common types (with fallback)
  int get casualLeave => getLeaveByType('CASUAL')?.quota ?? 0;
  int get casualUsed => getLeaveByType('CASUAL')?.used ?? 0;
  int get casualRemaining => getLeaveByType('CASUAL')?.remaining ?? 0;

  int get sickLeave => getLeaveByType('SICK')?.quota ?? 0;
  int get sickUsed => getLeaveByType('SICK')?.used ?? 0;
  int get sickRemaining => getLeaveByType('SICK')?.remaining ?? 0;

  int get earnedLeave => getLeaveByType('EARNED')?.quota ?? 0;
  int get earnedUsed => getLeaveByType('EARNED')?.used ?? 0;
  int get earnedRemaining => getLeaveByType('EARNED')?.remaining ?? 0;
}