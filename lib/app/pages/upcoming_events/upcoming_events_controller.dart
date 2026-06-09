// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/upcoming_events/upcoming_events_presenter.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/events_response.dart';

class UpcomingEventsController extends GetxController {
  UpcomingEventsController(this.upcomingEventsPresenter);

  final UpcomingEventsPresenter upcomingEventsPresenter;

  // Add these variables with other variables
  var eventsData = Rxn<EventsResponseModel>();
  var isEventsLoaded = false.obs;
  var isLoadingEvents = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Only load profile on home screen if needed, otherwise don't auto-load
    // getProfileDetails(); // REMOVED - Don't auto-load on init
    getAllEvents();
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
      var res = await upcomingEventsPresenter.getAllEvents(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3NzkxMDcwODIsImV4cCI6MTc3OTI3OTg4MiwibmJmIjoxNzc5MTA3MDgyLCJqdGkiOiJWYzE5bGZoRnc4cm1oMjliIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ._jQ-IOsQzOvc2ZizF7OvdAj5qncGrs8_NuNCRUGrF-c',
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
}