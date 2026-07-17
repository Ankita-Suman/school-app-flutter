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
      print("📡📡📡 fetchLateArrivals START - FILTER: $filter 📡📡📡");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoading.value = false;
        return;
      }

      var res = await lateArrivalsPresenter.getLateArrivalData(
        isLoading: false,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODM5Njc5OTYsImV4cCI6MTc4NDE0MDc5NiwibmJmIjoxNzgzOTY3OTk2LCJqdGkiOiJDNUE4YW1Gb0FqOTFEa0JCIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.vr39Y0QMHVdAC0gc0B3B3K-wyEp2NL3uAmaZHAL-1Ps',
        branchId: '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a',
        filter: filter, // Pass filter: today, week, month
      );

      print("📡📡📡 RESPONSE STATUS: ${res?.status}");
      print("📡📡📡 RESPONSE DATA: ${res?.data}");

      if (res != null && res.status == true && res.data != null) {
        lateArrivalData.value = res;

        // Store late arrivals
        if (res.data!.data != null) {
          allLateArrivals.value = res.data!.data!;
          print("✅ Late arrivals loaded: ${allLateArrivals.length}");

          for (var arrival in allLateArrivals) {
            print("📚 ${arrival.studentName} - ${arrival.formattedDate} - ${arrival.statusDisplay}");
          }
        }

        print("✅ Late arrivals loaded successfully");
      } else {
        print("❌ Failed to load late arrivals: ${res?.message}");
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load late arrivals data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error in fetchLateArrivals: $e");
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

  @override
  void onClose() {
    super.onClose();
  }
}