// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

class ChangePasswordSuccessfullyController extends GetxController {
  var animationValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
    // Auto‑navigate after 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      goToHome();
    });
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      animationValue.value = 1.0;
    });
  }

  double get scaleValue => 0.5 + (animationValue.value * 0.5);
  double get opacityValue => animationValue.value;

  // ✅ Role‑based navigation
  Future<void> goToHome() async {
    try {
      final deviceRepo = Get.find<DeviceRepository>();
      final role = await deviceRepo.getSecuredValue(DeviceConstants.userRole);

      if (role == 'student') {
        RouteManagement.goToHome();
      } else if (role == 'staff') {
        RouteManagement.goToTeacherDashboard();
      } else if (role == 'parent') {
        // Optionally show "Coming Soon" or fallback
        Get.defaultDialog(
          title: 'Coming Soon',
          middleText: 'Parent dashboard will be available soon.',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue.shade700,
          onConfirm: () => Get.back(),
        );
      } else {
        // Fallback: go to login if role is unknown
        RouteManagement.goToLogin();
      }
    } catch (e) {
      // If any error occurs, go to login as fallback
      RouteManagement.goToLogin();
    }
  }
}