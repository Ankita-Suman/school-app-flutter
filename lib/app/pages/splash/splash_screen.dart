// splash_screen.dart - Super slow smooth animation

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000), // 4 seconds total
      vsync: this,
    );

    // ✅ Super smooth, very slow growth
    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn, // Very smooth curve
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        RouteManagement.goToLogin();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  AssetConstants.iclogo,
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}