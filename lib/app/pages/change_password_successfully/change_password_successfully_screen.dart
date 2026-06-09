// screens/change_password_successfully_screen.dart
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

    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;

    return Scaffold(
      body: Stack(
        children: [
          // Responsive Background
          Image.asset(
            AssetConstants.icPassBG,
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),

          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon - Responsive size
                    Center(
                      child: SvgPicture.asset(
                        AssetConstants.icAni,
                        width: isTablet ? 200 : (isSmallPhone ? 120 : 150),
                        height: isTablet ? 200 : (isSmallPhone ? 120 : 150),
                      ),
                    ),

                    SizedBox(height: isTablet ? 50 : 40),

                    // Success Text (No Animation)
                    Column(
                      children: [
                        Text(
                          'Password Changed!',
                          style: Styles.whiteExBold26,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        Text(
                          'Your password has been updated successfully.\nYou can now sign in with your new password.',
                          style: Styles.whiteW40013,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 80 : 60),

                    // Back to Home Button - Responsive
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          RouteManagement.goToLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 20 : 16,
                            horizontal: isTablet ? 32 : 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Back to Login',
                          style: Styles.whiteW70015,
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