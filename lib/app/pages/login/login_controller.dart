// controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/helpers/connect_helper.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/repositories/domain_repository.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';
import '../../navigators/routes_management.dart';
import 'login_presenter.dart';

class LoginController extends GetxController {
  LoginController(this.loginStudentPresenter);

  final LoginPresenter loginStudentPresenter;

  // Selected Tab
  var selectedTab = 0.obs;

  // Branch Code
  TextEditingController branchCodeController = TextEditingController();
  FocusNode branchCodeFocusNode = FocusNode();
  var isBranchCodeFocused = false.obs;
  var branchCodeError = ''.obs;
  var isBranchCodeValid = false.obs;
  bool _branchCodeErrorShown = false; // Track if error already shown

  // Email
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  var isEmailFocused = false.obs;
  var emailError = ''.obs;
  var isEmailValid = false.obs;
  bool _emailErrorShown = false; // Track if error already shown

  // Password
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  var isPasswordFocused = false.obs;
  var isPasswordVisible = false.obs;
  var passwordError = ''.obs;
  var isPasswordValid = false.obs;
  bool _passwordErrorShown = false; // Track if error already shown

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

  // Observable variables for header
  final headerText = ''.obs;
  final fromScreen = ''.obs;
  final headerImage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners for focus changes
    branchCodeFocusNode.addListener(() {
      isBranchCodeFocused.value = branchCodeFocusNode.hasFocus;
      // When focus leaves, validate and show error
      if (!branchCodeFocusNode.hasFocus && branchCodeController.text.isNotEmpty) {
        validateBranchCode(branchCodeController.text, showSnackbar: false);
      }
    });

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
      // When focus leaves, validate and show error
      if (!emailFocusNode.hasFocus && emailController.text.isNotEmpty) {
        validateEmail(emailController.text, showSnackbar: false);
      }
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
      // When focus leaves, validate and show error
      if (!passwordFocusNode.hasFocus && passwordController.text.isNotEmpty) {
        validatePassword(passwordController.text, showSnackbar: false);
      }
    });

    // Add listeners for text changes to validate form in real-time
    branchCodeController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    isFormValid.value = isEmailValid.value && isPasswordValid.value && isBranchCodeValid.value;
  }

  // Validation Methods
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
    if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    // Check phone number length
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

    // Check for valid username
    if (value.length >= 3 && RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailError.value = '';
      _emailErrorShown = false;
      _checkFormValidity();
      return;
    }

    // If none of the above conditions match
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

  // Login with validation
  void loginWithValidation() {
    String branchCode = branchCodeController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Reset error shown flags
    _branchCodeErrorShown = false;
    _emailErrorShown = false;
    _passwordErrorShown = false;

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
    // Check username
    else if (email.length < 3 || !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(email)) {
      showErrorSnackbar('Please enter valid email or mobile number');
      return;
    }

    // Validate Password
    if (password.isEmpty) {
      showErrorSnackbar('Please enter password');
      return;
    }
    if (password.length < 8) {
      showErrorSnackbar('Password must be at least 8 characters');
      return;
    }

    // If all validations pass
    loginAPI();
  }

  // API Login Method
  Future<void> loginAPI() async {
    String loginName = emailController.text.trim();
    String branchCode = branchCodeController.text.trim();
    String password = passwordController.text.trim();

    var res = await loginStudentPresenter.loginAPI(
      isLoading: true,
      loginName: loginName,
      branchCode: branchCode,
      password: password,
    );

    print("Login response: $res");

    if (res != null && res.status == true) {
      print("✅ Login successful");
      print("Status: ${res.status}");
      print("Message: ${res.message}");
      print("Token: ${res.data?.token}");
      print("User: ${res.data?.user.username}");
      print("email: ${res.data?.user.email}");
      print("branchId: ${res.data?.branchId}");
      print("branchCode: ${res.data?.branchCode}");

      var deviceRepository = Get.find<DeviceRepository>();
      deviceRepository.saveValueSecurely(DeviceConstants.token, '${res.data?.token}');
      deviceRepository.saveValueSecurely(DeviceConstants.branchId, '${res.data?.branchId}');
      deviceRepository.saveValueSecurely(DeviceConstants.branchCode, '${res.data?.branchCode}');
      deviceRepository.saveValueSecurely(DeviceConstants.email, '${res.data?.user.email}');
      deviceRepository.saveValueSecurely(DeviceConstants.username, '${res.data?.user.username}');
      deviceRepository.saveValueSecurely(DeviceConstants.studentId, '${res.data?.user.studentId}');

      RouteManagement.goToHome();
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Clear error methods
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
    branchCodeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    branchCodeFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}