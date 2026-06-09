// controllers/dashboard_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/dashboard/widgets/dashboard_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/fees_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/homework_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/profile_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/more_widget.dart';
import 'package:school_app/domain/models/fees_response.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/events_response.dart';
import '../../../domain/models/profile_response.dart';
import '../../navigators/routes_management.dart';
import '../../utils/utility.dart';
import 'dashboard_presenter.dart';

class DashboardController extends GetxController {
  DashboardController(this.dashboardPresenter);

  final DashboardPresenter dashboardPresenter;
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardHomeScreen(),
    const HomeWorkWidget(),
    const FeesDetailsScreen(),
    const ProfileWidget(),
    const MoreWidget(),
  ];

  var isLoading = false.obs;
  var profileData = Rxn<ProfileData>();
  var feeData = Rxn<FeeResponseModel>();
  var eventsData = Rxn<EventsResponseModel>();

  // Loading flags
  var isLoadingEvents = false.obs;
  var isLoadingProfile = false.obs;
  var isLoadingFees = false.obs;

  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Load cached data first (for immediate display)
    loadCachedData();
    // First time: Profile without loader, Events with loader
    getProfileDetailsWithoutLoader();
    getAllEventsWithLoader();
  }

  // ==================== CACHE METHODS ====================

  void loadCachedData() {
    try {
      // Load cached profile
      String? cachedProfile = _storage.read('profile_data');
      if (cachedProfile != null) {
        Map<String, dynamic> profileMap = jsonDecode(cachedProfile);
        profileData.value = ProfileData.fromJson(profileMap);
        print("✅ Loaded profile from cache");
      }

      // Load cached events
      String? cachedEvents = _storage.read('events_data');
      if (cachedEvents != null) {
        Map<String, dynamic> eventsMap = jsonDecode(cachedEvents);
        eventsData.value = EventsResponseModel.fromJson(eventsMap);
        print("✅ Loaded events from cache");
      }

      // Load cached fees
      String? cachedFees = _storage.read('fees_data');
      if (cachedFees != null) {
        Map<String, dynamic> feesMap = jsonDecode(cachedFees);
        feeData.value = FeeResponseModel.fromJson(feesMap);
        print("✅ Loaded fees from cache");
      }
    } catch (e) {
      print("Error loading cached data: $e");
    }
  }

  // ==================== PROFILE API METHODS ====================

  // ✅ Profile API - Without Loader (First time / Home tab)
  Future<void> getProfileDetailsWithoutLoader() async {
    try {
      print("📡 Fetching profile WITHOUT loader");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: false,
        token: token?.toString() ?? '',
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;

        String jsonString = jsonEncode(res.data!.toJson());
        await _storage.write('profile_data', jsonString);
        print("✅ Profile loaded: ${res.data?.personal?.name}");
      } else {
        print("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      print("Error in getProfileDetailsWithoutLoader: $e");
    }
  }

  // ✅ Profile API - With Loader (Profile tab click / Refresh)
  Future<void> getProfileDetailsWithLoader() async {
    try {
      isLoadingProfile.value = true;
      print("📡 Fetching profile WITH loader");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: true,
        token: token?.toString() ?? '',
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;

        String jsonString = jsonEncode(res.data!.toJson());
        await _storage.write('profile_data', jsonString);
        print("✅ Profile loaded: ${res.data?.personal?.name}");
      } else {
        print("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      print("Error in getProfileDetailsWithLoader: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ==================== EVENTS API METHODS ====================

  // ✅ Events API - With Loader (First time / Home tab)
  Future<void> getAllEventsWithLoader() async {
    try {
      isLoadingEvents.value = true;
      print("📡 Fetching events WITH loader");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getAllEvents(
        isLoading: true,
        token: token?.toString() ?? '',
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          eventsData.value = EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true,
            message: "Success",
            data: res.data as EventsData,
          );
        }

        if (eventsData.value != null && eventsData.value!.data != null) {
          String jsonString = jsonEncode(eventsData.value!.toJson());
          await _storage.write('events_data', jsonString);
          print("📊 Events Count: ${eventsData.value?.data?.events?.length ?? 0}");
        }
      } else {
        print("❌ Failed to load events: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error in getAllEventsWithLoader: $e");
    } finally {
      isLoadingEvents.value = false;
    }
  }

  Future<void> logoutAPI({
    required bool isLoading,
  }) async {
    try {
      Utility.showLoader();

      // Try to call logout API (optional - don't wait if it fails)
      try {
        var res = await dashboardPresenter.logoutAPI(isLoading: isLoading);
        debugPrint('Logout response: $res');
      } catch (apiError) {
        print("Logout API error: $apiError");
        // Continue with cleanup even if API fails
      }

      // Clear all stored data
      await _clearAllStorageData();

      Utility.closeLoader();

      // Navigate to login screen
      RouteManagement.goToLogin();
      update();

    } catch (e) {
      print("Logout error: $e");

      // Force clear storage even if something fails
      await _clearAllStorageData();

      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    }
  }

// Helper method to clear all storage data
  Future<void> _clearAllStorageData() async {
    try {
      var repo = Get.find<DeviceRepository>();

      // Clear all secured values
      await repo.deleteAllSecuredValues();

      // Clear individual values (double ensure)
      await repo.deleteSecuredValue(DeviceConstants.token);
      await repo.deleteSecuredValue(DeviceConstants.branchId);
      await repo.deleteSecuredValue(DeviceConstants.branchCode);
      await repo.deleteSecuredValue(DeviceConstants.email);
      await repo.deleteSecuredValue(DeviceConstants.username);
      await repo.deleteSecuredValue(DeviceConstants.studentId);
      await repo.deleteSecuredValue(DeviceConstants.profileData);

      // Clear Hive box
      await repo.deleteBox();

      // Clear any other cached data
      //await repo.clearCache(); // If available

      print("All storage data cleared successfully");

    } catch (e) {
      print("Error in _clearAllStorageData: $e");
    }
  }

  // ✅ Events API - Without Loader (Refresh only if needed)
  Future<void> getAllEventsWithoutLoader() async {
    try {
      print("📡 Fetching events WITHOUT loader");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getAllEvents(
        isLoading: false,
        token: token?.toString() ?? '',
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          eventsData.value = EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true,
            message: "Success",
            data: res.data as EventsData,
          );
        }

        if (eventsData.value != null && eventsData.value!.data != null) {
          String jsonString = jsonEncode(eventsData.value!.toJson());
          await _storage.write('events_data', jsonString);
          print("📊 Events Count: ${eventsData.value?.data?.events?.length ?? 0}");
        }
      }
    } catch (e) {
      print("Error in getAllEventsWithoutLoader: $e");
    }
  }

  // ==================== FEES API METHODS ====================

  // ✅ Fees API - With Loader (Every time)
  Future<void> getFeesDetails() async {
    try {
      isLoadingFees.value = true;
      print("📡 Fetching fees WITH loader");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getFeesDetailsAPI(
        isLoading: true,
        token: token?.toString() ?? '',
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is FeeData) {
          feeData.value = FeeResponseModel(
            status: true,
            message: "Success",
            data: res.data as FeeData,
          );
        } else if (res.data is Map<String, dynamic>) {
          feeData.value = FeeResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is FeeResponseModel) {
          feeData.value = res.data as FeeResponseModel;
        }

        if (feeData.value != null && feeData.value!.data != null) {
          String jsonString = jsonEncode(feeData.value!.toJson());
          await _storage.write('fees_data', jsonString);
          print("💰 Fees loaded successfully");
        }
      }
    } catch (e) {
      print("Error in getFeesDetails: $e");
    } finally {
      isLoadingFees.value = false;
    }
  }

  // ==================== REFRESH METHODS ====================

  Future<void> refreshProfile() async {
    print("🔄 Refreshing profile...");
    await getProfileDetailsWithLoader();
  }

  Future<void> refreshEvents() async {
    print("🔄 Refreshing events...");
    await getAllEventsWithLoader();
  }

  Future<void> refreshFees() async {
    print("🔄 Refreshing fees...");
    await getFeesDetails();
  }

  // ==================== NAVIGATION METHODS ====================

  void changeNavIndex(int index) {
    print("Changing index to: $index");
    selectedIndex.value = index;

    switch (index) {
      case 0: // Home Tab
        print("🏠 Home tab selected");
        // Profile WITHOUT loader
        getProfileDetailsWithoutLoader();
        // Events WITH loader
        getAllEventsWithLoader();
        break;

      case 1: // Homework Tab
        print("📚 Homework tab selected");
        break;

      case 2: // Schedule Tab
        print("📅 Schedule tab selected");
        break;

      case 3: // Fees Tab
        print("💰 Fees tab selected - Fetching fresh data WITH loader");
        getFeesDetails();
        break;

      case 4: // Profile Tab
        print("👤 Profile tab selected - Fetching fresh data WITH loader");
        getProfileDetailsWithLoader();
        break;
    }

    update();
  }

  Widget getCurrentScreen() {
    return screens[selectedIndex.value];
  }

  @override
  void onClose() {
    super.onClose();
  }
}