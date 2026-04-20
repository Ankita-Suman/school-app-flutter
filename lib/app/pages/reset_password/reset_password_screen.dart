import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reset_password.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsValue.primaryColor,
          leading: GestureDetector(
            onTap: () {
              controller.clearForm();
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
        resizeToAvoidBottomInset: true,
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
                    child: SingleChildScrollView(
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
                                  'Reset Your Password',
                                  style: Styles.blueDark20,
                                ),
                                Dimens.boxHeight10,
                                Text(
                                  'Set a new password for your account',
                                  style: Styles.greyDark14,
                                  textAlign: TextAlign.center,
                                ),
                                Dimens.boxHeight20,
                                // Password Field
                                Obx(() => FormFieldWidget(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  obscureCharacter: '\u2022',
                                  textEditingController: controller.passwordEditingController,
                                  labelText: 'New Password',
                                  isObscureText: !controller.isPasswordVisible,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  formStyle: Styles.darkBlue16,
                                  labelStyle: Styles.blueDarkHintReg12,
                                  focusNode: controller.passwordFocusNode,
                                  onChange: (String val) {
                                    // Validation happens automatically via listener
                                  },
                                  onFieldSubmitted: (String val) {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  errorText: controller.passwordErrors.value.isNotEmpty
                                      ? controller.passwordErrors.value
                                      : null,
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

                                Dimens.boxHeight10,
                                // Confirm Password Field
                                Obx(() => FormFieldWidget(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  obscureCharacter: '\u2022',
                                  textEditingController: controller.confirmPasswordEditingController,
                                  labelText: 'Confirm New Password',
                                  isObscureText: !controller.isConfirmPasswordVisible,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  formStyle: Styles.darkBlue16,
                                  labelStyle: Styles.blueDarkHintReg12,
                                  focusNode: controller.confirmPasswordFocusNode,
                                  onChange: (String val) {
                                    // Validation happens automatically via listener
                                  },
                                  onFieldSubmitted: (String val) {
                                    FocusScope.of(context).unfocus();
                                    if (controller.isFormValid.value) {
                                      controller.resetPassword();
                                    }
                                  },
                                  errorText: controller.confirmPasswordErrors.value.isNotEmpty
                                      ? controller.confirmPasswordErrors.value
                                      : null,
                                  errorStyle: Styles.lightRed12,
                                  suffixIcon: InkWell(
                                    onTap: controller.updateConfirmPasswordVisibility,
                                    child: controller.isConfirmPasswordVisible
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

                                Dimens.boxHeight40,

                                // Reset Button
                                Obx(() => Opacity(
                                  opacity: controller.isFormValid.value ? 1.0 : 0.5,
                                  child: FormSubmitWidget(
                                    buttonHeight: Dimens.fourtyFive,
                                    text: 'Reset Password',
                                    textStyle: Styles.whiteBold16,
                                    buttonColor: ColorsValue.signInButtonColor,
                                    borderRadius: Dimens.five,
                                    // 🔴 FIX: Disable button while loading
                                    onTap: (controller.isFormValid.value && !controller.isLoading.value)
                                        ? () {
                                      FocusScope.of(context).unfocus();
                                      controller.resetPassword();
                                    }
                                        : null,
                                  ),
                                )),

                                // 🔴 ADD: Loading indicator
                                Obx(() => controller.isLoading.value
                                    ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: const CircularProgressIndicator(),
                                )
                                    : const SizedBox.shrink(),
                                ),

                                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 30),
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