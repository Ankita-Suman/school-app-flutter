// screens/new_otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../../theme/dimens.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/tab_bar.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              // Background
              SvgPicture.asset(
                AssetConstants.icBackG,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Center Logo - Responsive
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Image.asset(
                    AssetConstants.icLogos,
                    height: screenWidth * 0.35,
                    width: screenWidth * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Bottom Card
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.02),

                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Text(
                                'Welcome Back 👋',
                                style: Styles.darkBlcW70020,
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5_0_0_0,
                              child: Text(
                                'Sign in to continue your learning journey',
                                style: Styles.darkGry400,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Custom Tab Bar
                            const TabBarWidget(),

                            SizedBox(height: screenHeight * 0.02),

                            Padding(
                              padding: Dimens.edgeInsets5_0_5_0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                        onChanged: (value) => controller.validateBranchCode(value),
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

                                  // EMAIL ADDRESS Field
                                  Text('MOBILE / EMAIL ', style: Styles.darkGryW700),
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
                                        textInputAction: TextInputAction.next,
                                        style: Styles.darkBlcW400,
                                        onChanged: (value) => controller.validateEmail(value),
                                        onSubmitted: (value) {
                                          FocusScope.of(context).requestFocus(controller.passwordFocusNode);
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
                                  SizedBox(height: screenHeight * 0.02),

                                  // PASSWORD Field
                                  Text('PASSWORD', style: Styles.darkGryW700),
                                  SizedBox(height: screenHeight * 0.01),

                                  Obx(
                                        () => Container(
                                      decoration: BoxDecoration(
                                        color: controller.isPasswordFocused.value
                                            ? Colors.white
                                            : (controller.passwordController.text.isNotEmpty
                                            ? Colors.blue.shade50
                                            : Colors.grey.shade50),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: (controller.isPasswordFocused.value || controller.passwordController.text.isNotEmpty)
                                              ? Colors.blue.shade700
                                              : Colors.grey.shade300,
                                          width: (controller.isPasswordFocused.value || controller.passwordController.text.isNotEmpty) ? 1.5 : 1,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: controller.passwordController,
                                        focusNode: controller.passwordFocusNode,
                                        obscureText: !controller.isPasswordVisible.value,
                                        textInputAction: TextInputAction.done,
                                        style: Styles.darkBlcW400,
                                        onChanged: (value) => controller.validatePassword(value),
                                        onSubmitted: (value) {
                                          if (controller.isFormValid.value) {
                                            controller.loginWithValidation();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'password',
                                          hintStyle: Styles.darkGryW40014,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03,
                                            vertical: screenHeight * 0.015,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            size: screenWidth * 0.05,
                                            color: (controller.isPasswordFocused.value || controller.passwordController.text.isNotEmpty)
                                                ? Colors.blue.shade700
                                                : Colors.grey.shade500,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.isPasswordVisible.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: screenWidth * 0.05,
                                              color: (controller.isPasswordFocused.value || controller.passwordController.text.isNotEmpty)
                                                  ? Colors.blue.shade700
                                                  : Colors.grey.shade500,
                                            ),
                                            onPressed: () {
                                              controller.togglePasswordVisibility();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Sign In Button
                            Obx(
                                  () => Opacity(
                                opacity: controller.isFormValid.value ? 1.0 : 0.5,
                                child: GradientButton(
                                  onPressed: controller.isFormValid.value
                                      ? () {
                                    FocusScope.of(context).unfocus();
                                    controller.loginWithValidation();
                                  }
                                      : () {},
                                  text: 'Sign In',
                                  icon: Icon(Icons.login, size: screenWidth * 0.05, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),

                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  RouteManagement.goToNewForgotPassword();
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: Styles.darkBlueW50012
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.07),
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
      ),
    );
  }
}