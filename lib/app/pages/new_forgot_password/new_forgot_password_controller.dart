import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../data/helpers/connect_helper.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/repositories/domain_repository.dart';
import '../../../domain/repositories/repository.dart';
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
  var branchCodeError = ''.obs;

  // Email
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  var isEmailFocused = false.obs;
  var isEmailValid = false.obs;
  bool _emailErrorShown = false;
  var emailError = ''.obs;

  // Form Validity
  var isFormValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners for focus changes
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

    // Add listeners for text changes
    branchCodeController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
  }

  void validateBranchCode(String value, {bool showSnackbar = true}) {
    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
    } else if (value.length < 3) {
      isBranchCodeValid.value = false;
      branchCodeError.value = 'Branch code must be at least 3 characters';
      if (showSnackbar && !_branchCodeErrorShown) {
        showErrorSnackbar('Branch code must be at least 3 characters');
        _branchCodeErrorShown = true;
      }
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

    // Check if it's a valid email (with @ symbol)
    if (value.contains('@')) {
      if (_isValidEmail(value)) {
        isEmailValid.value = true;
        emailError.value = '';
        _emailErrorShown = false;
      } else {
        isEmailValid.value = false;
        emailError.value = 'Please enter valid email address';
        if (showSnackbar && !_emailErrorShown) {
          showErrorSnackbar('Please enter valid email address');
          _emailErrorShown = true;
        }
      }
      _checkFormValidity();
      return;
    }

    // Check if it's a valid phone number (10 digits)
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      if (value.length == 10) {
        isEmailValid.value = true;
        emailError.value = '';
        _emailErrorShown = false;
      } else {
        isEmailValid.value = false;
        emailError.value = 'Mobile number must be 10 digits';
        if (showSnackbar && !_emailErrorShown) {
          showErrorSnackbar('Mobile number must be 10 digits');
          _emailErrorShown = true;
        }
      }
      _checkFormValidity();
      return;
    }

    // ✅ REMOVED: Username validation - only email or phone number allowed
    isEmailValid.value = false;
    emailError.value = 'Please enter valid email or 10-digit mobile number';
    if (showSnackbar && !_emailErrorShown) {
      showErrorSnackbar('Please enter valid email or 10-digit mobile number');
      _emailErrorShown = true;
    }
    _checkFormValidity();
  }

  void _checkFormValidity() {
    isFormValid.value = isEmailValid.value && isBranchCodeValid.value;
    print("Form Valid: ${isFormValid.value}, Email Valid: ${isEmailValid.value}, Branch Valid: ${isBranchCodeValid.value}");
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
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

  // Send Reset Link with API
  void sendResetLink() async {
    String branchCode = branchCodeController.text.trim();
    String email = emailController.text.trim();

    // Reset error shown flags
    _branchCodeErrorShown = false;
    _emailErrorShown = false;

    // Validate Branch Code
    if (branchCode.isEmpty) {
      showErrorSnackbar('Please enter branch code');
      return;
    }
    if (branchCode.length < 3) {
      showErrorSnackbar('Branch code must be at least 3 characters');
      return;
    }

    // Validate Email
    if (email.isEmpty) {
      showErrorSnackbar('Please enter email or mobile number');
      return;
    }

    // Check email format
    if (email.contains('@')) {
      if (!_isValidEmail(email)) {
        showErrorSnackbar('Please enter valid email address');
        return;
      }
    }
    // Check phone number
    else if (RegExp(r'^[0-9]+$').hasMatch(email)) {
      if (email.length != 10) {
        showErrorSnackbar('Mobile number must be 10 digits');
        return;
      }
    }
    // ✅ For any other input
    else {
      showErrorSnackbar('Please enter valid email or 10-digit mobile number');
      return;
    }

    // Set valid states
    isBranchCodeValid.value = true;
    isEmailValid.value = true;
    _checkFormValidity();

    // Call API
    await forgotPasswordAPI();
  }

  // API Method
  Future<void> forgotPasswordAPI() async {
    String login = emailController.text.trim();
    String branchCode = branchCodeController.text.trim();

    try {
      var res = await forgotPasswordPresenter.forgotPasswordAPI(
        isLoading: true,
        login: login,
        branchCode: branchCode,
      );

      print("Forgot password response: ${res?.status}");
      print("Forgot password message: ${res?.message}");

      if (res != null && res.status == true) {
        print("✅ Forgot password success");

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

        openCheckEmailDialog(res.message ?? 'OTP sent successfully');

      } else {
        String errorMessage = res?.message ?? 'Failed to send OTP. Please check your credentials.';
        print("❌ Forgot password failed: $errorMessage");
        showErrorSnackbar(errorMessage);
      }

    } catch (e) {
      print("Error in forgotPasswordAPI: $e");
      showErrorSnackbar('Network error. Please try again.');
    }
  }

  Future<void> openCheckEmailDialog(String message) async {
    // Show dialog
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              message.isEmpty ? 'We have sent an OTP to your email address.' : message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );

    // ✅ Wait for 2 seconds then close dialog and navigate
    await Future.delayed(const Duration(seconds: 2));

    // Close dialog if still open
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // Navigate to OTP screen
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