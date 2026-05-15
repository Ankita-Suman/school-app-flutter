// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';

class ChangePasswordSuccessfullyController extends GetxController {
  // controllers/password_changed_controller.dart
  var animationValue = 0.0.obs;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void onInit() {
  super.onInit();
  startAnimation();
  }

  void startAnimation() {
  // Simulate animation delay
  Future.delayed(const Duration(milliseconds: 500), () {
  animationValue.value = 1.0;
  });
  }

  double get scaleValue => 0.5 + (animationValue.value * 0.5);
  double get opacityValue => animationValue.value;

  void goToHome() {
  // Navigate to home screen
  RouteManagement.goToHome();
  // Or Get.offAll(() => const DashboardScreen());
  }

  @override
  void onClose() {
  super.onClose();
  }

}