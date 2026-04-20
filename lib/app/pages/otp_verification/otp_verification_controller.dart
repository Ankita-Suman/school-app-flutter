import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../navigators/routes_management.dart';
import 'otp_verification_presenter.dart';

class OtpVerificationController extends GetxController {
  OtpVerificationController(this.otpVerificationPresenter);

  final OtpVerificationPresenter otpVerificationPresenter;

  int counter = 30;
  bool enableResend = false;
  late Timer timer;
  String email = '';
  String storedOtp = ''; // Store OTP from preferences

  // Observable for button state
  var isOtpComplete = false.obs;

  // PIN controller
  final pinController = TextEditingController();
  final otpFormKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getUserData(); // This will fetch email and OTP from storage
    startOtpTimer();

    // Add listener to PIN controller
    pinController.addListener(_onPinChanged);
  }

  Future<void> getUserData() async {
    var deviceRepo = Get.find<DeviceRepository>();
    email = await deviceRepo.getSecuredValue(DeviceConstants.email) ?? '';
    storedOtp = await deviceRepo.getSecuredValue(DeviceConstants.otp) ?? '';

    print("📧 Email: $email");
    print("🔢 Stored OTP: $storedOtp");

    // 🔴 IMPORTANT: Set OTP in PIN field automatically
    if (storedOtp.isNotEmpty) {
      pinController.text = storedOtp;
      print("✅ OTP auto-filled: $storedOtp");

      // Trigger validation
      _onPinChanged();
    }

    update();
  }

  void startOtpTimer() {
    unawaited(Future<dynamic>.delayed(
      const Duration(seconds: 1),
    ).then((dynamic value) {
      otpTimer();
    }));
  }

  void _onPinChanged() {
    // Update when OTP length becomes 4
    isOtpComplete.value = pinController.text.length == 4;
    update();
    print("OTP Length: ${pinController.text.length}, Complete: ${isOtpComplete.value}");
  }

  void otpTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (counter == 0) {
          enableResend = true;
          timer.cancel();
          update();
        } else {
          counter--;
          update();
        }
      },
    );
  }

  void resendCode() {
    counter = 30;
    enableResend = false;
    update();
  }

  @override
  void dispose() {
    timer.cancel();
    pinController.removeListener(_onPinChanged);
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void resendOTP() async {
    var deviceRepo = Get.find<DeviceRepository>();

    // 🔴 FIX: Await the values
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode = await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    print("Username: $username");
    print("BranchCode: $branchCode");

    pinController.clear();

    try {
      var res = await otpVerificationPresenter.resendOtpAPI(
        isLoading: true,
        login: username?.toString() ?? '',  // Add null safety
        branchCode: branchCode?.toString() ?? '',  // Add null safety
      );

      if (res != null && res.status == true) {
        // Don't auto-fill OTP from response in production
         pinController.text = res.data!.otp!.toString(); // Remove this line

        counter = 30;
        enableResend = false;
        otpTimer();
        update();

        Get.snackbar(
          'Success',
          'OTP resent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to resend OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Resend OTP error: $e");
      Get.snackbar(
        'Error',
        'Failed to resend OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> verifyOtpAPI() async {
    var deviceRepo = Get.find<DeviceRepository>();

    // 🔴 FIX: Await the values
    var username = await deviceRepo.getSecuredValue(DeviceConstants.username);
    var branchCode = await deviceRepo.getSecuredValue(DeviceConstants.branchCode);

    // Validate OTP
    if (pinController.text.isEmpty || pinController.text.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter valid OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    var res = await otpVerificationPresenter.verifyOtpAPI(
      isLoading: true,
      login: username?.toString() ?? '',
      branchCode: branchCode?.toString() ?? '',
      otp: pinController.text.toString(),
    );

    print("Verify OTP response: $res");

    if (res != null && res.status == true) {
      print("✅ OTP verified successfully");
      print("Message: ${res.message}");
      print("Reset Token: ${res.data?.resetToken}");

      if (res.data?.resetToken != null) {
        var deviceRepository = Get.find<DeviceRepository>();
        await deviceRepository.saveValueSecurely(
            DeviceConstants.resetToken, res.data!.resetToken!);
      }

      RouteManagement.goToResetPassword();
    } else {
      Get.snackbar(
        'Error',
        res?.message ?? 'OTP verification failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}