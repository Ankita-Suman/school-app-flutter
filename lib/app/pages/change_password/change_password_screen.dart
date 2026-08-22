// screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<ChangePasswordController>(
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.010),
                        GestureDetector(
                          onTap: () {
                            controller.clearForm();
                            Get.back();
                          },
                          child: SvgPicture.asset(AssetConstants.icBackBg),
                        ),
                        SizedBox(
                          height: screenWidth * 0.25,
                          width: screenWidth * 0.25,
                          child: ClipRect(
                            child: SvgPicture.asset(
                              AssetConstants.icKeys,
                              height: screenWidth * 0.25,
                              width: screenWidth * 0.25,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Create New Password',
                          style: Styles.whiteExBold22,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Enter your new password to reset your account.',
                          style: Styles.whiteW40013,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.06),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // New Password Field
                        Text('New Password', style: Styles.darkGryW700),
                        SizedBox(height: screenHeight * 0.01),
                        Obx(
                              () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: controller.isNewPasswordFocused.value
                                      ? Colors.white
                                      : (controller.newPasswordController.text.isNotEmpty
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade50),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller.passwordErrors.value.isNotEmpty
                                        ? Colors.red
                                        : (controller.isNewPasswordFocused.value ||
                                        controller.newPasswordController.text.isNotEmpty)
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade300,
                                    width: controller.passwordErrors.value.isNotEmpty
                                        ? 1.5
                                        : (controller.isNewPasswordFocused.value ||
                                        controller.newPasswordController.text.isNotEmpty)
                                        ? 1.5
                                        : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.newPasswordController,
                                  focusNode: controller.newPasswordFocusNode,
                                  obscureText: !controller.isNewPasswordVisible.value,
                                  style: Styles.darkBlcW400,
                                  onChanged: (value) {
                                    controller.validateNewPassword(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter new password',
                                    hintStyle: Styles.darkGryW40014,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: screenHeight * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      size: screenWidth * 0.05,
                                      color: controller.passwordErrors.value.isNotEmpty
                                          ? Colors.red
                                          : (controller.isNewPasswordFocused.value ||
                                          controller.newPasswordController.text.isNotEmpty)
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade500,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isNewPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: screenWidth * 0.05,
                                        color: controller.passwordErrors.value.isNotEmpty
                                            ? Colors.red
                                            : (controller.isNewPasswordFocused.value ||
                                            controller.newPasswordController.text.isNotEmpty)
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade500,
                                      ),
                                      onPressed: () => controller.toggleNewPasswordVisibility(),
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.passwordErrors.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4, left: 4),
                                  child: Text(
                                    controller.passwordErrors.value,
                                    style: const TextStyle(fontSize: 12, color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),

                        // Confirm Password Field
                        Text('Confirm Password', style: Styles.darkGryW700),
                        SizedBox(height: screenHeight * 0.01),
                        Obx(
                              () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: controller.isConfirmPasswordFocused.value
                                      ? Colors.white
                                      : (controller.confirmPasswordController.text.isNotEmpty
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade50),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller.confirmPasswordErrors.value.isNotEmpty
                                        ? Colors.red
                                        : (controller.isConfirmPasswordFocused.value ||
                                        controller.confirmPasswordController.text.isNotEmpty)
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade300,
                                    width: controller.confirmPasswordErrors.value.isNotEmpty
                                        ? 1.5
                                        : (controller.isConfirmPasswordFocused.value ||
                                        controller.confirmPasswordController.text.isNotEmpty)
                                        ? 1.5
                                        : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.confirmPasswordController,
                                  focusNode: controller.confirmPasswordFocusNode,
                                  obscureText: !controller.isConfirmPasswordVisible.value,
                                  style: Styles.darkBlcW400,
                                  onChanged: (value) {
                                    controller.validateConfirmPassword(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Confirm new password',
                                    hintStyle: Styles.darkGryW40014,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: screenHeight * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      size: screenWidth * 0.05,
                                      color: controller.confirmPasswordErrors.value.isNotEmpty
                                          ? Colors.red
                                          : (controller.isConfirmPasswordFocused.value ||
                                          controller.confirmPasswordController.text.isNotEmpty)
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade500,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isConfirmPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: screenWidth * 0.05,
                                        color: controller.confirmPasswordErrors.value.isNotEmpty
                                            ? Colors.red
                                            : (controller.isConfirmPasswordFocused.value ||
                                            controller.confirmPasswordController.text.isNotEmpty)
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade500,
                                      ),
                                      onPressed: () => controller.toggleConfirmPasswordVisibility(),
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.confirmPasswordErrors.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4, left: 4),
                                  child: Text(
                                    controller.confirmPasswordErrors.value,
                                    style: const TextStyle(fontSize: 12, color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Reset Password Button
                        Obx(
                              () => Opacity(
                            opacity: controller.isFormValid.value ? 1.0 : 0.5,
                            child: GradientButton(
                              onPressed: controller.isFormValid.value &&
                                  !controller.isLoading.value
                                  ? () {
                                FocusScope.of(context).unfocus();
                                controller.changePassword();
                              }
                                  : () {},
                              text: 'Reset Password',
                              icon: SvgPicture.asset(
                                AssetConstants.icLoc,
                                height: screenWidth * 0.045,
                                width: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Back to Login
                        Center(
                          child: GestureDetector(
                            onTap: () => RouteManagement.goToLogin(),
                            child: RichText(
                              text: TextSpan(
                                style: Styles.darkBlackW700,
                                children: [
                                  const TextSpan(text: 'Back to '),
                                  TextSpan(
                                    text: 'Login',
                                    style: Styles.darkBlueW700,
                                  ),
                                ],
                              ),
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
          ],
        ),
      ),
    );
  }
}