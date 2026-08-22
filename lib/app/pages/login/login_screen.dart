// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/app/app.dart';
import '../../widgets/gradient_button.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final LoginController controller =
    Get.put(LoginController(Get.find()), permanent: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Logo
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.06),
                child: Image.asset(
                  AssetConstants.iclogo,
                  height: screenWidth * 0.32,
                  width: screenWidth * 0.32,
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
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.025),

                          // ========== SCHOOL INFO (only shown when data exists) ==========
                          Obx(() {
                            final schoolData = controller.schoolInfoData.value;
                            if (schoolData == null) {
                              return const SizedBox.shrink();
                            }
                            final schoolName = schoolData.data?.schoolName ?? 'School Name';
                            final branchName = schoolData.data?.branchName ?? 'Branch Name';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.school, size: 18, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      schoolName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: GoogleFonts.sora().fontFamily,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 1,
                                    height: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Branch: $branchName',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: GoogleFonts.sora().fontFamily,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Welcome text
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Welcome Back 👋',
                                style: Styles.darkBlcW70020),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                                'Sign in to continue your learning journey',
                                style: Styles.darkGry400),
                          ),
                          SizedBox(height: screenHeight * 0.015),

                          const TabBarWidget(),
                          SizedBox(height: screenHeight * 0.015),

                          // Branch code field
                          _buildBranchCodeField(controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.015),

                          // Email field
                          _buildEmailField(controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.015),

                          // Password field
                          _buildPasswordField(controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.02),

                          // Sign in button
                          _buildSignInButton(controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.01),

                          // Forgot password
                          _buildForgotPasswordButton(controller),
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

  // ---- Field builders (unchanged) ----
  Widget _buildBranchCodeField(
      LoginController controller, double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.branchCodeError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BRANCH CODE', style: Styles.darkGryW700),
          SizedBox(height: screenHeight * 0.008),
          Container(
            decoration: BoxDecoration(
              color: controller.isBranchCodeFocused.value
                  ? Colors.white
                  : (controller.branchCodeController?.text.isNotEmpty == true
                  ? Colors.blue.shade50
                  : Colors.grey.shade50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (controller.isBranchCodeFocused.value ||
                    controller.branchCodeController?.text.isNotEmpty ==
                        true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: hasError
                    ? 1.5
                    : (controller.isBranchCodeFocused.value ||
                    controller.branchCodeController?.text.isNotEmpty ==
                        true)
                    ? 1.5
                    : 1,
              ),
            ),
            child: TextField(
              controller: controller.branchCodeController,
              focusNode: controller.branchCodeFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: Styles.darkBlcW400,
              onChanged: (value) => controller.validateBranchCode(value),
              onSubmitted: (value) => FocusScope.of(Get.context!)
                  .requestFocus(controller.emailFocusNode),
              decoration: InputDecoration(
                hintText: 'ASDF34UYGHS',
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015),
                prefixIcon: Icon(
                  Icons.lock,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (controller.isBranchCodeFocused.value ||
                      controller.branchCodeController?.text.isNotEmpty ==
                          true)
                      ? Colors.blue.shade700
                      : Colors.grey.shade500,
                ),
                // ✅ Loader shown while fetching school info
                suffixIcon: controller.isLoading.value
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue.shade700,
                    ),
                  ),
                )
                    : null,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Text(
                controller.branchCodeError.value,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildEmailField(
      LoginController controller, double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.emailError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MOBILE / EMAIL', style: Styles.darkGryW700),
          SizedBox(height: screenHeight * 0.008),
          Container(
            decoration: BoxDecoration(
              color: controller.isEmailFocused.value
                  ? Colors.white
                  : (controller.emailController?.text.isNotEmpty == true
                  ? Colors.blue.shade50
                  : Colors.grey.shade50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (controller.isEmailFocused.value ||
                    controller.emailController?.text.isNotEmpty == true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: hasError ? 1.5 : (controller.isEmailFocused.value ||
                    controller.emailController?.text.isNotEmpty == true
                    ? 1.5
                    : 1),
              ),
            ),
            child: TextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: Styles.darkBlcW400,
              onChanged: (value) => controller.validateEmail(value),
              onSubmitted: (value) => FocusScope.of(Get.context!)
                  .requestFocus(controller.passwordFocusNode),
              decoration: InputDecoration(
                hintText: 'olivier.thomas@edu.in',
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (controller.isEmailFocused.value ||
                      controller.emailController?.text.isNotEmpty == true)
                      ? Colors.blue.shade700
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Text(
                controller.emailError.value,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPasswordField(
      LoginController controller, double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.passwordError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PASSWORD', style: Styles.darkGryW700),
          SizedBox(height: screenHeight * 0.008),
          Container(
            decoration: BoxDecoration(
              color: controller.isPasswordFocused.value
                  ? Colors.white
                  : (controller.passwordController?.text.isNotEmpty == true
                  ? Colors.blue.shade50
                  : Colors.grey.shade50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (controller.isPasswordFocused.value ||
                    controller.passwordController?.text.isNotEmpty == true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: hasError ? 1.5 : (controller.isPasswordFocused.value ||
                    controller.passwordController?.text.isNotEmpty == true
                    ? 1.5
                    : 1),
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
                    vertical: screenHeight * 0.015),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (controller.isPasswordFocused.value ||
                      controller.passwordController?.text.isNotEmpty == true)
                      ? Colors.blue.shade700
                      : Colors.grey.shade500,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: screenWidth * 0.05,
                    color: hasError
                        ? Colors.red
                        : (controller.isPasswordFocused.value ||
                        controller.passwordController?.text.isNotEmpty == true)
                        ? Colors.blue.shade700
                        : Colors.grey.shade500,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Text(
                controller.passwordError.value,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSignInButton(
      LoginController controller, double screenWidth, double screenHeight) {
    return Obx(() => Opacity(
      opacity: controller.isFormValid.value ? 1.0 : 0.5,
      child: GradientButton(
        onPressed: controller.isFormValid.value
            ? () {
          FocusScope.of(Get.context!).unfocus();
          controller.loginWithValidation();
        }
            : () {},
        text: 'Sign In',
        icon: Icon(Icons.login, size: screenWidth * 0.05, color: Colors.white),
      ),
    ));
  }

  Widget _buildForgotPasswordButton(LoginController controller) {
    return Obx(() {
      final bool isParent = controller.selectedTab.value == 1;
      return Center(
        child: GestureDetector(
          onTap: () {
            if (isParent) {
              controller.showComingSoonDialog();
            } else {
              RouteManagement.goToNewForgotPassword();
            }
          },
          child: Text('Forgot Password?', style: Styles.darkBlueW50012),
        ),
      );
    });
  }
}