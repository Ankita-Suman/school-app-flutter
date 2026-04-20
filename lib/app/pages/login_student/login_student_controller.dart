import 'package:flutter/widgets.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/device/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/helpers/connect_helper.dart';
import '../../../domain/repositories/domain_repository.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';
import 'login_student_presenter.dart';

class LoginStudentController extends GetxController {
  LoginStudentController(this.loginStudentPresenter);

  final LoginStudentPresenter loginStudentPresenter;

  // Make observables for reactive UI
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isBranchCodeValid = false.obs;
  var isFormValid = false.obs;

  bool onPasswordListening = false;
  bool isPasswordVisible = false;
  bool isEmail = false;
  bool isNumberValid = false;
  bool isPasswordReset = false;

  String emailId = '';
  String phoneNumber = '';
  String password = '';

  var numberErrorText = ''.obs;
  var emailErrorText = ''.obs;
  var branchCodeErrorText = ''.obs;
  var passwordErrors = ''.obs;

  // Focus nodes for each field
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode branchCodeFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController emailMobileEditingController = TextEditingController();
  TextEditingController branchCodeEditingController = TextEditingController();

  var keyValidationForm = GlobalKey<FormState>();
  bool rememberMe = false;

  // Observable variable for header text
  final headerText = ''.obs;
  final fromScreen = ''.obs;
  final headerImage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners to check form validity in real-time
    emailMobileEditingController.addListener(_checkFormValidity);
    passwordEditingController.addListener(_checkFormValidity);
    branchCodeEditingController.addListener(_checkFormValidity);

    try {
      final args = Get.arguments;
      print('📦 Arguments received: $args');

      if (args == null) {
        print('⚠️ No arguments');
        fromScreen.value = '';
      } else if (args is String) {
        print('✅ String argument');
        fromScreen.value = args;
      } else if (args is Map) {
        print('✅ Map argument with keys: ${args.keys}');

        if (args.containsKey('fromScreen')) {
          fromScreen.value = args['fromScreen']?.toString() ?? '';
        } else if (args.containsKey('role')) {
          fromScreen.value = args['role']?.toString() ?? '';
        } else {
          final firstValue = args.values.first;
          fromScreen.value = firstValue?.toString() ?? '';
        }
      } else {
        fromScreen.value = args.toString();
      }
    } catch (e) {
      fromScreen.value = '';
    }
    getHeaderImage(fromScreen.value);
  }

  void _checkFormValidity() {
    // Update form validity based on all three fields
    isFormValid.value = isEmailValid.value && isPasswordValid.value && isBranchCodeValid.value;
    print("Form Valid: ${isFormValid.value}, Email: ${isEmailValid.value}, Password: ${isPasswordValid.value}, Branch: ${isBranchCodeValid.value}");
    update();
  }

  // Helper method to get image based on fromScreen
  String getHeaderImage(String fromScreen) {
    switch(fromScreen) {
      case 'student':
        return AssetConstants.icStudentHeader;
      case 'teacher':
        return AssetConstants.icTeacherHeader;
      default:
        return AssetConstants.icParentHeader;
    }
  }

  // @override
  // void onClose() {
  //   // Dispose all focus nodes
  //   // emailFocusNode.dispose();
  //   // branchCodeFocusNode.dispose();
  //   // passwordFocusNode.dispose();
  //
  //   // Dispose controllers
  //   emailMobileEditingController.dispose();
  //   passwordEditingController.dispose();
  //   branchCodeEditingController.dispose();
  //   super.onClose();
  // }

  void checkIfPasswordIsValid(String value) {
    onPasswordListening = true;
    password = value;
    validatePassword(value);
    update();
  }

  void updatePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  Future<void> loginAPI() async {
    String loginName = emailMobileEditingController.text.trim();
    String branchCode = branchCodeEditingController.text.trim();
    String password = passwordEditingController.text.trim();

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
      print("User: ${res.data?.user.email}");
      print("User: ${res.data?.branchId}");
      print("User: ${res.data?.branchCode}");

      var deviceRepository = Get.find<DeviceRepository>();
      deviceRepository.saveValueSecurely(
          DeviceConstants.token, '${res.data?.token}');
      deviceRepository.saveValueSecurely(
          DeviceConstants.branchId, '${res.data?.branchId}');
      deviceRepository.saveValueSecurely(
          DeviceConstants.branchCode, '${res.data?.branchCode}');
      deviceRepository.saveValueSecurely(
          DeviceConstants.email, '${res.data?.user.email}');
      deviceRepository.saveValueSecurely(
          DeviceConstants.username, '${res.data?.user.username}');

      // Save credentials if remember me is checked
      if (rememberMe) {
        deviceRepository.saveValueSecurely(
            DeviceConstants.email, loginName);
        deviceRepository.saveValueSecurely(
            DeviceConstants.password, password);
      }

      RouteManagement.goToHome();
    }
  }

  void updateLoginType() {
    if (isEmail) {
      isEmail = false;
      passwordEditingController.clear();
      emailMobileEditingController.clear();
    } else {
      isEmail = true;
      passwordEditingController.clear();
      emailMobileEditingController.clear();
    }
    update();
  }

  // Validation methods
  String? validateEmailOrUsername(String? value) {
    value = value ?? emailMobileEditingController.text;

    // Check if empty
    if (value.isEmpty) {
      isEmailValid.value = false;
      emailErrorText.value = StringConstants.pleaseEnterEmail;
      _checkFormValidity();
      return StringConstants.pleaseEnterEmail;
    }

    // Check if it's a valid email (with @ symbol)
    if (value.contains('@')) {
      if (!_isValidEmail(value)) {
        isEmailValid.value = false;
        emailErrorText.value = StringConstants.pleaseEnterValidEmail;
        _checkFormValidity();
        return StringConstants.pleaseEnterValidEmail;
      }
      // Email is valid
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    // Check if it's a valid phone number (10 digits)
    if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    // Check for valid username with special characters
    if (value.length < 3) {
      isEmailValid.value = false;
      emailErrorText.value = 'Username must be at least 3 characters';
      _checkFormValidity();
      return 'Username must be at least 3 characters';
    }

    if (value.length > 50) {
      isEmailValid.value = false;
      emailErrorText.value = 'Username cannot exceed 50 characters';
      _checkFormValidity();
      return 'Username cannot exceed 50 characters';
    }

    if (RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      isEmailValid.value = true;
      emailErrorText.value = '';
      _checkFormValidity();
      return null;
    }

    // If none of the above conditions match
    isEmailValid.value = false;
    emailErrorText.value = 'Please enter valid email, phone number, or username (letters, numbers, ., -, _)';
    _checkFormValidity();
    return 'Please enter valid email, phone number, or username (letters, numbers, ., -, _)';
  }

  String? validatePassword(String? value) {
    value = value ?? passwordEditingController.text;
    String trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      isPasswordValid.value = false;
      passwordErrors.value = 'Password cannot be empty';
      _checkFormValidity();
      return 'Password cannot be empty';
    }

    if (trimmedValue.length < 8) {
      isPasswordValid.value = false;
      passwordErrors.value = 'Password must be at least 8 characters';
      _checkFormValidity();
      return 'Password must be at least 8 characters';
    }

    isPasswordValid.value = true;
    passwordErrors.value = '';
    _checkFormValidity();
    return null;
  }

  String? validateBranchCode(String? value) {
    value = value ?? branchCodeEditingController.text;

    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeErrorText.value = 'Please enter branch code';
      _checkFormValidity();
      return 'Please enter branch code';
    }

    isBranchCodeValid.value = true;
    branchCodeErrorText.value = '';
    _checkFormValidity();
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void checkEmailIsValid(String email) {
    emailId = email;
    validateEmailOrUsername(email);
    update();
  }

  void onRememberMeChanged(bool newValue) {
    rememberMe = newValue;
    update();
  }

  // Clear error methods
  void clearEmailError() {
    if (emailErrorText.value.isNotEmpty) {
      emailErrorText.value = '';
      isEmailValid.value = false;
      _checkFormValidity();
      update();
    }
  }

  void clearBranchCodeError() {
    if (branchCodeErrorText.value.isNotEmpty) {
      branchCodeErrorText.value = '';
      isBranchCodeValid.value = false;
      _checkFormValidity();
      update();
    }
  }

  void clearPasswordError() {
    if (passwordErrors.value.isNotEmpty) {
      passwordErrors.value = '';
      isPasswordValid.value = false;
      _checkFormValidity();
      update();
    }
  }
}