// login_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/branch_verify_response.dart';
import '../../../domain/models/login_response.dart';
import '../../navigators/routes_management.dart';
import 'login_presenter.dart';

class LoginController extends GetxController {
  LoginController(this.loginStudentPresenter);

  final LoginPresenter loginStudentPresenter;

  // ========== ROLE SELECTION ==========
  var selectedRole = 'student'.obs;
  var selectedTab = 0.obs;

  // ========== USERNAME / EMAIL ==========
  TextEditingController? emailController;
  FocusNode? emailFocusNode;
  var isEmailFocused = false.obs;
  var emailError = ''.obs;
  var isEmailValid = false.obs;
  bool _emailErrorShown = false;

  // ========== PASSWORD ==========
  TextEditingController? passwordController;
  FocusNode? passwordFocusNode;
  var isPasswordFocused = false.obs;
  var isPasswordVisible = false.obs;
  var passwordError = ''.obs;
  var isPasswordValid = false.obs;
  bool _passwordErrorShown = false;

  // ========== FORM VALIDITY ==========
  var isFormValid = false.obs;
  bool rememberMe = false;
  var keyValidationForm = GlobalKey<FormState>();
  var isLoading = false.obs;

  // ========== SCHOOL INFO (from Verify Branch Code screen) ==========
  var branchInfoData = Rxn<BranchVerifyResponse>();
  var savedBranchCode = ''.obs;
  var savedLogoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode?.addListener(_onEmailFocusChange);
    passwordFocusNode?.addListener(_onPasswordFocusChange);

    emailController?.addListener(_checkFormValidity);
    passwordController?.addListener(_checkFormValidity);

    _loadSavedBranchInfo();
  }

  Future<void> _loadSavedBranchInfo() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      final branchCode = await deviceRepo.getSecuredValue(DeviceConstants.branchCode);
      if (branchCode.isNotEmpty && branchCode != 'null') {
        savedBranchCode.value = branchCode;
      }

      final schoolInfoJson = await deviceRepo.getSecuredValue(DeviceConstants.schoolInfo);
      if (schoolInfoJson.isNotEmpty && schoolInfoJson != 'null') {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(schoolInfoJson);
          branchInfoData.value = BranchVerifyResponse.fromJson(jsonMap);
          savedLogoUrl.value = branchInfoData.value?.data?.logoUrl ?? '';
        } catch (e) {
          debugPrint("❌ branch info parse error: $e");
        }
      }

      debugPrint("✅ Saved branch code: ${savedBranchCode.value}");
      debugPrint("✅ Saved logo url: ${savedLogoUrl.value}");
    } catch (e) {
      debugPrint("❌ _loadSavedBranchInfo error: $e");
    }
  }

  void _onEmailFocusChange() {
    if (emailFocusNode == null) return;
    isEmailFocused.value = emailFocusNode!.hasFocus;
    if (!emailFocusNode!.hasFocus && emailController?.text.isNotEmpty == true) {
      validateEmail(emailController!.text);
    }
  }

  void _onPasswordFocusChange() {
    if (passwordFocusNode == null) return;
    isPasswordFocused.value = passwordFocusNode!.hasFocus;
    if (!passwordFocusNode!.hasFocus && passwordController?.text.isNotEmpty == true) {
      validatePassword(passwordController!.text);
    }
  }

  void validateEmail(String value, {bool showSnackbar = true}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      isEmailValid.value = false;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    if (trimmed.contains('@')) {
      if (_isValidEmail(trimmed)) {
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

    if (trimmed.length < 3) {
      isEmailValid.value = false;
      emailError.value = 'Username must be at least 3 characters';
      _checkFormValidity();
      return;
    }

    isEmailValid.value = true;
    emailError.value = '';
    _emailErrorShown = false;
    _checkFormValidity();
  }

  void validatePassword(String value, {bool showSnackbar = true}) {
    if (value.isEmpty) {
      isPasswordValid.value = false;
      passwordError.value = '';
      _passwordErrorShown = false;
    } else if (value.trim().length < 8) {
      isPasswordValid.value = false;
      passwordError.value = 'Password must be at least 8 characters';
    } else {
      isPasswordValid.value = true;
      passwordError.value = '';
      _passwordErrorShown = false;
    }
    _checkFormValidity();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _checkFormValidity() {
    isFormValid.value = isEmailValid.value && isPasswordValid.value;
  }

  void showComingSoonDialog() {
    Get.defaultDialog(
      title: 'Coming Soon',
      middleText: 'This feature will be available in the upcoming release.',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue.shade700,
      onConfirm: () => Get.back(),
    );
  }

  void loginWithValidation() {
    String username = emailController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';

    _emailErrorShown = false;
    _passwordErrorShown = false;

    bool hasError = false;
    String branchCode = branchInfoData.value?.data?.branchCode ?? savedBranchCode.value;

    if (branchCode.isEmpty) {
      Get.snackbar('Error', 'Branch code not found. Please verify branch code again.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (username.isEmpty) {
      emailError.value = 'Please enter username or email';
      hasError = true;
    } else if (username.contains('@')) {
      if (!_isValidEmail(username)) {
        emailError.value = 'Please enter valid email address';
        hasError = true;
      } else {
        emailError.value = '';
      }
    } else if (username.length < 3) {
      emailError.value = 'Username must be at least 3 characters';
      hasError = true;
    } else {
      emailError.value = '';
    }

    if (password.isEmpty) {
      passwordError.value = 'Please enter password';
      hasError = true;
    } else if (password.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      hasError = true;
    } else {
      passwordError.value = '';
    }

    if (hasError) {
      if (emailError.value.isNotEmpty) {
        emailFocusNode?.requestFocus();
      } else if (passwordError.value.isNotEmpty) {
        passwordFocusNode?.requestFocus();
      }
      return;
    }

    loginAPI();
  }

  Future<void> saveFullLoginResponse(LoginResponse response) async {
    final deviceRepository = Get.find<DeviceRepository>();
    final jsonString = loginResponseToJson(response);
    await deviceRepository.saveValueSecurely(DeviceConstants.loginResponse, jsonString);
  }

  // ============================================================
  // ✅ LOGIN API (UPDATED for Parent Student ID)
  // ============================================================
  Future<void> loginAPI() async {
    String loginName = emailController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';
    String branchCode = branchInfoData.value?.data?.branchCode ?? savedBranchCode.value;

    debugPrint("📦 Login API me bheja ja raha branchCode: $branchCode");

    var res = await loginStudentPresenter.loginAPI(
      isLoading: true,
      loginName: loginName,
      branchCode: branchCode,
      password: password,
    );

    if (res != null && res.status == true) {
      var deviceRepository = Get.find<DeviceRepository>();

      // STEP 1: PURA LOGIN RESPONSE SAVE
      await saveFullLoginResponse(res);

      // STEP 2: ALAG-ALAG VALUES SAVE
      String token = '${res.data?.token}';
      String branchId = '${res.data?.branchId}';

      String? apiRole = res.data?.user.userType.toLowerCase() ?? '';
      String navigationRole = apiRole.isNotEmpty ? apiRole : 'student';

      // ✅ FIX: Parent ke liye default_student_id save karo, Student ke liye studentId
      String studentIdToSave = '${res.data?.user.studentId}';
      if (navigationRole == 'parent') {
        // Agar auth me default_student_id hai to use karo
        studentIdToSave = res.data?.auth?.defaultStudentId ??
            (res.data?.user.children?.isNotEmpty == true ? res.data!.user.children!.first.id ?? '' : '');
      }

      await deviceRepository.saveValueSecurely(DeviceConstants.token, token);
      await deviceRepository.saveValueSecurely(DeviceConstants.branchId, branchId);
      await deviceRepository.saveValueSecurely(DeviceConstants.branchCode, '${res.data?.branchCode}');
      await deviceRepository.saveValueSecurely(DeviceConstants.email, '${res.data?.user.email}');
      await deviceRepository.saveValueSecurely(DeviceConstants.username, '${res.data?.user.username}');
      await deviceRepository.saveValueSecurely(DeviceConstants.studentId, studentIdToSave); // ✅ UPDATED
      await deviceRepository.saveValueSecurely(DeviceConstants.staffId, res.data?.user.staffId ?? '');
      await deviceRepository.saveValueSecurely(DeviceConstants.userRole, navigationRole);

      debugPrint("💾 Token saved: $token");
      debugPrint("💾 BranchId saved: $branchId");
      debugPrint("💾 StudentId saved: $studentIdToSave (Role: $navigationRole)");

      // STEP 3: PASSWORD CHANGE CHECK
      if (res.data?.user.mustChangePassword == true) {
        _showChangePasswordDialog(navigationRole);
        return;
      }

      // Normal flow
      await Future.delayed(const Duration(milliseconds: 500));
      navigateBasedOnRole(navigationRole);
    } else {
      Get.snackbar(
        'Login Failed',
        'Please check your credentials and try again.',
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

  void _showChangePasswordDialog(String navigationRole) {
    Get.dialog<dynamic>(
      CupertinoAlertDialog(
        title: const Text('Password Update Required'),
        content: const Text('You must change your password before continuing.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back<dynamic>();
              RouteManagement.goToCreatePassword();
            },
            isDefaultAction: true,
            child: Text('OK'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void navigateBasedOnRole(String role) {
    String roleLower = role.toLowerCase();
    if (roleLower == 'student') {
      RouteManagement.goToHome();
      clearAllFields();
    } else if (roleLower == 'staff') {
      RouteManagement.goToTeacherDashboard();
      clearAllFields();
    } else if (roleLower == 'parent') {
      RouteManagement.goToParentDashboard();
      clearAllFields();
    } else {
      clearAllFields();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 0) selectedRole.value = 'student';
    else if (index == 1) selectedRole.value = 'parent';
    else if (index == 2) selectedRole.value = 'teacher';
  }

  void clearAllFields() {
    emailController?.clear();
    passwordController?.clear();

    isEmailValid.value = false;
    isPasswordValid.value = false;
    isFormValid.value = false;

    emailError.value = '';
    passwordError.value = '';
  }

  @override
  void onClose() {
    emailFocusNode?.removeListener(_onEmailFocusChange);
    passwordFocusNode?.removeListener(_onPasswordFocusChange);
    super.onClose();
  }
}