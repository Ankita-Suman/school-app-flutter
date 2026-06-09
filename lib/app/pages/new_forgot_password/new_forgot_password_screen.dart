// screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'new_forgot_password_controller.dart';

class NewForgotPasswordScreen extends StatelessWidget {
  const NewForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<NewForgotPasswordController>(
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            // SVG Background
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        SizedBox(height: screenHeight * 0.010),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            AssetConstants.icBackBg,
                          ),
                        ),

                        // Lock Icon
                       SizedBox(
                            height: screenWidth * 0.25,
                            width: screenWidth * 0.25,
                            child: ClipRect(
                              child: SvgPicture.asset(
                                AssetConstants.icLocks,
                                height: screenWidth * 0.25,
                                width: screenWidth * 0.25,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                        // Heading Text
                        Text(
                          'Forgot Password?',
                          style: Styles.whiteExBold22,
                        ),

                        SizedBox(height: screenHeight * 0.005),

                        // Subtitle Text
                        Text(
                          'No worries! Enter your registered email or mobile number and we\'ll send you a recovery link.',
                          style: Styles.whiteW40013,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Card - Align Bottom Center
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // BRANCH CODE Field
                          Text('BRANCH CODE', style: Styles.darkGryW700),
                          SizedBox(height: screenHeight * 0.01),

                          Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                color: controller.isBranchCodeFocused.value
                                    ? Colors.white
                                    : (controller.branchCodeController.text.isNotEmpty
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (controller.isBranchCodeFocused.value || controller.branchCodeController.text.isNotEmpty)
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade300,
                                  width: (controller.isBranchCodeFocused.value || controller.branchCodeController.text.isNotEmpty) ? 1.5 : 1,
                                ),
                              ),
                              child: TextField(
                                controller: controller.branchCodeController,
                                focusNode: controller.branchCodeFocusNode,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                style: Styles.darkBlcW400,
                                onChanged: (value) {
                                  controller.validateBranchCode(value);
                                  controller.update();
                                },
                                onSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(controller.emailFocusNode);
                                },
                                decoration: InputDecoration(
                                  hintText: 'ASDF34UYGHS',
                                  hintStyle: Styles.darkGryW40014,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.02,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: screenWidth * 0.05,
                                    color: (controller.isBranchCodeFocused.value || controller.branchCodeController.text.isNotEmpty)
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // MOBILE / EMAIL Field
                          Text('MOBILE / EMAIL', style: Styles.darkGryW700),
                          SizedBox(height: screenHeight * 0.01),

                          Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                color: controller.isEmailFocused.value
                                    ? Colors.white
                                    : (controller.emailController.text.isNotEmpty
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (controller.isEmailFocused.value || controller.emailController.text.isNotEmpty)
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade300,
                                  width: (controller.isEmailFocused.value || controller.emailController.text.isNotEmpty) ? 1.5 : 1,
                                ),
                              ),
                              child: TextField(
                                controller: controller.emailController,
                                focusNode: controller.emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                style: Styles.darkBlcW400,
                                onChanged: (value) {
                                  controller.validateEmail(value);
                                  controller.update();
                                },
                                onSubmitted: (value) {
                                  if (controller.isFormValid.value) {
                                    controller.sendResetLink();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'olivier.thomas@edu.in',
                                  hintStyle: Styles.darkGryW40014,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.02,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: screenWidth * 0.05,
                                    color: (controller.isEmailFocused.value || controller.emailController.text.isNotEmpty)
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.045),

                          // OTP Info Card
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: ColorsValue.navSelectColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorsValue.darkFillBlueColor,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetConstants.icInfo,
                                  height: screenWidth * 0.06,
                                  width: screenWidth * 0.06,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.darkBlueW40011,
                                      children:  [
                                        const TextSpan(
                                          text: 'We\'ll send a ',
                                        ),
                                        TextSpan(
                                          text: '6-digit OTP',
                                          style: Styles.darkBlueW70011,
                                        ),
                                        const TextSpan(
                                          text: ' to your registered email address for identity verification.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Send Reset Link Button
                          Obx(
                                () => Opacity(
                              opacity: controller.isFormValid.value ? 1.0 : 0.5,
                              child: GradientButton(
                                onPressed: controller.isFormValid.value
                                    ? () {
                                  FocusScope.of(context).unfocus();
                                  controller.sendResetLink();
                                }
                                    : () {},
                                text: 'Send Reset Link',
                                icon: Icon(Icons.email_sharp, size: screenWidth * 0.05, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Rich Text - Remember password?
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Remember your password? ',
                                  style: Styles.darkBlackW700,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: Styles.darkBlueW700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}