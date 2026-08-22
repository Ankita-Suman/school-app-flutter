// controllers/new_otp_verification_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../navigators/routes_management.dart';
import 'new_otp_verification_presenter.dart';

class NewOtpVerificationController extends GetxController {
  NewOtpVerificationController(this.otpVerificationPresenter);

  final NewOtpVerificationPresenter otpVerificationPresenter;

  var isFocused = false.obs;
  var hasText = false.obs;

  int counter = 30;
  bool enableResend = false;
  late Timer timer;
  String email = '';
  String storedOtp = '';

  var isOtpComplete = false.obs;
  var otpError = ''.obs; // ✅ inline error

  final pinController = TextEditingController();
  final otpFormKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    startOtpTimer();

    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
      // Clear error when focused
      if (focusNode.hasFocus) {
        otpError.value = '';
      }
    });

    pinController.addListener(() {
      hasText.value = pinController.text.isNotEmpty;
      // Clear error on text change
      if (pinController.text.isNotEmpty) {
        otpError.value = '';
      }
    });

    pinController.addListener(_onPinChanged);
  }

  Future<void> getUserData() async {
    var deviceRepo = Get.find<DeviceRepository>();
    storedOtp = await deviceRepo.getSecuredValue(DeviceConstants.otp);

    if (storedOtp.isNotEmpty && storedOtp.length == 4) {
      pinController.text = storedOtp;
      _onPinChanged();
    }

    update();
  }

  void startOtpTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    otpTimer();
  }

  void _onPinChanged() {
    isOtpComplete.value = pinController.text.length == 4;
    if (pinController.text.length == 4) {
      otpError.value = ''; // clear error when complete
    }
    update();
  }

  void otpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (counter == 0) {
        enableResend = true;
        timer.cancel();
        update();
      } else {
        counter--;
        update();
      }
    });
  }

  void resendCode() {
    counter = 30;
    enableResend = false;
    update();
  }

  // ✅ Resend OTP – no red snackbars, inline error
  void resendOTP() async {
    var deviceRepo = Get.find<DeviceRepository>();
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode =
    await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    pinController.clear();
    isOtpComplete.value = false;
    otpError.value = ''; // clear previous error

    try {
      isLoading.value = true;

      var res = await otpVerificationPresenter.resendOtpAPI(
        isLoading: true,
        login: username.toString(),
        branchCode: branchCode.toString(),
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        counter = 30;
        enableResend = false;
        otpTimer();

        if (res.data?.otp != null) {
          storedOtp = res.data!.otp!;
          await deviceRepo.saveValueSecurely(DeviceConstants.otp, storedOtp);
          pinController.text = storedOtp;
          isOtpComplete.value = true;
        }
        update();
        // No snackbar – success is shown by auto‑fill and navigation will happen on verification
      } else {
        otpError.value = res?.message ?? 'Failed to resend OTP. Please try again.';
        update();
      }
    } catch (e) {
      isLoading.value = false;
      otpError.value = 'Network error. Please try again.';
      update();
    }
  }

  // ✅ Verify OTP – no red snackbars, inline error
  Future<void> verifyOtpAPI() async {
    String otp = pinController.text.trim();

    if (otp.isEmpty || otp.length != 4) {
      otpError.value = 'Please enter a valid 4‑digit OTP';
      update();
      return;
    }

    var deviceRepo = Get.find<DeviceRepository>();
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode =
    await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    try {
      isLoading.value = true;
      otpError.value = ''; // clear any previous error

      var res = await otpVerificationPresenter.verifyOtpAPI(
        isLoading: true,
        login: username.toString(),
        branchCode: branchCode.toString(),
        otp: otp,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        if (res.data?.resetToken != null) {
          var deviceRepository = Get.find<DeviceRepository>();
          await deviceRepository.saveValueSecurely(
              DeviceConstants.resetToken, res.data!.resetToken!);
        }

        // Success – navigate without snackbar
        RouteManagement.goToChangePassword();
      } else {
        otpError.value = res?.message ?? 'OTP verification failed. Please try again.';
        update();
      }
    } catch (e) {
      isLoading.value = false;
      otpError.value = 'Network error. Please try again.';
      update();
    }
  }

  @override
  void onClose() {
    timer.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}