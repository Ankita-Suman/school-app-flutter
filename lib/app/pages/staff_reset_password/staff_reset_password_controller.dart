import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffResetPasswordController extends GetxController {
  // ========== Text Controllers ==========
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ========== Focus Nodes ==========
  final currentPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // ========== Focus Observables (for UI) ==========
  var isCurrentPasswordFocused = false.obs;
  var isNewPasswordFocused = false.obs;
  var isConfirmPasswordFocused = false.obs;

  // ========== Visibility Toggles ==========
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // ========== Error Messages ==========
  var currentPasswordError = ''.obs;
  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // ========== Form State ==========
  var isFormValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // ---------- Focus listeners ----------
    currentPasswordFocusNode.addListener(() {
      isCurrentPasswordFocused.value = currentPasswordFocusNode.hasFocus;
    });
    newPasswordFocusNode.addListener(() {
      isNewPasswordFocused.value = newPasswordFocusNode.hasFocus;
    });
    confirmPasswordFocusNode.addListener(() {
      isConfirmPasswordFocused.value = confirmPasswordFocusNode.hasFocus;
    });

    // ---------- Text change listeners ----------
    currentPasswordController.addListener(_validateForm);
    newPasswordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  // ---------- Validation Logic ----------
  void _validateForm() {
    final current = currentPasswordController.text.trim();
    final newPwd = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    // Current password
    if (current.isEmpty) {
      currentPasswordError.value = 'Current password is required';
    } else {
      currentPasswordError.value = '';
    }

    // New password
    if (newPwd.isEmpty) {
      newPasswordError.value = 'New password is required';
    } else if (newPwd.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
    } else if (newPwd == current) {
      newPasswordError.value = 'New password must be different from current password';
    } else {
      newPasswordError.value = '';
    }

    // Confirm password
    if (confirm.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (confirm != newPwd) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }

    // Overall validity
    isFormValid.value =
        current.isNotEmpty &&
            newPwd.isNotEmpty &&
            confirm.isNotEmpty &&
            currentPasswordError.value.isEmpty &&
            newPasswordError.value.isEmpty &&
            confirmPasswordError.value.isEmpty;
  }

  // ---------- Visibility Toggles (exact names used in screen) ----------
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ---------- Reset Action ----------
  void resetPassword() {
    if (!isFormValid.value) return;
    isLoading.value = true;

    // Simulate API call – replace with your actual logic
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Password has been reset successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
      Get.back();
    });
  }

  // ---------- Clear Form ----------
  void clearForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    currentPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';
    isFormValid.value = false;
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}