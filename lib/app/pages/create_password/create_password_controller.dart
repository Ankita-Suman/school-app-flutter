// controllers/create_password_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../navigators/routes_management.dart';
import 'create_password_presenter.dart';

class CreatePasswordController extends GetxController {
  CreatePasswordController(this.resetPasswordPresenter);

  final CreatePasswordPresenter resetPasswordPresenter;

  // ========== OLD PASSWORD ==========
  TextEditingController oldPasswordController = TextEditingController();
  FocusNode oldPasswordFocusNode = FocusNode();
  var isOldPasswordFocused = false.obs;
  var isOldPasswordVisible = false.obs;
  var oldPasswordErrors = ''.obs;
  var isOldPasswordValid = false.obs;
  bool _oldPasswordErrorShown = false;

  // New Password
  TextEditingController newPasswordController = TextEditingController();
  FocusNode newPasswordFocusNode = FocusNode();
  var isNewPasswordFocused = false.obs;
  var isNewPasswordVisible = false.obs;
  var passwordErrors = ''.obs;
  var isPasswordValid = false.obs;
  bool _passwordErrorShown = false;

  // Confirm Password
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  var isConfirmPasswordFocused = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var confirmPasswordErrors = ''.obs;
  var isConfirmPasswordValid = false.obs;
  bool _confirmErrorShown = false;

  // Form Validity
  var isFormValid = false.obs;
  var isLoading = false.obs;

  // ========== STORED DATA (from login response) ==========
  String token = '';        // ✅ token from login
  String branchId = '';     // ✅ branchId from login
  String branchCode = '';
  String username = '';
  String userId = '';

  @override
  void onInit() {
    super.onInit();
    _getStoredData();

    // ===== OLD PASSWORD LISTENERS =====
    oldPasswordFocusNode.addListener(() {
      isOldPasswordFocused.value = oldPasswordFocusNode.hasFocus;
      if (oldPasswordFocusNode.hasFocus) {
        _oldPasswordErrorShown = false;
        _validateOldPassword();
      }
    });

    oldPasswordController.addListener(() {
      _validateOldPassword();
      _updateFormValidity();
    });

    // ===== NEW PASSWORD LISTENERS =====
    newPasswordFocusNode.addListener(() {
      isNewPasswordFocused.value = newPasswordFocusNode.hasFocus;
      if (newPasswordFocusNode.hasFocus) {
        _passwordErrorShown = false;
        _validatePassword();
      }
    });

    // ===== CONFIRM PASSWORD LISTENERS =====
    confirmPasswordFocusNode.addListener(() {
      isConfirmPasswordFocused.value = confirmPasswordFocusNode.hasFocus;
      if (confirmPasswordFocusNode.hasFocus) {
        _confirmErrorShown = false;
        _validateConfirmPassword();
      }
    });

    // ===== TEXT CHANGE LISTENERS =====
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

  // ================================================================
  // ✅ LOGIN RESPONSE SE TOKEN + BRANCH ID GET KARO
  // ================================================================
  Future<void> _getStoredData() async {
    try {
      var deviceRepository = Get.find<DeviceRepository>();

      // ----------------------------------------------------------------
      // STEP 1: Pura login response JSON read karo
      // ----------------------------------------------------------------
      String jsonString = await deviceRepository
          .getSecuredValue(DeviceConstants.loginResponse);

      debugPrint("📦 Saved login response: $jsonString");

      if (jsonString.isNotEmpty) {
        try {
          final Map<String, dynamic> jsonMap = json.decode(jsonString);
          final data = jsonMap['data'] ?? jsonMap;

          // ----------------------------------------------------------------
          // STEP 2: Token nikalo (multiple key names try karo)
          // ----------------------------------------------------------------
          token = data['token']?.toString() ?? '';

          // ----------------------------------------------------------------
          // STEP 3: BranchId nikalo (multiple key names try karo)
          // ----------------------------------------------------------------
          branchId = data['branch_id']?.toString()
              ?? data['branchId']?.toString()
              ?? '';

          // ----------------------------------------------------------------
          // STEP 4: BranchCode nikalo
          // ----------------------------------------------------------------
          branchCode = data['branch_code']?.toString()
              ?? data['branchCode']?.toString()
              ?? '';

          // ----------------------------------------------------------------
          // STEP 5: User data nikalo
          // ----------------------------------------------------------------
          final user = data['user'];
          if (user != null) {
            username = user['username']?.toString() ?? '';
            userId = user['id']?.toString()
                ?? user['user_id']?.toString()
                ?? user['userId']?.toString()
                ?? '';
          }

          debugPrint("🔑 Token: $token");
          debugPrint("🔑 BranchId: $branchId");
          debugPrint("🔑 BranchCode: $branchCode");
          debugPrint("🔑 Username: $username");
          debugPrint("🔑 UserId: $userId");
        } catch (e) {
          debugPrint("❌ JSON parse error: $e");
        }
      }

      // ----------------------------------------------------------------
      // STEP 6: Fallback — agar JSON se nahi mila to individual keys se lo
      // ----------------------------------------------------------------
      if (token.isEmpty) {
        token = await deviceRepository.getSecuredValue(DeviceConstants.token);
      }
      if (branchId.isEmpty) {
        branchId = await deviceRepository.getSecuredValue(DeviceConstants.branchId);
      }
      if (branchCode.isEmpty) {
        branchCode = await deviceRepository.getSecuredValue(DeviceConstants.branchCode);
      }
      if (username.isEmpty) {
        username = await deviceRepository.getSecuredValue(DeviceConstants.username);
      }

      debugPrint("✅ Final — Token: $token");
      debugPrint("✅ Final — BranchId: $branchId");
      debugPrint("✅ Final — BranchCode: $branchCode");
    } catch (e) {
      debugPrint("❌ _getStoredData error: $e");
    }
  }

  // ========== PUBLIC VALIDATE METHODS ==========
  void validateOldPassword(String value) => _validateOldPassword();
  void validateNewPassword(String value) => _validatePassword();
  void validateConfirmPassword(String value) => _validateConfirmPassword();

  // ========== VALIDATION (inline only) ==========
  void _validateOldPassword() {
    String oldPassword = oldPasswordController.text;

    if (oldPassword.isEmpty) {
      isOldPasswordValid.value = false;
      oldPasswordErrors.value = '';
      _oldPasswordErrorShown = false;
    } else if (oldPassword.length < 6) {
      isOldPasswordValid.value = false;
      oldPasswordErrors.value = 'Password must be at least 6 characters';
    } else {
      isOldPasswordValid.value = true;
      oldPasswordErrors.value = '';
      _oldPasswordErrorShown = false;
    }
  }

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

    if (!isPasswordValid.value) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrors.value = '';
      return;
    }

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
    isFormValid.value = isOldPasswordValid.value &&
        isPasswordValid.value &&
        isConfirmPasswordValid.value;
  }

  // ========== SNACKBARS ==========
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

  // ========== VISIBILITY TOGGLES ==========
  void toggleOldPasswordVisibility() =>
      isOldPasswordVisible.value = !isOldPasswordVisible.value;

  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // ========== CLEAR FORM ==========
  void clearForm() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    oldPasswordErrors.value = '';
    passwordErrors.value = '';
    confirmPasswordErrors.value = '';

    isOldPasswordValid.value = false;
    isPasswordValid.value = false;
    isConfirmPasswordValid.value = false;
    isFormValid.value = false;

    _oldPasswordErrorShown = false;
    _passwordErrorShown = false;
    _confirmErrorShown = false;
  }

  // ================================================================
  // ✅ CHANGE PASSWORD API — TOKEN + BRANCH ID PASS KARO
  // ================================================================
  void changePassword() async {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    _oldPasswordErrorShown = false;
    _passwordErrorShown = false;
    _confirmErrorShown = false;

    bool hasError = false;

    // Validate Old Password
    if (oldPassword.isEmpty) {
      oldPasswordErrors.value = 'Please enter old password';
      hasError = true;
    } else if (oldPassword.length < 6) {
      oldPasswordErrors.value = 'Password must be at least 6 characters';
      hasError = true;
    } else {
      oldPasswordErrors.value = '';
    }

    // Validate New Password
    if (newPassword.isEmpty) {
      passwordErrors.value = 'Please enter new password';
      hasError = true;
    } else if (newPassword.length < 6) {
      passwordErrors.value = 'Password must be at least 6 characters';
      hasError = true;
    } else {
      passwordErrors.value = '';
    }

    // Validate Confirm Password
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
      if (oldPasswordErrors.value.isNotEmpty) {
        oldPasswordFocusNode.requestFocus();
      } else if (passwordErrors.value.isNotEmpty) {
        newPasswordFocusNode.requestFocus();
      } else if (confirmPasswordErrors.value.isNotEmpty) {
        confirmPasswordFocusNode.requestFocus();
      }
      return;
    }

    // ✅ Token & BranchId check — dono chahiye API ke liye
    if (token.isEmpty) {
      showErrorSnackbar('Session token missing. Please login again.');
      debugPrint("❌ Token missing");
      return;
    }

    if (branchId.isEmpty) {
      showErrorSnackbar('Branch ID missing. Please login again.');
      debugPrint("❌ BranchId missing");
      return;
    }

    try {
      isLoading.value = true;

      // ================================================================
      // ✅ API CALL — token aur branchId dono pass karo
      // ================================================================
      var res = await resetPasswordPresenter.changePasswordAPI(
        isLoading: true,
        token: token,             // ✅ Login response se aaya
        branchId: branchId,       // ✅ Login response se aaya
        oldPassword: oldPassword,
        newPassword: newPassword,
        passwordConfirmation: confirmPassword,
      );

      isLoading.value = false;

      if (res != null && res.status == true) {
        var deviceRepository = Get.find<DeviceRepository>();


        showSuccessSnackbar(
            'Password changed successfully! Please login with your new password.');

        await Future.delayed(const Duration(seconds: 2));

        // ✅ Sensitive data clear karo taaki user dobara login kare
        await deviceRepository.saveValueSecurely(DeviceConstants.token, '');
        await deviceRepository.saveValueSecurely(DeviceConstants.branchId, '');

        RouteManagement.goToLogin();
      } else {
        showErrorSnackbar(
            res?.message ?? 'Failed to change password. Please try again.');
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("❌ changePassword error: $e");
      showErrorSnackbar('Network error. Please try again.');
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}