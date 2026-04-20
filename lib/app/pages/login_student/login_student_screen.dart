import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_student.dart';

class LoginStudentScreen extends StatelessWidget {
  const LoginStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginStudentController>(
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: true, // Keep this true for scrolling
        backgroundColor: ColorsValue.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              // Top header image
              Container(
                padding: const EdgeInsets.only(top: 5),
                height: Dimens.threeHundredSeventyFive,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(controller.getHeaderImage(controller.fromScreen.value)),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Bottom white container
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  child: Container(
                    width: Dimens.percentWidth(1),
                    height: Dimens.percentHeight(0.63),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(), // Better scrolling
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Dismiss keyboard on scroll
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom, // Extra padding for keyboard
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              // Email/Username Field
                              Obx(() => FormFieldWidget(
                                onTap: () async {},
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                labelText: StringConstants.usernameEmail,
                                formStyle: Styles.darkBlue16,
                                textInputAction: TextInputAction.next,
                                labelStyle: Styles.blueDarkHintReg12,
                                textInputType: TextInputType.emailAddress,
                                focusNode: controller.emailFocusNode,
                                maxLength: 45,
                                errorText: controller.emailErrorText.value.isNotEmpty ? controller.emailErrorText.value : null,
                                errorStyle: Styles.lightRed12,
                                textEditingController: controller.emailMobileEditingController,
                                onChange: (String val) {
                                  controller.clearEmailError();
                                  controller.validateEmailOrUsername(val);
                                  controller.update();
                                },
                                onFieldSubmitted: (String val) {
                                  FocusScope.of(context).requestFocus(controller.branchCodeFocusNode);
                                },
                              )),
                              const SizedBox(height: 15),

                              // Branch Code Field
                              Obx(() => FormFieldWidget(
                                onTap: () async {},
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                labelText: StringConstants.branchCode,
                                formStyle: Styles.darkBlue16,
                                textInputAction: TextInputAction.next,
                                labelStyle: Styles.blueDarkHintReg12,
                                textInputType: TextInputType.text,
                                focusNode: controller.branchCodeFocusNode,
                                maxLength: 45,
                                errorText: controller.branchCodeErrorText.value.isNotEmpty ? controller.branchCodeErrorText.value : null,
                                errorStyle: Styles.lightRed12,
                                textEditingController: controller.branchCodeEditingController,
                                onChange: (String val) {
                                  controller.clearBranchCodeError();
                                  controller.validateBranchCode(val);
                                  controller.update();
                                },
                                onFieldSubmitted: (String val) {
                                  FocusScope.of(context).requestFocus(controller.passwordFocusNode);
                                },
                              )),
                              const SizedBox(height: 15),

                              // Password Field
                              Obx(() => FormFieldWidget(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                obscureCharacter: '\u2022',
                                textEditingController: controller.passwordEditingController,
                                labelText: StringConstants.password,
                                isObscureText: !controller.isPasswordVisible,
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                formStyle: Styles.darkBlue16,
                                labelStyle: Styles.blueDarkHintReg12,
                                focusNode: controller.passwordFocusNode,
                                onChange: (String val) {
                                  controller.clearPasswordError();
                                  controller.validatePassword(val);
                                  controller.update();
                                },
                                onFieldSubmitted: (String val) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.isFormValid.value) {
                                    controller.loginAPI();
                                  }
                                },
                                errorText: controller.passwordErrors.value.isNotEmpty ? controller.passwordErrors.value : null,
                                errorStyle: Styles.lightRed12,
                                suffixIcon: InkWell(
                                  onTap: controller.updatePasswordVisibility,
                                  child: controller.isPasswordVisible
                                      ? Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    child: SvgPicture.asset(
                                      AssetConstants.icClose,
                                      width: 15,
                                      height: 15,
                                    ),
                                  )
                                      : Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    child: SvgPicture.asset(
                                      AssetConstants.iconView,
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(height: 30),

                              // Remember me and Forgot Password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.black,
                                          value: controller.rememberMe,
                                          onChanged: (bool? value) {
                                            controller.onRememberMeChanged(value!);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        StringConstants.rememberMe,
                                        style: Styles.blackBold17,
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: RouteManagement.goToForgotPassword,
                                    child: Text(
                                      StringConstants.forgotPassword,
                                      style: Styles.darkBlue14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // Sign In Button
                              Obx(() => Opacity(
                                opacity: controller.isFormValid.value ? 1.0 : 0.5,
                                child: FormSubmitWidget(
                                  buttonHeight: Dimens.fourty,
                                  text: StringConstants.signIn,
                                  textStyle: Styles.whiteBold16,
                                  buttonColor: ColorsValue.signInButtonColor,
                                  borderRadius: Dimens.five,
                                  onTap: controller.isFormValid.value
                                      ? () {
                                    FocusScope.of(context).unfocus();
                                    controller.validateEmailOrUsername(controller.emailMobileEditingController.text);
                                    controller.validateBranchCode(controller.branchCodeEditingController.text);
                                    controller.validatePassword(controller.passwordEditingController.text);

                                    if (controller.isEmailValid.value &&
                                        controller.isBranchCodeValid.value &&
                                        controller.isPasswordValid.value) {
                                      controller.loginAPI();
                                    }
                                  }
                                      : null,
                                ),
                              )),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}