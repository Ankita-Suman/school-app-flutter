import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/device/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password_presenter.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController(this.forgotPasswordPresenter);

  final ForgotPasswordPresenter forgotPasswordPresenter;

  // Make observables for reactive UI
  var isEmailValid = false.obs;
  var isBranchCodeValid = false.obs;
  var isFormValid = false.obs;
  var isLoading = false.obs; // Add loading state

  bool isEmail = false;
  String emailId = '';
  var emailErrorText = ''.obs;
  var branchCodeErrorText = ''.obs;

  var focusNode = FocusNode();
  var branchCodeFocusNode = FocusNode();

  TextEditingController emailUsernameEditingController = TextEditingController();
  TextEditingController branchCodeEditingController = TextEditingController();
  var keyValidationForm = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Add listeners to check form validity in real-time
    emailUsernameEditingController.addListener(_checkFormValidity);
    branchCodeEditingController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    // Check if both fields are valid
    isFormValid.value = isEmailValid.value && isBranchCodeValid.value;
    update();
  }

  String? validateBranchCode(String? value) {
    value = value ?? branchCodeEditingController.text;

    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeErrorText.value = 'Please enter branch code';
      _checkFormValidity();
      return 'Please enter branch code';
    }

    isBranchCodeValid.value = true;
    branchCodeErrorText.value = '';
    _checkFormValidity();
    return null;
  }

  // Validation methods for email/username with special characters support
  String? validateEmailOrUsername(String? value) {
    value = value ?? emailUsernameEditingController.text;

    // Check if empty
    if (value.isEmpty) {
      isEmailValid.value = false;
      emailErrorText.value = StringConstants.pleaseEnterEmail;
      _checkFormValidity();
      return StringConstants.pleaseEnterEmail;
    }

    // Check if it's a valid email (with @ symbol)
    if (value.contains('@')) {
      if (!_isValidEmail(value)) {
        isEmailValid.value = false;
        emailErrorText.value = StringConstants.pleaseEnterValidEmail;
        _checkFormValidity();
        return StringConstants.pleaseEnterValidEmail;
      }
      // Email is valid
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    // Check if it's a valid phone number (10 digits)
    if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    if (value.length < 3) {
      isEmailValid.value = false;
      emailErrorText.value = 'Username must be at least 3 characters';
      _checkFormValidity();
      return 'Username must be at least 3 characters';
    }

    if (value.length > 50) {
      isEmailValid.value = false;
      emailErrorText.value = 'Username cannot exceed 50 characters';
      _checkFormValidity();
      return 'Username cannot exceed 50 characters';
    }

    if (RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    // If none of the above conditions match
    isEmailValid.value = false;
    emailErrorText.value = 'Please enter valid email or username (letters, numbers, ., -, _)';
    _checkFormValidity();
    return 'Please enter valid email or username (letters, numbers, ., -, _)';
  }

  bool _isValidEmail(String email) {
    // More comprehensive email validation
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  Future<void> forgotPasswordAPI(BuildContext context) async {
    // ✅ Check if form is valid first
    if (!isFormValid.value) {
      Get.snackbar(
        'Validation Error',
        'Please enter valid email/username and branch code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    String login = emailUsernameEditingController.text.trim();
    String branchCode = branchCodeEditingController.text.trim();

    // ✅ Validate fields before API call
    if (login.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email/username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (branchCode.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter branch code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      var res = await forgotPasswordPresenter.forgotPasswordAPI(
        isLoading: true,
        login: login,
        branchCode: branchCode,
      );

      print("Forgot password response: ${res?.status}");
      print("Forgot password message: ${res?.message}");

      // ✅ Check if API response is successful
      if (res != null && res.status == true) {
        print("✅ Forgot password success");

        // ✅ Store data only on success
        var deviceRepository = Get.find<DeviceRepository>();

        if (res.data?.otp != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.otp, res.data!.otp!);
          print("✅ OTP stored: ${res.data!.otp}");
        }

        if (res.data?.branchCode != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.branchCode, res.data!.branchCode!);
          print("✅ Branch code stored: ${res.data!.branchCode}");
        }

        if (res.data?.login != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.username, res.data!.login!);
          print("✅ Username stored: ${res.data!.login}");
        }

        // ✅ Only navigate on success
        openCheckEmailDialog(context, res.message ?? 'OTP sent successfully');

      } else {
        // ✅ Show error message from API
        String errorMessage = res?.message ?? 'Failed to send OTP. Please check your credentials.';

        print("❌ Forgot password failed: $errorMessage");

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }

    } catch (e) {
      // ✅ Handle any exception
      print("Error in forgotPasswordAPI: $e");
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future openCheckEmailDialog(BuildContext context, String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // ✅ Navigate after dialog is shown
        Future.delayed(const Duration(seconds: 5), () {
          if (Get.context != null) {
            RouteManagement.goToOtpVerification();
          }
        });

        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))
          ),
          contentPadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Dimens.boxHeight20,
              SvgPicture.asset(AssetConstants.icOpenEmail),
              Dimens.boxHeight30,
              Text(
                StringConstants.checkYouEmail,
                style: Styles.blackDark18,
              ),
              Dimens.boxHeight10,
              Text(
                message.isEmpty ? StringConstants.sendPassword : message,
                style: Styles.greyDark14,
                textAlign: TextAlign.center,
              ),
              Dimens.boxHeight30,
            ],
          ),
        );
      },
    );
  }

  // Clear error messages when user starts typing
  void clearEmailError() {
    if (emailErrorText.value.isNotEmpty) {
      emailErrorText.value = '';
      isEmailValid.value = false;
      _checkFormValidity();
      update();
    }
  }

  void clearBranchCodeError() {
    if (branchCodeErrorText.value.isNotEmpty) {
      branchCodeErrorText.value = '';
      isBranchCodeValid.value = false;
      _checkFormValidity();
      update();
    }
  }

  @override
  void onClose() {
    focusNode.dispose();
    branchCodeFocusNode.dispose();
    emailUsernameEditingController.dispose();
    branchCodeEditingController.dispose();
    super.onClose();
  }
}