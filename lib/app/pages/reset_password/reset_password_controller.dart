import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/helpers/connect_helper.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/repositories/domain_repository.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';
import '../../navigators/app_pages.dart';
import 'reset_password_presenter.dart';

class ResetPasswordController extends GetxController {
  ResetPasswordController(this.resetPasswordPresenter);

  final ResetPasswordPresenter resetPasswordPresenter;

  var isPasswordValid = false.obs;
  var isConfirmPasswordValid = false.obs;
  var isFormValid = false.obs;
  var isLoading = false.obs;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  var passwordErrors = ''.obs;
  var confirmPasswordErrors = ''.obs;

  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController = TextEditingController();

  String resetToken = '';
  String username = '';
  String branchCode = '';

  @override
  void onInit() {
    super.onInit();
    _getStoredData();
    passwordEditingController.addListener(_validatePassword);
    confirmPasswordEditingController.addListener(_validateConfirmPassword);
  }

  @override
  void onClose() {
    passwordEditingController.removeListener(_validatePassword);
    confirmPasswordEditingController.removeListener(_validateConfirmPassword);
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    passwordEditingController.dispose();
    confirmPasswordEditingController.dispose();
    super.onClose();
  }

  Future<void> _getStoredData() async {
    try {
      var deviceRepository = Get.find<DeviceRepository>();

      String? token = await deviceRepository.getSecuredValue(DeviceConstants.resetToken);
      String? storedUsername = await deviceRepository.getSecuredValue(DeviceConstants.username);
      String? storedBranchCode = await deviceRepository.getSecuredValue(DeviceConstants.branchCode);

      if (token != null && token.isNotEmpty) {
        resetToken = token;
      }
      if (storedUsername != null && storedUsername.isNotEmpty) {
        username = storedUsername;
      }
      if (storedBranchCode != null && storedBranchCode.isNotEmpty) {
        branchCode = storedBranchCode;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _validatePassword() {
    String password = passwordEditingController.text.trim();

    if (password.isEmpty) {
      passwordErrors.value = 'Password is required';
      isPasswordValid.value = false;
    } else if (password.length < 6) {
      passwordErrors.value = 'Password must be at least 6 characters';
      isPasswordValid.value = false;
    } else if (!_hasUpperCase(password)) {
      passwordErrors.value = 'Password must contain at least one uppercase letter';
      isPasswordValid.value = false;
    } else if (!_hasLowerCase(password)) {
      passwordErrors.value = 'Password must contain at least one lowercase letter';
      isPasswordValid.value = false;
    } else if (!_hasNumber(password)) {
      passwordErrors.value = 'Password must contain at least one number';
      isPasswordValid.value = false;
    } else {
      passwordErrors.value = '';
      isPasswordValid.value = true;
    }
    _validateForm();
  }

  void _validateConfirmPassword() {
    String password = passwordEditingController.text.trim();
    String confirmPassword = confirmPasswordEditingController.text.trim();

    if (confirmPassword.isEmpty) {
      confirmPasswordErrors.value = 'Please confirm your password';
      isConfirmPasswordValid.value = false;
    } else if (password != confirmPassword) {
      confirmPasswordErrors.value = 'Passwords do not match';
      isConfirmPasswordValid.value = false;
    } else {
      confirmPasswordErrors.value = '';
      isConfirmPasswordValid.value = true;
    }
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = isPasswordValid.value && isConfirmPasswordValid.value;
  }

  bool _hasUpperCase(String value) => value.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String value) => value.contains(RegExp(r'[a-z]'));
  bool _hasNumber(String value) => value.contains(RegExp(r'[0-9]'));

  void updatePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void updateConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update();
  }

  Future<void> resetPassword() async {
    if (resetToken.isEmpty) {
      Get.snackbar('Error', 'Reset token not found. Please request a new password reset.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String newPassword = passwordEditingController.text.trim();
    String confirmPassword = confirmPasswordEditingController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please enter and confirm your password',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      var res = await resetPasswordPresenter.resetPasswordAPI(
        isLoading: true,
        login: username,
        branchCode: branchCode,
        token: resetToken,
        newPassword: newPassword,
        passwordConfirmation: confirmPassword,
      );

      if (res != null && res.status == true) {
        var deviceRepository = Get.find<DeviceRepository>();
        await deviceRepository.saveValueSecurely(DeviceConstants.resetToken, '');

        Get.snackbar('Success', 'Password reset successfully! Please login with your new password.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white,
            duration: const Duration(seconds: 2));

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.loginStudent);
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to reset password. Please try again.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void clearForm() {
    passwordEditingController.clear();
    confirmPasswordEditingController.clear();
    passwordErrors.value = '';
    confirmPasswordErrors.value = '';
    isPasswordValid.value = false;
    isConfirmPasswordValid.value = false;
    isFormValid.value = false;
  }
}