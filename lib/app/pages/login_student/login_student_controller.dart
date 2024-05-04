import 'package:flutter/widgets.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/device/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginStudentController extends GetxController
    with GetTickerProviderStateMixin {
  bool isEmailValid = false;
  bool onPasswordListening = false;
  bool isPasswordValid = false;
  bool isPasswordVisible = false;
  bool isEmail = false;
  bool isNumberValid = false;
  bool isPasswordReset = false;
  String emailId = '';
  String phoneNumber = '';
  String password = '';
  String? numberErrorText;
  String? emailErrorText;
  String? passwordErrors;
  var focusNode = FocusNode();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController emailMobileEditingController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  var keyValidationForm = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void onInit() {
    super.onInit();
  }

  void checkIfNumberIsValid(String number) {
    if (number.isEmpty) {
      isNumberValid = false;
      //numberErrorText = StringConstants.pleaseEnterPhoneNumber;
    } else {
      isNumberValid = Utility.phoneValidator(number);
      if (Utility.phoneValidator(number)) {
        numberErrorText = null;
      } else {
        //   numberErrorText = isNumberValid ? null : StringConstants.pleaseEnterValidNumber;
      }
    }
    phoneNumber = number;
    update();
  }

  @override
  void onClose() {
    passwordFocusNode.dispose();
    super.onClose();
  }

  void checkIfPasswordIsValid(String value) {
    onPasswordListening = true;
    password = value;
    passwordErrors = Utility.validatePassword(value);
    isPasswordValid = passwordErrors == null ? true : false;
    update();
  }

  void updatePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  // Future<void> getKeyHash() async {
  //   String keyHash;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     keyHash = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
  //         'Unknown platform KeyHash';
  //   } on PlatformException {
  //     keyHash = 'Failed to get Kay Hash.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //
  //     _keyHash = keyHash;
  //
  //
  //   print('object');
  //   print(_keyHash);
  // }

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

  void checkEmailIsValid(String email) {
    if (email.isEmpty) {
      isEmailValid = false;
      emailErrorText = StringConstants.pleaseEnterEmail;
    } else {
      isEmailValid =
          Utility.emailValidator(email) || Utility.phoneValidator(email);
      if (Utility.emailValidator(email) || Utility.phoneValidator(email)) {
        emailErrorText = null;
      } else {
        emailErrorText =
            isEmailValid ? null : StringConstants.pleaseEnterValidEmail;
      }
    }
    emailId = email;
    update();
  }

  void onRememberMeChanged(bool newValue) {
    rememberMe = newValue;
    var deviceRepository = Get.find<DeviceRepository>();
    if (rememberMe) {
      deviceRepository.saveValueSecurely(
          DeviceConstants.email, emailMobileEditingController.text.toString());
      deviceRepository.saveValueSecurely(
          DeviceConstants.password, passwordEditingController.text.toString());
    } else {
      deviceRepository.deleteAllSecuredValues();
    }
    update();
  }
}
