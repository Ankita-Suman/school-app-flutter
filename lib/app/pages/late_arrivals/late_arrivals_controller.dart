// pages/login/late_arrivals_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/late_arrivals_response.dart';
import 'late_arrivals_presenter.dart';

class LateArrivalsController extends GetxController {
  LateArrivalsController(this.lateArrivalsPresenter);

  final LateArrivalsPresenter lateArrivalsPresenter;

  var isLoading = false.obs;
  var lateArrivalData = Rxn<LateArrivalsResponse>();
  var allLateArrivals = <LateArrival>[].obs;

  // Tab selection
  var selectedTab = 0.obs; // 0 = Today, 1 = This Week, 2 = This Month

  @override
  void onInit() {
    super.onInit();
    // By default, load today's late arrivals
    fetchLateArrivals(filter: 'today');
  }

  // ========== FETCH LATE ARRIVALS WITH FILTER ==========
  Future<void> fetchLateArrivals({required String filter}) async {
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

      var res = await lateArrivalsPresenter.getLateArrivalData(
        isLoading: false,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
        filter: filter, // Pass filter: today, week, month
      );

      if (res != null && res.status == true && res.data != null) {
        lateArrivalData.value = res;

        // Store late arrivals
        if (res.data!.data != null) {
          allLateArrivals.value = res.data!.data!;
          for (var arrival in allLateArrivals) {
            debugPrint(
                "📚 ${arrival.studentName} - ${arrival.formattedDate} - ${arrival.statusDisplay}");
          }
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load late arrivals data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading late arrivals.',
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

    fetchLateArrivals(filter: filter);
  }

  // ========== GETTERS ==========
  List<LateArrival> get lateArrivals => allLateArrivals;

  bool get hasData => allLateArrivals.isNotEmpty;

  int get totalCount => lateArrivalData.value?.data?.total ?? 0;

  bool get isLoadingData => isLoading.value;
}