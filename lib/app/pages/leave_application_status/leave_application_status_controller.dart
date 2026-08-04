// pages/login/staff_leave_history_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/leave_application_status_response.dart';
import 'leave_application_status_presenter.dart';

class LeaveApplicationStatusController extends GetxController {
  LeaveApplicationStatusController(this.leaveStatusPresenter);

  final LeaveApplicationStatusPresenter leaveStatusPresenter;

  var isLoading = false.obs;
  var leaveStatusData = Rxn<LeaveApplicationsResponse>();
  var allLeaveApplications = <LeaveApplication>[].obs;

  // Tab selection
  var selectedTab = 0.obs; // 0 = Today, 1 = This Week, 2 = This Month

  @override
  void onInit() {
    super.onInit();
    // By default, load today's leave applications
    fetchLeaveApplications(filter: 'today');
  }

  // ========== FETCH LEAVE APPLICATIONS WITH FILTER ==========
  Future<void> fetchLeaveApplications({required String filter}) async {
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

      var res = await leaveStatusPresenter.getLeaveStatusData(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
        filter: filter, // Pass filter: today, week, month
      );

      if (res != null && res.status == true && res.data != null) {
        leaveStatusData.value = res;

        // Store leave applications
        if (res.data!.data != null) {
          allLeaveApplications.value = res.data!.data!;
          for (var application in allLeaveApplications) {
            debugPrint(
                "📚 ${application.studentName} - ${application.formattedDate} - ${application.statusDisplay}");
          }
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load leave applications data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading leave applications.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== CHANGE TAB ==========
  void changeTab(int tabIndex) {
    selectedTab.value = tabIndex;

    String filter;
    switch (tabIndex) {
      case 0:
        filter = 'today';
        break;
      case 1:
        filter = 'week';
        break;
      case 2:
        filter = 'month';
        break;
      default:
        filter = 'today';
    }

    fetchLeaveApplications(filter: filter);
  }

  // ========== GETTERS ==========
  List<LeaveApplication> get leaveApplications => allLeaveApplications;

  bool get hasData => allLeaveApplications.isNotEmpty;

  int get totalCount => leaveStatusData.value?.data?.total ?? 0;

  bool get isLoadingData => isLoading.value;
}