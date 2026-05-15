// controllers/dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/dashboard/widgets/dashboard_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/fees_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/homework_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/profile_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/schedule_widget.dart';
import 'package:school_app/domain/models/fees_response.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/events_response.dart';
import '../../../domain/models/profile_response.dart';
import 'dashboard_presenter.dart';

class DashboardController extends GetxController {
  DashboardController(this.dashboardPresenter);

  final DashboardPresenter dashboardPresenter;
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardHomeScreen(),
    const HomeWorkWidget(),
    const ScheduleWidget(),
    const FeesDetailsScreen(),
    const ProfileWidget(),
  ];

  var isLoading = false.obs;
  var profileData = Rxn<ProfileData>();
  var feeData = Rxn<FeeResponseModel>(); // For storing fee data
  // Add these variables with other variables
  var eventsData = Rxn<EventsResponseModel>();
  var isEventsLoaded = false.obs;
  var isLoadingEvents = false.obs;

  final GetStorage _storage = GetStorage();

  // Flags to track if APIs have been called already
  var isProfileLoaded = false.obs;
  var isFeesLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Only load profile on home screen if needed, otherwise don't auto-load
    // getProfileDetails(); // REMOVED - Don't auto-load on init
    getAllEvents();
  }

  // Profile API - Call only when Profile tab is clicked
  Future<void> getProfileDetails() async {
    // Don't call if already loaded
    if (isProfileLoaded.value) {
      print("✅ Profile already loaded, skipping API call");
      return;
    }

    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: true,
       // token: token?.toString() ?? '',
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3Nzg4Mzk3NjIsImV4cCI6MTc3OTAxMjU2MiwibmJmIjoxNzc4ODM5NzYyLCJqdGkiOiIwQkJpY2laWU9POHNEQ3RmIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ.qKCZMo6B_m1q370wDk8nwsA3SOfTWjfN2B9brurAcU4',
        branchId: branchId?.toString() ?? '',
        //studentId: studentId?.toString() ?? '',
         studentId: 'af44e29a-b3a2-4445-8e69-f74fcf6637fc', // Use dynamic value
      );

      if (res != null && res.status == true && res.data != null) {
        profileData.value = res.data;

        if (res.data != null) {
          String jsonString = jsonEncode(res.data!.toJson());
          await _storage.write('profile_data', jsonString);
          print("✅ Profile loaded: ${res.data?.personal?.name}");
          isProfileLoaded.value = true;
        }
      } else {
        print("❌ Failed to load profile: ${res?.message}");
      }
    } catch (e) {
      print("Error in getProfileDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fees API - Call only when Fees tab is clicked
  Future<void> getFeesDetails() async {
    if (isFeesLoaded.value) {
      print("✅ Fees already loaded, skipping API call");
      return;
    }

    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      var res = await dashboardPresenter.getFeesDetailsAPI(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3Nzg4Mzk3NjIsImV4cCI6MTc3OTAxMjU2MiwibmJmIjoxNzc4ODM5NzYyLCJqdGkiOiIwQkJpY2laWU9POHNEQ3RmIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ.qKCZMo6B_m1q370wDk8nwsA3SOfTWjfN2B9brurAcU4',
        branchId: branchId?.toString() ?? '',
        studentId: 'af44e29a-b3a2-4445-8e69-f74fcf6637fc',
      );

      print("Response type: ${res?.data.runtimeType}");
      print("Response status: ${res?.status}");

      if (res != null && res.status == true && res.data != null) {

        // FIX: Since data is already FeeData, just wrap it in FeeResponseModel
        if (res.data is FeeData) {
          feeData.value = FeeResponseModel(
            status: true,
            message: "Success",
            data: res.data as FeeData,
          );
          print("✅ Fees loaded - Direct FeeData wrapped");
        }
        // If it's Map, parse it
        else if (res.data is Map<String, dynamic>) {
          feeData.value = FeeResponseModel.fromJson(res.data as Map<String, dynamic>);
          print("✅ Fees loaded - Parsed from Map");
        }
        // If it's already FeeResponseModel
        else if (res.data is FeeResponseModel) {
          feeData.value = res.data as FeeResponseModel;
          print("✅ Fees loaded - Direct model");
        }

        // Verify data
        if (feeData.value != null && feeData.value!.data != null) {
          print("📊 Total Due: ${feeData.value?.data?.cards?.totalDue ?? 0}");
          print("📊 Paid: ${feeData.value?.data?.cards?.paid ?? 0}");
          print("📊 Pending: ${feeData.value?.data?.cards?.pending ?? 0}");
          print("📊 Grand Total Amount: ${feeData.value?.data?.grandTotal?.amount ?? 0}");
          isFeesLoaded.value = true;
        } else {
          print("⚠️ Fee data is null or incomplete");
        }
      } else {
        print("❌ Failed to load fees: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e, stackTrace) {
      print("Error in getFeesDetails: $e");
      print("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

// Fixed method for getAllEvents
  Future<void> getAllEvents() async {
    if (isEventsLoaded.value) {
      print("✅ Events already loaded, skipping API call");
      return;
    }

    try {
      isLoadingEvents.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      // ✅ Call correct API - getAllEventsAPI, not getFeesDetailsAPI
      var res = await dashboardPresenter.getAllEvents(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3Nzg4Mzk3NjIsImV4cCI6MTc3OTAxMjU2MiwibmJmIjoxNzc4ODM5NzYyLCJqdGkiOiIwQkJpY2laWU9POHNEQ3RmIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ.qKCZMo6B_m1q370wDk8nwsA3SOfTWjfN2B9brurAcU4',
        branchId: branchId?.toString() ?? '',
        studentId: 'af44e29a-b3a2-4445-8e69-f74fcf6637fc',
      );

      print("📡 Events Response type: ${res?.message}");
      print("📡 Events Response status: ${res?.status}");

      if (res != null && res.status == true && res.data != null) {

        // ✅ Handle EventsResponseModel correctly
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
          print("✅ Events loaded - Direct model");
        }
        // If it's Map, parse it
        else if (res.data is Map<String, dynamic>) {
          eventsData.value = EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
          print("✅ Events loaded - Parsed from Map");
        }
        // If data is EventsData directly
        else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true,
            message: "Success",
            data: res.data as EventsData,
          );
          print("✅ Events loaded - Direct EventsData wrapped");
        }

        // Verify data
        if (eventsData.value != null && eventsData.value!.data != null) {
          print("📊 Total Events: ${eventsData.value?.data?.total ?? 0}");
          print("📊 Events Count: ${eventsData.value?.data?.events?.length ?? 0}");
          print("📊 Current Page: ${eventsData.value?.data?.currentPage ?? 0}");
          isEventsLoaded.value = true;
        } else {
          print("⚠️ Events data is null or incomplete");
        }
      } else {
        print("❌ Failed to load events: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e, stackTrace) {
      print("Error in getAllEvents: $e");
      print("Stack trace: $stackTrace");
    } finally {
      isLoadingEvents.value = false;
    }
  }

// Method to refresh events
  Future<void> refreshEvents() async {
    isEventsLoaded.value = false;
    eventsData.value = null;
    await getAllEvents();
  }
  void changeNavIndex(int index) {
    print("Changing index to: $index");
    selectedIndex.value = index;

    // Call respective APIs based on selected tab
    switch (index) {
      case 0: // Home Tab - No API calls
        print("🏠 Home tab selected - No API call");
        break;
      case 1: // Homework Tab
        print("📚 Homework tab selected");
        // Add homework API call if needed
        break;
      case 2: // Schedule Tab
        print("📅 Schedule tab selected");
        // Add schedule API call if needed
        break;
      case 3: // Fees Tab - Call fees API
        print("💰 Fees tab selected - Loading fees data");
        getFeesDetails();
        break;
      case 4: // Profile Tab - Call profile API
        print("👤 Profile tab selected - Loading profile data");
        getProfileDetails();
        break;
    }

    update();
  }

  // Method to manually refresh fees data (e.g., on pull-to-refresh)
  Future<void> refreshFeesData() async {
    isFeesLoaded.value = false; // Reset flag to allow refresh
    await getFeesDetails();
  }

  // Method to manually refresh profile data
  Future<void> refreshProfileData() async {
    isProfileLoaded.value = false; // Reset flag to allow refresh
    await getProfileDetails();
  }

  Widget getCurrentScreen() {
    return screens[selectedIndex.value];
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}