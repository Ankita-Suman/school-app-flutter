// controllers/teacher_dashboard_controller.dart

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
  void onReady() {
    super.onReady();
    getProfileDetailsWithoutLoader();
    getAllEventsWithLoader();
  }

  // ==================== PROFILE API (Home Tab) ====================

  Future<void> getProfileDetailsWithoutLoader() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId =
          await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.isEmpty ||
          studentId.isEmpty) {
        return;
      }

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true) {
        profileData.value = res.data;
      } else {
        debugPrint("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      debugPrint("❌ Error in getProfileDetailsWithoutLoader: $e");
    }
    debugPrint("👤👤👤 getProfileDetailsWithoutLoader END 👤👤👤");
  }

  // ==================== PROFILE API WITH LOADER (Profile Tab) ====================

  Future<void> getProfileDetailsWithLoader() async {
    try {
      isLoadingProfile.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId =
          await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.isEmpty) {
        isLoadingProfile.value = false;
        return;
      }
      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: true,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString() ,
      );

      if (res != null && res.status == true) {
        profileData.value = res.data;
      } else {
        debugPrint("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      debugPrint("Error in getProfileDetailsWithLoader: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ==================== EVENTS API (Home Tab) ====================

  Future<void> getAllEventsWithLoader() async {
    try {
      isLoadingEvents.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId =
          await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.isEmpty) {
        isLoadingEvents.value = false;
        return;
      }

      var res = await dashboardPresenter.getAllEvents(
        isLoading: true,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          eventsData.value =
              EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true,
            message: "Success",
            data: res.data as EventsData,
          );
        }
      } else {
        debugPrint("❌ Failed to load events: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      debugPrint("❌ Error in getAllEventsWithLoader: $e");
    } finally {
      isLoadingEvents.value = false;
    }
    debugPrint("📅📅📅 getAllEventsWithLoader END 📅📅📅");
  }

  // ==================== FEES API (Fees Tab) ====================

  Future<void> getFeesDetails() async {
    try {
      isLoadingFees.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId =
          await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.isEmpty) {
        isLoadingFees.value = false;
        return;
      }

      var res = await dashboardPresenter.getFeesDetailsAPI(
        isLoading: true,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is FeeData) {
          feeData.value = FeeResponseModel(
            status: true,
            message: "Success",
            data: res.data as FeeData,
          );
        } else if (res.data is Map<String, dynamic>) {
          feeData.value =
              FeeResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is FeeResponseModel) {
          feeData.value = res.data as FeeResponseModel;
        }
      } else {
        debugPrint("❌ Failed to load fees: ${res?.message}");
      }
    } catch (e) {
      debugPrint("❌ Error in getFeesDetails: $e");
    } finally {
      isLoadingFees.value = false;
    }
    debugPrint("💰💰💰 getFeesDetails END 💰💰💰");
  }

  // ==================== NAVIGATION ====================

  void changeNavIndex(int index) {
    selectedIndex.value = index;
    update();

    // ✅ Fresh API call on every tab click with loader
    switch (index) {
      case 0: // Home Tab
        getProfileDetailsWithoutLoader();
        getAllEventsWithLoader();
        break;
      case 1: // Homework Tab
        showComingSoonDialog();
        break;
      case 2: // Fees Tab
        getFeesDetails(); // ✅ Fresh API every time
        break;
      case 3: // Profile Tab
        getProfileDetailsWithLoader(); // ✅ Fresh API every time
        break;
      case 4: // More Tab
        debugPrint("📱 More tab selected - Loading fresh data");
        // More tab can also load fresh data if needed
        break;
    }
  }
  void showComingSoonDialog() {
    Get.defaultDialog(
      title: 'Coming Soon',
      middleText: 'This feature will be available in the upcoming release.',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue.shade700,
      onConfirm: () => Get.back(),
    );
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
        var res = await dashboardPresenter.logoutAPI(
            isLoading: isLoading, token: token);
        debugPrint('Logout response: $res');
      } catch (apiError) {
        debugPrint("Logout API error: $apiError");
      }
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    } catch (e) {
      debugPrint("Logout error: $e");
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
    } catch (e) {
      debugPrint("Error in _clearAllStorageData: $e");
    }
  }

  @override
  void onClose() {
    debugPrint("🔴🔴🔴 DASHBOARD CONTROLLER onClose CALLED 🔴🔴🔴");
    super.onClose();
  }
}
