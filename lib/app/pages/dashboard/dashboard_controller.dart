// controllers/teacher_dashboard_controller.dart

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
    print("🔵🔵🔵 DASHBOARD CONTROLLER onInit START 🔵🔵🔵");
    // ❌ No cache loading - remove loadCachedData()
    print("🔵🔵🔵 DASHBOARD CONTROLLER onInit END 🔵🔵🔵");
  }

  @override
  void onReady() {
    super.onReady();
    print("🟢🟢🟢 DASHBOARD CONTROLLER onReady START 🟢🟢🟢");

    // Load home tab data on app start
    getProfileDetailsWithoutLoader();
    getAllEventsWithLoader();

    print("🟢🟢🟢 DASHBOARD CONTROLLER onReady END 🟢🟢🟢");
  }

  // ==================== PROFILE API (Home Tab) ====================

  Future<void> getProfileDetailsWithoutLoader() async {
    print("👤👤👤 getProfileDetailsWithoutLoader START 👤👤👤");
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token == null || token.isEmpty || studentId == null || studentId.isEmpty) {
        print("❌ Missing required data for profile");
        return;
      }

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: false,
        token: token.toString(),
        branchId: branchId?.toString() ?? '',
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;
        print("✅ Profile loaded: ${res.data?.personal?.name}");
      } else {
        print("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getProfileDetailsWithoutLoader: $e");
    }
    print("👤👤👤 getProfileDetailsWithoutLoader END 👤👤👤");
  }

  // ==================== PROFILE API WITH LOADER (Profile Tab) ====================

  Future<void> getProfileDetailsWithLoader() async {
    try {
      isLoadingProfile.value = true;
      print("📡📡📡 getProfileDetailsWithLoader START - API HIT WITH LOADER 📡📡📡");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoadingProfile.value = false;
        return;
      }

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: true,
        token: token.toString(),
        branchId: branchId?.toString() ?? '',
        studentId: studentId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;
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

  // ==================== EVENTS API (Home Tab) ====================

  Future<void> getAllEventsWithLoader() async {
    print("📅📅📅 getAllEventsWithLoader START 📅📅📅");
    try {
      isLoadingEvents.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token == null || token.isEmpty) {
        print("❌ No token, cannot fetch events");
        isLoadingEvents.value = false;
        return;
      }

      var res = await dashboardPresenter.getAllEvents(
        isLoading: true,
        token: token.toString(),
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

        print("📊 Events Count: ${eventsData.value?.data?.events?.length ?? 0}");
      } else {
        print("❌ Failed to load events: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      print("❌ Error in getAllEventsWithLoader: $e");
    } finally {
      isLoadingEvents.value = false;
    }
    print("📅📅📅 getAllEventsWithLoader END 📅📅📅");
  }

  // ==================== FEES API (Fees Tab) ====================

  Future<void> getFeesDetails() async {
    try {
      isLoadingFees.value = true;
      print("💰💰💰 getFeesDetails START - API HIT WITH LOADER 💰💰💰");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token == null || token.isEmpty) {
        print("❌ No token, cannot fetch fees");
        isLoadingFees.value = false;
        return;
      }

      var res = await dashboardPresenter.getFeesDetailsAPI(
        isLoading: true,
        token: token.toString(),
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

        print("💰 Fees loaded successfully");
      } else {
        print("❌ Failed to load fees: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getFeesDetails: $e");
    } finally {
      isLoadingFees.value = false;
    }
    print("💰💰💰 getFeesDetails END 💰💰💰");
  }

  // ==================== NAVIGATION ====================

  void changeNavIndex(int index) {
    print("🔄🔄🔄 changeNavIndex CALLED: index = $index 🔄🔄🔄");
    selectedIndex.value = index;
    update();

    // ✅ Fresh API call on every tab click with loader
    switch (index) {
      case 0: // Home Tab
        print("🏠 Home tab selected - Loading fresh data");
        getProfileDetailsWithoutLoader();
        getAllEventsWithLoader();
        break;
      case 1: // Homework Tab
        print("📚 Homework tab selected");
        break;
      case 2: // Fees Tab
        print("💰 Fees tab selected - Loading fresh data with loader");
        getFeesDetails();  // ✅ Fresh API every time
        break;
      case 3: // Profile Tab
        print("👤 Profile tab selected - Loading fresh data with loader");
        getProfileDetailsWithLoader();  // ✅ Fresh API every time
        break;
      case 4: // More Tab
        print("📱 More tab selected - Loading fresh data");
        // More tab can also load fresh data if needed
        break;
    }
  }

  Widget getCurrentScreen() {
    return screens[selectedIndex.value];
  }

  // ==================== LOGOUT ====================

  Future<void> logoutAPI({required bool isLoading}) async {
    var deviceRepo = Get.find<DeviceRepository>();
    var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
    try {
      Utility.showLoader();
      try {
        var res = await dashboardPresenter.logoutAPI(isLoading: isLoading,token:token);
        debugPrint('Logout response: $res');
      } catch (apiError) {
        print("Logout API error: $apiError");
      }
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    } catch (e) {
      print("Logout error: $e");
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    }
  }

  Future<void> _clearAllStorageData() async {
    try {
      var repo = Get.find<DeviceRepository>();
      await repo.deleteAllSecuredValues();
      await repo.deleteSecuredValue(DeviceConstants.token);
      await repo.deleteSecuredValue(DeviceConstants.branchId);
      await repo.deleteSecuredValue(DeviceConstants.branchCode);
      await repo.deleteSecuredValue(DeviceConstants.email);
      await repo.deleteSecuredValue(DeviceConstants.username);
      await repo.deleteSecuredValue(DeviceConstants.studentId);
      await repo.deleteSecuredValue(DeviceConstants.profileData);
      await repo.deleteBox();

      await _storage.remove('profile_data');
      await _storage.remove('events_data');
      await _storage.remove('fees_data');

      print("All storage data cleared successfully");
    } catch (e) {
      print("Error in _clearAllStorageData: $e");
    }
  }

  @override
  void onClose() {
    print("🔴🔴🔴 DASHBOARD CONTROLLER onClose CALLED 🔴🔴🔴");
    super.onClose();
  }
}