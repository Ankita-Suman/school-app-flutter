import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/login_response.dart';
import '../../navigators/routes_management.dart';
import 'login_presenter.dart';

class LoginController extends GetxController {
  LoginController(this.loginStudentPresenter);

  final LoginPresenter loginStudentPresenter;

  // ========== ROLE SELECTION ==========
  var selectedRole = 'student'.obs; // 'student', 'parent', 'staff'

  final Map<String, String> displayToApiRole = {
    'student': 'student',
    'parent': 'parent',
    'teacher': 'staff',
  };

  final Map<String, String> apiToDisplayRole = {
    'student': 'student',
    'parent': 'parent',
    'staff': 'teacher',
  };

  final Map<String, String> roleRoutes = {
    'student': '/student-dashboard',
    'parent': '/parent-dashboard',
    'staff': '/teacher-dashboard',
  };

  var selectedTab = 0.obs;

  // Branch Code
  TextEditingController? branchCodeController;
  FocusNode? branchCodeFocusNode;
  var isBranchCodeFocused = false.obs;
  var branchCodeError = ''.obs;
  var isBranchCodeValid = false.obs;
  bool _branchCodeErrorShown = false;

  // Email
  TextEditingController? emailController;
  FocusNode? emailFocusNode;
  var isEmailFocused = false.obs;
  var emailError = ''.obs;
  var isEmailValid = false.obs;
  bool _emailErrorShown = false;

  // Password
  TextEditingController? passwordController;
  FocusNode? passwordFocusNode;
  var isPasswordFocused = false.obs;
  var isPasswordVisible = false.obs;
  var passwordError = ''.obs;
  var isPasswordValid = false.obs;
  bool _passwordErrorShown = false;

  // Form Validity
  var isFormValid = false.obs;

  // Additional variables
  bool onPasswordListening = false;
  bool isEmail = false;
  bool isNumberValid = false;
  bool isPasswordReset = false;
  bool rememberMe = false;

  String emailId = '';
  String phoneNumber = '';

  var keyValidationForm = GlobalKey<FormState>();

  final headerText = ''.obs;
  final fromScreen = ''.obs;
  final headerImage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers
    branchCodeController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    branchCodeFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    // Add listeners with null safety
    branchCodeFocusNode?.addListener(_onBranchCodeFocusChange);
    emailFocusNode?.addListener(_onEmailFocusChange);
    passwordFocusNode?.addListener(_onPasswordFocusChange);

    branchCodeController?.addListener(_checkFormValidity);
    emailController?.addListener(_checkFormValidity);
    passwordController?.addListener(_checkFormValidity);
  }

  // ========== ROLE SELECTION METHODS ==========
  void selectRole(String role) {
    if (selectedRole.value != role) {
      clearAllFields();
      selectedRole.value = role;

      String displayName = apiToDisplayRole[selectedRole.value] ?? selectedRole.value;
      print('🔄 Role selected: $role (Display: $displayName)');

      Get.snackbar(
        'Role Selected',
        'You are logging in as ${displayName.toUpperCase()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }

  void clearAllFields() {
    branchCodeController?.clear();
    emailController?.clear();
    passwordController?.clear();

    isBranchCodeValid.value = false;
    isEmailValid.value = false;
    isPasswordValid.value = false;
    isFormValid.value = false;

    branchCodeError.value = '';
    emailError.value = '';
    passwordError.value = '';

    _branchCodeErrorShown = false;
    _emailErrorShown = false;
    _passwordErrorShown = false;
  }

  void _onBranchCodeFocusChange() {
    if (branchCodeFocusNode == null) return;
    isBranchCodeFocused.value = branchCodeFocusNode!.hasFocus;
    if (!branchCodeFocusNode!.hasFocus && branchCodeController?.text.isNotEmpty == true) {
      validateBranchCode(branchCodeController!.text, showSnackbar: false);
    }
  }

  void _onEmailFocusChange() {
    if (emailFocusNode == null) return;
    isEmailFocused.value = emailFocusNode!.hasFocus;
    if (!emailFocusNode!.hasFocus && emailController?.text.isNotEmpty == true) {
      validateEmail(emailController!.text, showSnackbar: false);
    }
  }

  void _onPasswordFocusChange() {
    if (passwordFocusNode == null) return;
    isPasswordFocused.value = passwordFocusNode!.hasFocus;
    if (!passwordFocusNode!.hasFocus && passwordController?.text.isNotEmpty == true) {
      validatePassword(passwordController!.text, showSnackbar: false);
    }
  }

  void _checkFormValidity() {
    isFormValid.value =
        isEmailValid.value && isPasswordValid.value && isBranchCodeValid.value;
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
        if (showSnackbar && !_emailErrorShown) {
          showErrorSnackbar('Please enter valid email address');
          _emailErrorShown = true;
        }
      }
      _checkFormValidity();
      return;
    }

    if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    if (RegExp(r'^[0-9]+$').hasMatch(value) && value.length < 10) {
      isEmailValid.value = false;
      emailError.value = 'Mobile number must be 10 digits';
      if (showSnackbar && !_emailErrorShown) {
        showErrorSnackbar('Mobile number must be 10 digits');
        _emailErrorShown = true;
      }
      _checkFormValidity();
      return;
    }

    if (value.length >= 3 && RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    isEmailValid.value = false;
    emailError.value = 'Please enter valid email, phone number';
    if (showSnackbar && !_emailErrorShown) {
      showErrorSnackbar('Please enter valid email or mobile number');
      _emailErrorShown = true;
    }
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
      if (showSnackbar && !_passwordErrorShown) {
        showErrorSnackbar('Password must be at least 8 characters');
        _passwordErrorShown = true;
      }
    } else {
      isPasswordValid.value = true;
      passwordError.value = '';
      _passwordErrorShown = false;
    }
    _checkFormValidity();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
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

  void loginWithValidation() {
    String branchCode = branchCodeController?.text.trim() ?? '';
    String email = emailController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';

    _branchCodeErrorShown = false;
    _emailErrorShown = false;
    _passwordErrorShown = false;

    if (branchCode.isEmpty) {
      showErrorSnackbar('Please enter branch code');
      return;
    }
    if (branchCode.length < 3) {
      showErrorSnackbar('Branch code must be at least 3 characters');
      return;
    }

    if (email.isEmpty) {
      showErrorSnackbar('Please enter email or mobile number');
      return;
    }

    if (email.contains('@')) {
      if (!_isValidEmail(email)) {
        showErrorSnackbar('Please enter valid email address');
        return;
      }
    } else if (RegExp(r'^[0-9]+$').hasMatch(email)) {
      if (email.length != 10) {
        showErrorSnackbar('Mobile number must be 10 digits');
        return;
      }
    } else if (email.length < 3 ||
        !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(email)) {
      showErrorSnackbar('Please enter valid email or mobile number');
      return;
    }

    if (password.isEmpty) {
      showErrorSnackbar('Please enter password');
      return;
    }
    if (password.length < 8) {
      showErrorSnackbar('Password must be at least 8 characters');
      return;
    }

    loginAPI();
  }

  // ========== ✅ FULL LOGIN RESPONSE STORAGE METHODS ==========

  /// Save the entire LoginResponse as a JSON string
  Future<void> saveFullLoginResponse(LoginResponse response) async {
    final deviceRepository = Get.find<DeviceRepository>();
    final jsonString = loginResponseToJson(response); // from your model
    await deviceRepository.saveValueSecurely(DeviceConstants.loginResponse, jsonString);
    print('✅ Full login response saved to shared preferences');
  }

  /// Retrieve the full LoginResponse
  Future<LoginResponse?> getFullLoginResponse() async {
    final deviceRepository = Get.find<DeviceRepository>();
    final jsonString = await deviceRepository.getSecuredValue(DeviceConstants.loginResponse);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return LoginResponse.fromJson(jsonMap);
      } catch (e) {
        print('❌ Error parsing login response: $e');
        return null;
      }
    }
    return null;
  }

  /// Clear the stored login response (call on logout)
  Future<void> clearFullLoginResponse() async {
    final deviceRepository = Get.find<DeviceRepository>();
    await GetStorage().remove(DeviceConstants.loginResponse);
    print('✅ Full login response cleared');
  }

  // ========== LOGIN API ==========

  Future<void> loginAPI() async {
    String loginName = emailController?.text.trim() ?? '';
    String branchCode = branchCodeController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';

    var res = await loginStudentPresenter.loginAPI(
      isLoading: true,
      loginName: loginName,
      branchCode: branchCode,
      password: password,
    );

    print("Login response: $res");

    if (res != null && res.status == true) {
      print("✅ Login successful");

      // ✅ Store the entire response
      await saveFullLoginResponse(res);

      // ✅ Get API role
      String? apiRole = res.data?.user.userType?.toLowerCase() ?? '';
      print("📌 API User Type: $apiRole");

      String displayRole = apiToDisplayRole[apiRole] ?? apiRole;
      print("📌 Display Role: $displayRole");

      String navigationRole = apiRole.isNotEmpty ? apiRole : 'student';

      var deviceRepository = Get.find<DeviceRepository>();

      // ✅ Save token and other individual fields (backward compatibility)
      String token = '${res.data?.token}';
      await deviceRepository.saveValueSecurely(DeviceConstants.token, token);
      print("✅ Token saved: $token");

      await deviceRepository.saveValueSecurely(DeviceConstants.userRole, navigationRole);
      print("✅ User role saved: $navigationRole");

      await deviceRepository.saveValueSecurely(DeviceConstants.branchId, '${res.data?.branchId}');
      await deviceRepository.saveValueSecurely(DeviceConstants.branchCode, '${res.data?.branchCode}');
      await deviceRepository.saveValueSecurely(DeviceConstants.email, '${res.data?.user.email}');
      await deviceRepository.saveValueSecurely(DeviceConstants.username, '${res.data?.user.username}');
      await deviceRepository.saveValueSecurely(DeviceConstants.studentId, '${res.data?.user.studentId}');

      // ✅ Verify token exists
      String? finalCheck = await deviceRepository.getSecuredValue(DeviceConstants.token);
      print("✅ Final token check before home: ${finalCheck != null ? 'EXISTS' : 'NOT FOUND'}");

      await Future.delayed(const Duration(milliseconds: 500));

      navigateBasedOnRole(navigationRole);
    } else {
      print("❌ Login failed");
      showErrorSnackbar('Login failed. Please check your credentials.');
    }
  }

  // ========== NAVIGATE BASED ON ROLE ==========

  void navigateBasedOnRole(String role) {
    print("🚀 Navigating based on role: $role");

    String roleLower = role.toLowerCase();

    if (roleLower == 'student') {
      print("📚 Navigating to Student Dashboard");
      RouteManagement.goToHome();
    } else if (roleLower == 'staff') {
      print("👨‍🏫 Navigating to Staff/Teacher Dashboard");
      RouteManagement.goToTeacherDashboard();
    } else if (roleLower == 'parent') {
      print("👨‍👩‍👧 Navigating to Parent Dashboard");
      // RouteManagement.goToParentDashboard(); // Uncomment when ready
    } else {
      print("⚠️ Unknown role: $role, defaulting to Student Dashboard");
      RouteManagement.goToHome();
    }

    clearAllFields();
  }

  // ========== GET USER ROLE ==========

  Future<String?> getUserRole() async {
    var deviceRepository = Get.find<DeviceRepository>();
    return await deviceRepository.getSecuredValue(DeviceConstants.userRole);
  }

  // ========== CHECK LOGIN STATUS ==========

  Future<bool> isUserLoggedIn() async {
    var deviceRepository = Get.find<DeviceRepository>();
    String? token = await deviceRepository.getSecuredValue(DeviceConstants.token);
    return token != null && token.isNotEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void clearEmailError() {
    if (emailError.value.isNotEmpty) {
      emailError.value = '';
      isEmailValid.value = false;
      _checkFormValidity();
    }
  }

  void clearBranchCodeError() {
    if (branchCodeError.value.isNotEmpty) {
      branchCodeError.value = '';
      isBranchCodeValid.value = false;
      _checkFormValidity();
    }
  }

  void clearPasswordError() {
    if (passwordError.value.isNotEmpty) {
      passwordError.value = '';
      isPasswordValid.value = false;
      _checkFormValidity();
    }
  }

  @override
  void onClose() {
    // Remove listeners only, keep controllers alive for reuse
    branchCodeFocusNode?.removeListener(_onBranchCodeFocusChange);
    emailFocusNode?.removeListener(_onEmailFocusChange);
    passwordFocusNode?.removeListener(_onPasswordFocusChange);

    // Do NOT dispose controllers here
    super.onClose();
  }
}