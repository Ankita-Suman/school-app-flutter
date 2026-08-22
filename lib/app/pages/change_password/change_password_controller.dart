// controllers/change_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../navigators/routes_management.dart';
import 'change_password_presenter.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController(this.resetPasswordPresenter);

  final ChangePasswordPresenter resetPasswordPresenter;

  // New Password
  TextEditingController newPasswordController = TextEditingController();
  FocusNode newPasswordFocusNode = FocusNode();
  var isNewPasswordFocused = false.obs;
  var isNewPasswordVisible = false.obs;
  var passwordErrors = ''.obs;            // ✅ inline error
  var isPasswordValid = false.obs;
  bool _passwordErrorShown = false;

  // Confirm Password
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  var isConfirmPasswordFocused = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var confirmPasswordErrors = ''.obs;     // ✅ inline error
  var isConfirmPasswordValid = false.obs;
  bool _confirmErrorShown = false;

  // Form Validity
  var isFormValid = false.obs;
  var isLoading = false.obs;

  // Stored data
  String resetToken = '';
  String username = '';
  String branchCode = '';

  @override
  void onInit() {
    super.onInit();
    _getStoredData();

    // Focus listeners
    newPasswordFocusNode.addListener(() {
      isNewPasswordFocused.value = newPasswordFocusNode.hasFocus;
      if (newPasswordFocusNode.hasFocus) {
        _passwordErrorShown = false;
        _validatePassword();
      }
    });

    confirmPasswordFocusNode.addListener(() {
      isConfirmPasswordFocused.value = confirmPasswordFocusNode.hasFocus;
      if (confirmPasswordFocusNode.hasFocus) {
        _confirmErrorShown = false;
        _validateConfirmPassword();
      }
    });

    // Text change listeners
    newPasswordController.addListener(() {
      _validatePassword();
      if (confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
      _updateFormValidity();
    });

    confirmPasswordController.addListener(() {
      _validateConfirmPassword();
      _updateFormValidity();
    });
  }

  Future<void> _getStoredData() async {
    try {
      var deviceRepository = Get.find<DeviceRepository>();
      String? token = await deviceRepository.getSecuredValue(DeviceConstants.resetToken);
      String? storedUsername = await deviceRepository.getSecuredValue(DeviceConstants.username);
      String? storedBranchCode = await deviceRepository.getSecuredValue(DeviceConstants.branchCode);

      if (token.isNotEmpty) resetToken = token;
      if (storedUsername.isNotEmpty) username = storedUsername;
      if (storedBranchCode.isNotEmpty) branchCode = storedBranchCode;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void validateNewPassword(String value) {
    _validatePassword();
  }

  void validateConfirmPassword(String value) {
    _validateConfirmPassword();
  }

  // ========== VALIDATION (no snackbars, only inline errors) ==========
  void _validatePassword() {
    String password = newPasswordController.text;

    if (password.isEmpty) {
      isPasswordValid.value = false;
      passwordErrors.value = '';
      _passwordErrorShown = false;
    } else if (password.length < 6) {
      isPasswordValid.value = false;
      passwordErrors.value = 'Password must be at least 6 characters';
    } else {
      isPasswordValid.value = true;
      passwordErrors.value = '';
      _passwordErrorShown = false;
    }
  }

  void _validateConfirmPassword() {
    String password = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // If password is not valid
    if (!isPasswordValid.value) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrors.value = '';
      return;
    }

    // Password is valid, now validate confirm password
    if (confirmPassword.isEmpty) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrors.value = '';
    } else if (password != confirmPassword) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrors.value = 'Passwords do not match';
    } else {
      isConfirmPasswordValid.value = true;
      confirmPasswordErrors.value = '';
      _confirmErrorShown = false;
    }
  }

  void _updateFormValidity() {
    isFormValid.value = isPasswordValid.value && isConfirmPasswordValid.value;
  }

  // ========== SNACKBARS (only non-red, kept for success / API errors) ==========
  void showErrorSnackbar(String message) {
    // Changed to blue to avoid red
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

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void clearForm() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    passwordErrors.value = '';
    confirmPasswordErrors.value = '';
    isPasswordValid.value = false;
    isConfirmPasswordValid.value = false;
    isFormValid.value = false;
    _passwordErrorShown = false;
    _confirmErrorShown = false;
  }

  void changePassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Reset error flags
    _passwordErrorShown = false;
    _confirmErrorShown = false;

    bool hasError = false;

    // Validate New Password (inline)
    if (newPassword.isEmpty) {
      passwordErrors.value = 'Please enter new password';
      hasError = true;
    } else if (newPassword.length < 6) {
      passwordErrors.value = 'Password must be at least 6 characters';
      hasError = true;
    } else {
      passwordErrors.value = '';
    }

    // Validate Confirm Password (inline)
    if (confirmPassword.isEmpty) {
      confirmPasswordErrors.value = 'Please confirm your password';
      hasError = true;
    } else if (newPassword != confirmPassword) {
      confirmPasswordErrors.value = 'Passwords do not match';
      hasError = true;
    } else {
      confirmPasswordErrors.value = '';
    }

    if (hasError) {
      if (passwordErrors.value.isNotEmpty) {
        newPasswordFocusNode.requestFocus();
      } else if (confirmPasswordErrors.value.isNotEmpty) {
        confirmPasswordFocusNode.requestFocus();
      }
      return;
    }

    if (resetToken.isEmpty) {
      // Show a non-red snackbar for token missing (critical)
      Get.snackbar(
        'Error',
        'Reset token not found. Please request a new password reset.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.info_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      var res = await resetPasswordPresenter.resetPasswordAPI(
        isLoading: true,
        login: username,
        branchCode: branchCode,
        token: resetToken,
        newPassword: newPassword,
        passwordConfirmation: confirmPassword,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        var deviceRepository = Get.find<DeviceRepository>();
        await deviceRepository.saveValueSecurely(DeviceConstants.resetToken, '');

        showSuccessSnackbar('Password reset successfully! Please login with your new password.');

        await Future.delayed(const Duration(seconds: 2));
        RouteManagement.goToChangePasswordSuccessfully();
      } else {
        showErrorSnackbar(res?.message ?? 'Failed to reset password. Please try again.');
      }
    } catch (e) {
      isLoading.value = false;
      showErrorSnackbar('Network error. Please try again.');
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}