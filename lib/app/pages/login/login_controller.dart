// login_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/login_response.dart';
import '../../../domain/models/school_info_response.dart';
import '../../navigators/routes_management.dart';
import 'login_presenter.dart';

class LoginController extends GetxController {
  LoginController(this.loginStudentPresenter);

  final LoginPresenter loginStudentPresenter;

  // ========== ROLE SELECTION ==========
  var selectedRole = 'student'.obs;
  var selectedTab = 0.obs;

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
  var isLoading = false.obs;
  var schoolInfoData = Rxn<SchoolInfoResponse>();

  // Track last fetched branch to avoid duplicate calls
  var _lastFetchedBranch = ''.obs;
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();

    branchCodeController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    branchCodeFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    branchCodeFocusNode?.addListener(_onBranchCodeFocusChange);
    emailFocusNode?.addListener(_onEmailFocusChange);
    passwordFocusNode?.addListener(_onPasswordFocusChange);

    branchCodeController?.addListener(_checkFormValidity);
    emailController?.addListener(_checkFormValidity);
    passwordController?.addListener(_checkFormValidity);
  }

  // ========== FETCH SCHOOL INFO BY BRANCH CODE ==========
  Future<void> fetchSchoolInfoForBranch(String branchCode) async {
    if (branchCode.isEmpty || branchCode.length < 3) return;
    if (_isFetching) return;

    // If same branch and already have valid data, no need to fetch again
    if (_lastFetchedBranch.value == branchCode && schoolInfoData.value != null) {
      return;
    }

    _isFetching = true;
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      await deviceRepo.saveValueSecurely(DeviceConstants.branchCode, branchCode);

      isLoading.value = true;

      var res = await loginStudentPresenter.getSchoolInfo(
        isLoading: false,
        branchCode: branchCode,
      );

      debugPrint("🔍 School Info Response: ${res?.toJson()}");

      if (res != null && res.status == true && res.data != null) {
        final schoolName = res.data?.schoolName ?? '';
        final branchName = res.data?.branchName ?? '';
        if (schoolName.isNotEmpty && branchName.isNotEmpty) {
          schoolInfoData.value = res;
          _lastFetchedBranch.value = branchCode;
          debugPrint("✅ School info set: $schoolName - $branchName");
        } else {
          schoolInfoData.value = null;
          _lastFetchedBranch.value = '';
          debugPrint("❌ Branch not found: Empty school/branch names");
        }
      } else {
        schoolInfoData.value = null;
        _lastFetchedBranch.value = '';
        debugPrint("❌ School info failed: ${res?.message}");
      }
    } catch (e) {
      debugPrint("❌ School info error: $e");
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  // ========== VALIDATION (no debounce, only validation) ==========
  void validateBranchCode(String value) {
    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
      _checkFormValidity();
      return;
    }

    if (value.length < 3) {
      isBranchCodeValid.value = false;
      branchCodeError.value = 'Branch code must be at least 3 characters';
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
      _checkFormValidity();
      return;
    }

    // Valid branch code
    isBranchCodeValid.value = true;
    branchCodeError.value = '';
    _branchCodeErrorShown = false;
    _checkFormValidity();

    // ❌ DO NOT call fetch here – only on focus loss
  }

  // ========== FOCUS CHANGE HANDLERS ==========
  void _onBranchCodeFocusChange() {
    if (branchCodeFocusNode == null) return;
    isBranchCodeFocused.value = branchCodeFocusNode!.hasFocus;

    // When focus is lost and branch code is valid → fetch immediately
    if (!branchCodeFocusNode!.hasFocus) {
      final branchCode = branchCodeController?.text.trim() ?? '';
      if (branchCode.length >= 3 && isBranchCodeValid.value) {
        fetchSchoolInfoForBranch(branchCode);
      }
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

  // ========== OTHER VALIDATION METHODS ==========
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

    isEmailValid.value = false;
    emailError.value = 'Please enter valid email or 10-digit mobile number';
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
    isFormValid.value = isEmailValid.value && isPasswordValid.value && isBranchCodeValid.value;
  }

  // ========== SNACKBARS & DIALOGS ==========
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

  // ========== LOGIN WITH VALIDATION ==========
  void loginWithValidation() {
    if (selectedTab.value == 1) {
      showComingSoonDialog();
      return;
    }

    String branchCode = branchCodeController?.text.trim() ?? '';
    String email = emailController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';

    _branchCodeErrorShown = false;
    _emailErrorShown = false;
    _passwordErrorShown = false;

    bool hasError = false;

    if (branchCode.isEmpty) {
      branchCodeError.value = 'Please enter branch code';
      hasError = true;
    } else if (branchCode.length < 3) {
      branchCodeError.value = 'Branch code must be at least 3 characters';
      hasError = true;
    } else {
      branchCodeError.value = '';
    }

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
      if (branchCodeError.value.isNotEmpty) {
        branchCodeFocusNode?.requestFocus();
      } else if (emailError.value.isNotEmpty) {
        emailFocusNode?.requestFocus();
      } else if (passwordError.value.isNotEmpty) {
        passwordFocusNode?.requestFocus();
      }
      return;
    }

    loginAPI();
  }

  // ========== LOGIN API & STORAGE ==========
  Future<void> saveFullLoginResponse(LoginResponse response) async {
    final deviceRepository = Get.find<DeviceRepository>();
    final jsonString = loginResponseToJson(response);
    await deviceRepository.saveValueSecurely(DeviceConstants.loginResponse, jsonString);
  }

  Future<LoginResponse?> getFullLoginResponse() async {
    final deviceRepository = Get.find<DeviceRepository>();
    final jsonString = await deviceRepository.getSecuredValue(DeviceConstants.loginResponse);
    if (jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return LoginResponse.fromJson(jsonMap);
      } catch (e) {
        debugPrint('❌ Error parsing login response: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearFullLoginResponse() async {
    await GetStorage().remove(DeviceConstants.loginResponse);
  }

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

    if (res != null && res.status == true) {
      await saveFullLoginResponse(res);

      String? apiRole = res.data?.user.userType.toLowerCase() ?? '';
      String displayRole = apiToDisplayRole[apiRole] ?? apiRole;
      String navigationRole = apiRole.isNotEmpty ? apiRole : 'student';

      var deviceRepository = Get.find<DeviceRepository>();

      String token = '${res.data?.token}';
      await deviceRepository.saveValueSecurely(DeviceConstants.token, token);
      await deviceRepository.saveValueSecurely(DeviceConstants.userRole, navigationRole);
      await deviceRepository.saveValueSecurely(DeviceConstants.branchId, '${res.data?.branchId}');
      await deviceRepository.saveValueSecurely(DeviceConstants.branchCode, '${res.data?.branchCode}');
      await deviceRepository.saveValueSecurely(DeviceConstants.email, '${res.data?.user.email}');
      await deviceRepository.saveValueSecurely(DeviceConstants.username, '${res.data?.user.username}');
      await deviceRepository.saveValueSecurely(DeviceConstants.studentId, '${res.data?.user.studentId}');
      await deviceRepository.saveValueSecurely(DeviceConstants.staffId, res.data?.user.staffId ?? '');

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

  void navigateBasedOnRole(String role) {
    String roleLower = role.toLowerCase();
    if (roleLower == 'student') {
      RouteManagement.goToHome();
      clearAllFields();
    } else if (roleLower == 'staff') {
      RouteManagement.goToTeacherDashboard();
      clearAllFields();
    } else if (roleLower == 'parent') {
      showComingSoonDialog();
      clearAllFields();
    } else {
      showComingSoonDialog();
      clearAllFields();
    }
  }

  Future<String?> getUserRole() async {
    var deviceRepository = Get.find<DeviceRepository>();
    return await deviceRepository.getSecuredValue(DeviceConstants.userRole);
  }

  Future<bool> isUserLoggedIn() async {
    var deviceRepository = Get.find<DeviceRepository>();
    String? token = await deviceRepository.getSecuredValue(DeviceConstants.token);
    return token.isNotEmpty;
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

    schoolInfoData.value = null;
    _lastFetchedBranch.value = '';
  }

  @override
  void onClose() {
    branchCodeFocusNode?.removeListener(_onBranchCodeFocusChange);
    emailFocusNode?.removeListener(_onEmailFocusChange);
    passwordFocusNode?.removeListener(_onPasswordFocusChange);
    super.onClose();
  }
}