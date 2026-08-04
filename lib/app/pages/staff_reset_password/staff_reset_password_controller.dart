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

  // ---------- Validation Methods ----------
  void _validateCurrentPassword() {
    final current = currentPasswordController.text.trim();
    if (current.isEmpty) {
      currentPasswordError.value = 'Current password is required';
      isFormValid.value = false;
      if (currentPasswordFocusNode.hasFocus && !_currentErrorShown) {
        showErrorSnackbar('Please enter your current password');
        _currentErrorShown = true;
      }
    } else {
      currentPasswordError.value = '';
      _currentErrorShown = false;
    }
    _updateFormValidity();
  }

  void _validateNewPassword() {
    final newPwd = newPasswordController.text.trim();
    final current = currentPasswordController.text.trim();

    if (newPwd.isEmpty) {
      newPasswordError.value = 'New password is required';
      isFormValid.value = false;
      if (newPasswordFocusNode.hasFocus && !_newErrorShown) {
        showErrorSnackbar('Please enter a new password');
        _newErrorShown = true;
      }
    } else if (newPwd.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      isFormValid.value = false;
      if (newPasswordFocusNode.hasFocus && !_newErrorShown) {
        showErrorSnackbar('Password must be at least 6 characters');
        _newErrorShown = true;
      }
    } else if (newPwd == current) {
      newPasswordError.value = 'New password must be different from current';
      isFormValid.value = false;
      if (newPasswordFocusNode.hasFocus && !_newErrorShown) {
        showErrorSnackbar('New password must be different from current password');
        _newErrorShown = true;
      }
    } else {
      newPasswordError.value = '';
      _newErrorShown = false;
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
      if (confirmPasswordFocusNode.hasFocus && !_confirmErrorShown) {
        showErrorSnackbar('Please confirm your new password');
        _confirmErrorShown = true;
      }
    } else if (confirm != newPwd) {
      confirmPasswordError.value = 'Passwords do not match';
      isFormValid.value = false;
      if (confirmPasswordFocusNode.hasFocus && !_confirmErrorShown) {
        showErrorSnackbar('Passwords do not match');
        _confirmErrorShown = true;
      }
    } else {
      confirmPasswordError.value = '';
      _confirmErrorShown = false;
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

  // ---------- API Call (uses dynamic token and branchId) ----------
  void resetPassword() async {
    // Final validation before API call
    String current = currentPasswordController.text.trim();
    String newPwd = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (current.isEmpty) {
      showErrorSnackbar('Please enter current password');
      return;
    }
    if (newPwd.isEmpty) {
      showErrorSnackbar('Please enter new password');
      return;
    }
    if (newPwd.length < 6) {
      showErrorSnackbar('New password must be at least 6 characters');
      return;
    }
    if (newPwd == current) {
      showErrorSnackbar('New password must be different from current password');
      return;
    }
    if (confirm.isEmpty) {
      showErrorSnackbar('Please confirm your password');
      return;
    }
    if (newPwd != confirm) {
      showErrorSnackbar('Passwords do not match');
      return;
    }

    if (authToken.isEmpty || branchId.isEmpty) {
      showErrorSnackbar('Authentication token or branch ID not found. Please login again.');
      return;
    }

    try {
      isLoading.value = true;

      // ✅ Use dynamic token and branchId
      StaffResetPasswordResponse? res = await _presenter.resetStaffPassword(
        isLoading: false,
        token: authToken,        // ✅ dynamic
        branchId: branchId,      // ✅ dynamic
        currentPassword: current,
        newPassword: newPwd,
        passwordConfirmation: confirm,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        showSuccessSnackbar('Password changed successfully! Please login again.');
        clearForm();
        Future.delayed(const Duration(seconds: 2), () {
          _clearAllAndNavigateToLogin();
        });
      } else {
        showErrorSnackbar(res?.message ?? 'Failed to change password. Please try again.');
      }
    } catch (e) {
      isLoading.value = false;
      showErrorSnackbar('Network error. Please try again.');
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

  // ---------- Helper Snackbars ----------
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