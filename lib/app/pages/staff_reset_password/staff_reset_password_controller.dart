import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/staff_reset_password_response.dart';
import '../../navigators/routes_management.dart';
import 'staff_reset_password_presenter.dart';

class StaffResetPasswordController extends GetxController {
  StaffResetPasswordController(this._presenter);

  final StaffResetPasswordPresenter _presenter;

  // ========== Text Controllers ==========
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ========== Focus Nodes ==========
  final currentPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // ========== Focus Observables ==========
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

  // ========== Stored Data (dynamic) ==========
  String authToken = '';
  String branchId = '';
  String username = '';
  String branchCode = '';

  // ========== Internal error flags ==========
  bool _currentErrorShown = false;
  bool _newErrorShown = false;
  bool _confirmErrorShown = false;

  @override
  void onInit() {
    super.onInit();
    _getStoredData();

    // ---------- Focus listeners ----------
    currentPasswordFocusNode.addListener(() {
      isCurrentPasswordFocused.value = currentPasswordFocusNode.hasFocus;
      if (currentPasswordFocusNode.hasFocus) {
        _currentErrorShown = false;
        _validateCurrentPassword();
      }
    });

    newPasswordFocusNode.addListener(() {
      isNewPasswordFocused.value = newPasswordFocusNode.hasFocus;
      if (newPasswordFocusNode.hasFocus) {
        _newErrorShown = false;
        _validateNewPassword();
      }
    });

    confirmPasswordFocusNode.addListener(() {
      isConfirmPasswordFocused.value = confirmPasswordFocusNode.hasFocus;
      if (confirmPasswordFocusNode.hasFocus) {
        _confirmErrorShown = false;
        _validateConfirmPassword();
      }
    });

    // ---------- Text change listeners ----------
    currentPasswordController.addListener(() {
      _validateCurrentPassword();
      _updateFormValidity();
    });

    newPasswordController.addListener(() {
      _validateNewPassword();
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

  // ---------- Fetch stored credentials (dynamic) ----------
  Future<void> _getStoredData() async {
    try {
      var deviceRepository = Get.find<DeviceRepository>();
      String? token =
      await deviceRepository.getSecuredValue(DeviceConstants.token);
      String? storedBranchId =
      await deviceRepository.getSecuredValue(DeviceConstants.branchId);
      String? storedUsername =
      await deviceRepository.getSecuredValue(DeviceConstants.username);
      String? storedBranchCode =
      await deviceRepository.getSecuredValue(DeviceConstants.branchCode);

      if (token.isNotEmpty) authToken = token;
      if (storedBranchId.isNotEmpty) branchId = storedBranchId;
      if (storedUsername.isNotEmpty) username = storedUsername;
      if (storedBranchCode.isNotEmpty) branchCode = storedBranchCode;
    } catch (e) {
      debugPrint("Error fetching stored data: $e");
    }
  }

  // ---------- Validation Methods (NO SNACKBARS) ----------
  void _validateCurrentPassword() {
    final current = currentPasswordController.text.trim();
    if (current.isEmpty) {
      currentPasswordError.value = 'Current password is required';
      isFormValid.value = false;
    } else {
      currentPasswordError.value = '';
    }
    _updateFormValidity();
  }

  void _validateNewPassword() {
    final newPwd = newPasswordController.text.trim();
    final current = currentPasswordController.text.trim();

    if (newPwd.isEmpty) {
      newPasswordError.value = 'New password is required';
      isFormValid.value = false;
    } else if (newPwd.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      isFormValid.value = false;
    } else if (newPwd == current) {
      newPasswordError.value = 'New password must be different from current';
      isFormValid.value = false;
    } else {
      newPasswordError.value = '';
    }
    _updateFormValidity();
  }

  void _validateConfirmPassword() {
    final newPwd = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (newPwd.isEmpty || newPwd.length < 6 || newPwd == currentPasswordController.text.trim()) {
      confirmPasswordError.value = '';
      return;
    }

    if (confirm.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isFormValid.value = false;
    } else if (confirm != newPwd) {
      confirmPasswordError.value = 'Passwords do not match';
      isFormValid.value = false;
    } else {
      confirmPasswordError.value = '';
    }
    _updateFormValidity();
  }

  void _updateFormValidity() {
    isFormValid.value = currentPasswordError.value.isEmpty &&
        newPasswordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        currentPasswordController.text.trim().isNotEmpty &&
        newPasswordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty;
  }

  // ---------- Visibility Toggles ----------
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ---------- API Call (NO SNACKBARS, errors shown inline) ----------
  void resetPassword() async {
    // Final validation with inline errors (no snackbars)
    String current = currentPasswordController.text.trim();
    String newPwd = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    bool hasError = false;

    if (current.isEmpty) {
      currentPasswordError.value = 'Current password is required';
      hasError = true;
    } else {
      currentPasswordError.value = '';
    }

    if (newPwd.isEmpty) {
      newPasswordError.value = 'New password is required';
      hasError = true;
    } else if (newPwd.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      hasError = true;
    } else if (newPwd == current) {
      newPasswordError.value = 'New password must be different from current';
      hasError = true;
    } else {
      newPasswordError.value = '';
    }

    if (newPwd.isNotEmpty && newPwd.length >= 6 && newPwd != current) {
      if (confirm.isEmpty) {
        confirmPasswordError.value = 'Please confirm your password';
        hasError = true;
      } else if (confirm != newPwd) {
        confirmPasswordError.value = 'Passwords do not match';
        hasError = true;
      } else {
        confirmPasswordError.value = '';
      }
    } else {
      confirmPasswordError.value = '';
    }

    if (hasError) {
      // Focus the first field with error
      if (currentPasswordError.value.isNotEmpty) {
        currentPasswordFocusNode.requestFocus();
      } else if (newPasswordError.value.isNotEmpty) {
        newPasswordFocusNode.requestFocus();
      } else if (confirmPasswordError.value.isNotEmpty) {
        confirmPasswordFocusNode.requestFocus();
      }
      return;
    }

    if (authToken.isEmpty || branchId.isEmpty) {
      // Show inline error (maybe set a general error?) but we can show snackbar only for this critical case
      Get.snackbar(
        'Error',
        'Authentication token or branch ID not found. Please login again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      StaffResetPasswordResponse? res = await _presenter.resetStaffPassword(
        isLoading: false,
        token: authToken,
        branchId: branchId,
        currentPassword: current,
        newPassword: newPwd,
        passwordConfirmation: confirm,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        // Success snackbar (green) – keep as per requirement (only red errors removed)
        Get.snackbar(
          'Success',
          'Password changed successfully! Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
        clearForm();
        Future.delayed(const Duration(seconds: 2), () {
          _clearAllAndNavigateToLogin();
        });
      } else {
        // Error from API – show inline? We can show as snackbar because it's a server error, not field-specific.
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to change password. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.error_outline, color: Colors.white),
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
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  // ---------- Clear form and logout ----------
  Future<void> _clearAllAndNavigateToLogin() async {
    try {
      var repo = Get.find<DeviceRepository>();
      await repo.deleteAllSecuredValues();
      await Get.find<GetStorage>().erase();
      RouteManagement.goToLogin();
    } catch (e) {
      RouteManagement.goToLogin();
    }
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
    _currentErrorShown = false;
    _newErrorShown = false;
    _confirmErrorShown = false;
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