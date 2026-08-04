// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/leave_request_status_response.dart';
import 'approval_status_presenter.dart';

class ApprovalStatusController extends GetxController {
  ApprovalStatusController(this.approvalStatusPresenter);

  final ApprovalStatusPresenter approvalStatusPresenter;

  var isLoading = false.obs;
  var leaveRequestsData = Rxn<LeaveRequestsResponse>();

  // Tab index
  var selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getLeaveApprovalStatusAPI();
  }

  // ========== FETCH LEAVE REQUESTS ==========
  Future<void> getLeaveApprovalStatusAPI() async {
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

      var res = await approvalStatusPresenter.getLeaveApprovalStatusAPI(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
      );

      if (res != null && res.status == true && res.data != null) {
        leaveRequestsData.value = res;
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load leave requests.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading leave requests.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTERS ==========
  bool get hasData => leaveRequestsData.value?.data != null;
  List<LeaveRequest> get allRequests => leaveRequestsData.value?.data?.items ?? [];

  // Filtered lists
  List<LeaveRequest> get pendingRequests =>
      allRequests.where((item) => item.isPending).toList();

  List<LeaveRequest> get approvedRequests =>
      allRequests.where((item) => item.isApproved).toList();

  List<LeaveRequest> get rejectedRequests =>
      allRequests.where((item) => item.isRejected).toList();

  // Current list based on selected tab
  List<LeaveRequest> get currentList {
    switch (selectedTab.value) {
      case 0:
        return pendingRequests;
      case 1:
        return approvedRequests;
      case 2:
        return rejectedRequests;
      default:
        return allRequests;
    }
  }

  // Tab labels
  List<String> get tabLabels => ['Pending', 'Approved', 'Rejected'];

  // Counts for badges
  int get pendingCount => pendingRequests.length;
  int get approvedCount => approvedRequests.length;
  int get rejectedCount => rejectedRequests.length;

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }
}