import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsValue.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SizedBox(
              height: Dimens.ten,
              width: Dimens.ten,
              child: SvgPicture.asset(
                AssetConstants.icBackArrow,
                height: Dimens.ten,
                width: Dimens.ten,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true, // Changed to true for keyboard handling
        backgroundColor: ColorsValue.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 5),
                height: Dimens.threeHundredFourty,
                color: ColorsValue.primaryColor,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  child: Container(
                    width: Dimens.percentWidth(1),
                    height: Dimens.percentHeight(0.82),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView( // Added scroll view
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: Dimens.edgeInsets24_10_24_10,
                            child: Column(
                              children: [
                                Dimens.boxHeight10,
                                Text(
                                  StringConstants.forgotPasswordText,
                                  style: Styles.blueDark20,
                                ),
                                Dimens.boxHeight20,
                                Text(
                                  StringConstants.enterForgotMsg,
                                  style: Styles.greyDark14,
                                  textAlign: TextAlign.center,
                                ),
                                Dimens.boxHeight30,
                                // Email/Username Field
                                FormFieldWidget(
                                  onTap: () async {},
                                  contentPadding: Dimens.edgeInsets0_10_8_10,
                                  labelText: StringConstants.usernameEmail,
                                  formStyle: Styles.darkBlue16,
                                  textInputAction: TextInputAction.next,
                                  labelStyle: Styles.blueDarkHintReg12,
                                  textInputType: TextInputType.emailAddress,
                                  focusNode: controller.focusNode,
                                  maxLength: 45,
                                  errorText: controller.emailErrorText.value,
                                  errorStyle: Styles.lightRed12,
                                  textEditingController: controller.emailUsernameEditingController,
                                  onChange: (String val) {
                                    controller.validateEmailOrUsername(val);
                                    controller.update();
                                  },
                                  onFieldSubmitted: (String val) {
                                    // Move to branch code field when next pressed
                                    FocusScope.of(context).requestFocus(controller.branchCodeFocusNode);
                                  },
                                ),
                                Dimens.boxHeight15,
                                // Branch Code Field
                                FormFieldWidget(
                                  onTap: () async {},
                                  contentPadding: Dimens.edgeInsets0_10_8_10,
                                  labelText: StringConstants.branchCode,
                                  formStyle: Styles.darkBlue16,
                                  textInputAction: TextInputAction.done, // Show Done button
                                  labelStyle: Styles.blueDarkHintReg12,
                                  textInputType: TextInputType.text,
                                  focusNode: controller.branchCodeFocusNode,
                                  maxLength: 45,
                                  errorText: controller.branchCodeErrorText.value,
                                  errorStyle: Styles.lightRed12,
                                  textEditingController: controller.branchCodeEditingController,
                                  onChange: (String val) {
                                    controller.validateBranchCode(val);
                                    controller.update();
                                  },
                                  onFieldSubmitted: (String val) {
                                    // Close keyboard when done button pressed
                                    FocusScope.of(context).unfocus();
                                    // Submit form if valid
                                    if (controller.isFormValid.value) {
                                      controller.validateEmailOrUsername(controller.emailUsernameEditingController.text);
                                      controller.validateBranchCode(controller.branchCodeEditingController.text);

                                      if (controller.isEmailValid.value &&
                                          controller.isBranchCodeValid.value) {
                                        controller.forgotPasswordAPI(context);
                                      }
                                    }
                                  },
                                ),
                                Dimens.boxHeight30,
                                // Submit Button with Obx for reactive state
                                Obx(() => Opacity(
                                  opacity: controller.isFormValid.value ? 1.0 : 0.5,
                                  child: FormSubmitWidget(
                                    buttonHeight: Dimens.fourtyFive,
                                    text: StringConstants.submit,
                                    textStyle: Styles.whiteBold16,
                                    buttonColor: ColorsValue.signInButtonColor,
                                    borderRadius: Dimens.five,
                                    onTap: controller.isFormValid.value
                                        ? () {
                                      FocusScope.of(context).unfocus();
                                      controller.validateEmailOrUsername(controller.emailUsernameEditingController.text);
                                      controller.validateBranchCode(controller.branchCodeEditingController.text);

                                      if (controller.isEmailValid.value &&
                                          controller.isBranchCodeValid.value) {
                                        controller.forgotPasswordAPI(context);
                                      }
                                    }
                                        : null,
                                  ),
                                )),
                                // Add bottom padding for small devices
                                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 10),
                              ],
                            ),
                          ),
                        ],
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