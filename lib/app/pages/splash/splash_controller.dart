import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late final AnimationController slideAnimationController;
  late final Animation<double> slideAnimation;
  bool expand = false;

  @override
  void onInit() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);
    Future<dynamic>.delayed(const Duration(seconds: 1)).then((dynamic value) {
      animationController.forward();
    });
    slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    slideAnimation =
        CurvedAnimation(parent: slideAnimationController, curve: Curves.linear);
    Future<dynamic>.delayed(Duration.zero).then((dynamic value) {
      navigate();
    });
    super.onInit();
  }

  /// method to navigate AuthScreen or direct to HomeView.
  void navigate() async {
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideAnimationController.forward();
        Future<dynamic>.delayed(const Duration(seconds: 3))
            .then((dynamic value) {
          RouteManagement.goToChooseOptions();
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
