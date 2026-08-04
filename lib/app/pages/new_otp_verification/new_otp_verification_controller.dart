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

  // For Pinput styling
  var isFocused = false.obs;
  var hasText = false.obs;

  // Same as old class - int counter
  int counter = 30;
  bool enableResend = false;
  late Timer timer;
  String email = '';
  String storedOtp = '';

  // Observable for button state
  var isOtpComplete = false.obs;

  // PIN controller
  final pinController = TextEditingController();
  final otpFormKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    startOtpTimer();

    // Focus listener
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });

    // Text listener
    pinController.addListener(() {
      hasText.value = pinController.text.isNotEmpty;
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

  // ✅ Fixed Resend OTP Method
  void resendOTP() async {
    var deviceRepo = Get.find<DeviceRepository>();
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode =
        await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    // Clear previous OTP from field
    pinController.clear();
    isOtpComplete.value = false;

    try {
      isLoading.value = true;

      var res = await otpVerificationPresenter.resendOtpAPI(
        isLoading: true,
        login: username.toString(),
        branchCode: branchCode.toString() ,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        // ✅ Reset timer
        counter = 30;
        enableResend = false;
        otpTimer();

        // ✅ Store new OTP in preferences
        if (res.data?.otp != null) {
          storedOtp = res.data!.otp!;
          await deviceRepo.saveValueSecurely(DeviceConstants.otp, storedOtp);

          // ✅ Auto-fill OTP in PIN field
          pinController.text = storedOtp;
          isOtpComplete.value = true;
        }

        update();

        Get.snackbar(
          'Success',
          res.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to resend OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to resend OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> verifyOtpAPI() async {
    String otp = pinController.text.trim();

    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter valid OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    var deviceRepo = Get.find<DeviceRepository>();
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode =
        await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    try {
      isLoading.value = true;

      var res = await otpVerificationPresenter.verifyOtpAPI(
        isLoading: true,
        login: username.toString(),
        branchCode: branchCode.toString() ,
        otp: otp,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
          if (res.data?.resetToken != null) {
          var deviceRepository = Get.find<DeviceRepository>();
          await deviceRepository.saveValueSecurely(
              DeviceConstants.resetToken, res.data!.resetToken!);
        }

        Get.snackbar(
          'Success',
          res.message ?? 'OTP verified successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        RouteManagement.goToChangePassword();
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'OTP verification failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
