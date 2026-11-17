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
            // Background
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // ========== TOP SECTION: LOGO + SCHOOL INFO (With Loader) ==========
            Positioned(
              top: screenHeight * 0.09,
              left: 0,
              right: 0,
              child: Obx(() {
                final logoUrl = controller.savedLogoUrl.value;
                final info = controller.branchInfoData.value;
               // final schoolName = info?.data?.schoolName ?? '';
                final branchName = info?.data?.branchName ?? '';

                return _SchoolHeader(
                  key: ValueKey('$logoUrl|$branchName'),
                  logoUrl: logoUrl,
                //  schoolName: schoolName,
                  branchName: branchName,
                );
              }),
            ),

            // ========== BOTTOM CARD: LOGIN FORM ==========
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
                          SizedBox(height: screenHeight * 0.02),

                          const TabBarWidget(),
                          SizedBox(height: screenHeight * 0.02),

                          // Username / Email field
                          _buildEmailField(
                              controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.015),

                          // Password field
                          _buildPasswordField(
                              controller, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.02),

                          // Sign in button
                          _buildSignInButton(
                              controller, screenWidth, screenHeight),
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

  // ============================================================
  // ✅ USERNAME / EMAIL FIELD
  // ============================================================
  Widget _buildEmailField(
      LoginController controller, double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.emailError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('USERNAME / EMAIL', style: Styles.darkGryW700),
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
                    controller.emailController?.text.isNotEmpty ==
                        true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: hasError
                    ? 1.5
                    : (controller.isEmailFocused.value ||
                    controller.emailController?.text.isNotEmpty ==
                        true)
                    ? 1.5
                    : 1,
              ),
            ),
            child: TextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: Styles.darkBlcW400,
              onChanged: (value) => controller.validateEmail(value),
              onSubmitted: (value) => FocusScope.of(Get.context!)
                  .requestFocus(controller.passwordFocusNode),
              decoration: InputDecoration(
                hintText: 'Enter username or email',
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015),
                prefixIcon: Icon(
                  Icons.person_outline,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (controller.isEmailFocused.value ||
                      controller.emailController?.text.isNotEmpty ==
                          true)
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

  // ============================================================
  // ✅ PASSWORD FIELD
  // ============================================================
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
                    controller.passwordController?.text.isNotEmpty ==
                        true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: hasError
                    ? 1.5
                    : (controller.isPasswordFocused.value ||
                    controller.passwordController?.text.isNotEmpty ==
                        true)
                    ? 1.5
                    : 1,
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
                      controller.passwordController?.text.isNotEmpty ==
                          true)
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
                        controller.passwordController?.text
                            .isNotEmpty ==
                            true)
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

  // ============================================================
  // ✅ SIGN IN BUTTON
  // ============================================================
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
        icon:
        Icon(Icons.login, size: screenWidth * 0.05, color: Colors.white),
      ),
    ));
  }

  // ============================================================
  // ✅ FORGOT PASSWORD
  // ============================================================
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

// ============================================================
// ✅ SCHOOL HEADER WIDGET (Logo + Name + Branch + Loader)
// ============================================================
class _SchoolHeader extends StatefulWidget {
  final String logoUrl;
  //final String schoolName;
  final String branchName;

  const _SchoolHeader({
    super.key,
    required this.logoUrl,
   // required this.schoolName,
    required this.branchName,
  });

  @override
  State<_SchoolHeader> createState() => _SchoolHeaderState();
}

class _SchoolHeaderState extends State<_SchoolHeader> {
  bool _imageReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadLogo();
    });
  }

  /// Image ko cache me preload karo taaki display ke time delay na ho
  Future<void> _preloadLogo() async {
    // Agar logoUrl empty hai to seedha ready ho jao (asset logo turant load hoga)
    if (widget.logoUrl.isEmpty) {
      if (mounted) setState(() => _imageReady = true);
      return;
    }

    try {
      await precacheImage(
        NetworkImage(widget.logoUrl),
        context,
      );
    } catch (e) {
      debugPrint("⚠️ Logo precache failed: $e");
    }

    if (mounted) setState(() => _imageReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ Jab tak logo aur data load na ho jaye, loader dikhao
    if (!_imageReady) {
      return SizedBox(
        height: screenWidth * 0.28 + 60,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ========== LOGO ==========
        if (widget.logoUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.logoUrl,
              height: screenWidth * 0.28,
              width: screenWidth * 0.28,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                AssetConstants.iclogo,
                height: screenWidth * 0.28,
                width: screenWidth * 0.28,
                fit: BoxFit.contain,
              ),
            ),
          )
        else
          Image.asset(
            AssetConstants.iclogo,
            height: screenWidth * 0.28,
            width: screenWidth * 0.28,
            fit: BoxFit.contain,
          ),

        const SizedBox(height: 10),

        // ========== SCHOOL NAME ==========
        // if (widget.schoolName.isNotEmpty)
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        //     child: Text(
        //       widget.schoolName,
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white,
        //         fontFamily: GoogleFonts.sora().fontFamily,
        //         shadows: [
        //           Shadow(
        //             color: Colors.black.withOpacity(0.25),
        //             offset: const Offset(0, 1),
        //             blurRadius: 3,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),

        // ========== BRANCH NAME ==========
        if (widget.branchName.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            widget.branchName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.9),
              fontFamily: GoogleFonts.sora().fontFamily,
            ),
          ),
        ],
      ],
    );
  }
}