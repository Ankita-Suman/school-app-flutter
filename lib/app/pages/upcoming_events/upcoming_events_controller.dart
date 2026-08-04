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
      debugPrint("✅ Events already loaded, skipping API call");
      return;
    }

    try {
      isLoadingEvents.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      var studentId =
          await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      // ✅ Call correct API - getAllEventsAPI, not getFeesDetailsAPI
      var res = await upcomingEventsPresenter.getAllEvents(
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );
      if (res != null && res.status == true && res.data != null) {
        // ✅ Handle EventsResponseModel correctly
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        }
        // If it's Map, parse it
        else if (res.data is Map<String, dynamic>) {
          eventsData.value =
              EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        }
        // If data is EventsData directly
        else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true,
            message: "Success",
            data: res.data as EventsData,
          );
        }

        // Verify data
        if (eventsData.value != null && eventsData.value!.data != null) {
          isEventsLoaded.value = true;
        } else {
          debugPrint("⚠️ Events data is null or incomplete");
        }
      } else {
        debugPrint("❌ Failed to load events: ${res?.message ?? 'Unknown error'}");
      }
    } catch (e, stackTrace) {
      debugPrint("Error in getAllEvents: $e");
    } finally {
      isLoadingEvents.value = false;
    }
  }
}
