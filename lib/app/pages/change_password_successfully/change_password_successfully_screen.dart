// screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import 'change_password_successfully_controller.dart';

class ChangePasswordSuccessfullyScreen extends StatelessWidget {
  const ChangePasswordSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePasswordSuccessfullyController controller = Get.put(ChangePasswordSuccessfullyController());

    return Scaffold(
      body: Stack(
        children: [
          // SVG Background
          Image.asset(
            AssetConstants.icPassBG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Success Icon
                    Obx(
                          () => AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        transform: Matrix4.identity()..scale(controller.scaleValue),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AssetConstants.icTik,
                              height: 50,
                              width: 50,
                              colorFilter: const ColorFilter.mode(
                                Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Success Text with Fade Animation
                    Obx(
                          () => AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: controller.opacityValue,
                        child: Column(
                          children: [
                            Text(
                              'Password Changed!',
                              style: Styles.whiteExBold26,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your password has been updated successfully.\nYou can now sign in with your new password.',
                              style: Styles.whiteW40013,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Back to Home Button with Animation
                    Obx(
                          () => AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: controller.opacityValue,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.goToHome();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:  Text(
                              'Back to Home',
                              style:Styles.whiteW70015
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}