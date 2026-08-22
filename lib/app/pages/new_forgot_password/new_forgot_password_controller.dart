// controllers/new_forgot_password_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../navigators/routes_management.dart';
import '../../utils/asset_constants.dart';
import 'new_forgot_password_presenter.dart';

class NewForgotPasswordController extends GetxController {
  NewForgotPasswordController(this.forgotPasswordPresenter);

  final NewForgotPasswordPresenter forgotPasswordPresenter;

  // Branch Code
  TextEditingController branchCodeController = TextEditingController();
  FocusNode branchCodeFocusNode = FocusNode();
  var isBranchCodeFocused = false.obs;
  var isBranchCodeValid = false.obs;
  bool _branchCodeErrorShown = false;
  var branchCodeError = ''.obs; // ✅ inline error

  // Email
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  var isEmailFocused = false.obs;
  var isEmailValid = false.obs;
  bool _emailErrorShown = false;
  var emailError = ''.obs; // ✅ inline error

  // Form Validity
  var isFormValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    branchCodeFocusNode.addListener(() {
      isBranchCodeFocused.value = branchCodeFocusNode.hasFocus;
      if (!branchCodeFocusNode.hasFocus && branchCodeController.text.isNotEmpty) {
        validateBranchCode(branchCodeController.text, showSnackbar: false);
      }
    });

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
      if (!emailFocusNode.hasFocus && emailController.text.isNotEmpty) {
        validateEmail(emailController.text, showSnackbar: false);
      }
    });

    branchCodeController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
  }

  // ========== VALIDATION (no red snackbars) ==========
  void validateBranchCode(String value, {bool showSnackbar = true}) {
    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
    } else if (value.length < 3) {
      isBranchCodeValid.value = false;
      branchCodeError.value = 'Branch code must be at least 3 characters';
    } else {
      isBranchCodeValid.value = true;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
    }
    _checkFormValidity();
  }

  void validateEmail(String value, {bool showSnackbar = true}) {
    if (value.isEmpty) {
      isEmailValid.value = false;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    if (value.contains('@')) {
      if (_isValidEmail(value)) {
        isEmailValid.value = true;
        emailError.value = '';
        _emailErrorShown = false;
      } else {
        isEmailValid.value = false;
        emailError.value = 'Please enter valid email address';
      }
      _checkFormValidity();
      return;
    }

    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      if (value.length == 10) {
        isEmailValid.value = true;
        emailError.value = '';
        _emailErrorShown = false;
      } else {
        isEmailValid.value = false;
        emailError.value = 'Mobile number must be 10 digits';
      }
      _checkFormValidity();
      return;
    }

    // Invalid input
    isEmailValid.value = false;
    emailError.value = 'Please enter valid email or 10-digit mobile number';
    _checkFormValidity();
  }

  void _checkFormValidity() {
    isFormValid.value = isEmailValid.value && isBranchCodeValid.value;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // ========== SNACKBARS (non-red for API errors) ==========
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  // ========== SEND RESET LINK (inline errors) ==========
  void sendResetLink() async {
    String branchCode = branchCodeController.text.trim();
    String email = emailController.text.trim();

    // Reset error flags
    _branchCodeErrorShown = false;
    _emailErrorShown = false;

    bool hasError = false;

    // Branch code
    if (branchCode.isEmpty) {
      branchCodeError.value = 'Please enter branch code';
      hasError = true;
    } else if (branchCode.length < 3) {
      branchCodeError.value = 'Branch code must be at least 3 characters';
      hasError = true;
    } else {
      branchCodeError.value = '';
    }

    // Email
    if (email.isEmpty) {
      emailError.value = 'Please enter email or mobile number';
      hasError = true;
    } else if (email.contains('@')) {
      if (!_isValidEmail(email)) {
        emailError.value = 'Please enter valid email address';
        hasError = true;
      } else {
        emailError.value = '';
      }
    } else if (RegExp(r'^[0-9]+$').hasMatch(email)) {
      if (email.length != 10) {
        emailError.value = 'Mobile number must be 10 digits';
        hasError = true;
      } else {
        emailError.value = '';
      }
    } else {
      emailError.value = 'Please enter valid email or 10-digit mobile number';
      hasError = true;
    }

    if (hasError) {
      if (branchCodeError.value.isNotEmpty) {
        branchCodeFocusNode.requestFocus();
      } else if (emailError.value.isNotEmpty) {
        emailFocusNode.requestFocus();
      }
      return;
    }

    // Proceed with API
    await forgotPasswordAPI();
  }

  // ========== API METHOD ==========
  Future<void> forgotPasswordAPI() async {
    String login = emailController.text.trim();
    String branchCode = branchCodeController.text.trim();

    try {
      var res = await forgotPasswordPresenter.forgotPasswordAPI(
        isLoading: true,
        login: login,
        branchCode: branchCode,
      );

      if (res != null && res.status == true) {
        var deviceRepository = Get.find<DeviceRepository>();

        if (res.data?.otp != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.otp, res.data!.otp!);
        }
        if (res.data?.branchCode != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.branchCode, res.data!.branchCode!);
        }
        if (res.data?.login != null) {
          await deviceRepository.saveValueSecurely(
              DeviceConstants.username, res.data!.login!);
        }

        openCheckEmailDialog(res.message);
      } else {
        String errorMessage = res?.message ??
            'Failed to send OTP. Please check your credentials.';
        // Use non-red snackbar for API error
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.info_outline, color: Colors.white),
      );
    }
  }

  Future<void> openCheckEmailDialog(String message) async {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        contentPadding:
        const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            SvgPicture.asset(AssetConstants.icOpenEmail),
            const SizedBox(height: 30),
            const Text(
              'Check Your Email',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              message.isEmpty
                  ? 'We have sent an OTP to your email address.'
                  : message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    RouteManagement.goToNewOtpVerification();
  }

  @override
  void onClose() {
    branchCodeController.dispose();
    emailController.dispose();
    branchCodeFocusNode.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }
}