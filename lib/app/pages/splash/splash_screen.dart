import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<SplashController>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<SplashController>(
            builder: (controller) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetConstants.appLogo,
                      width: Dimens.threeHundred,
                      height: Dimens.twoHundredFifty,
                      fit: BoxFit.cover),
                  Image.asset(AssetConstants.imgSchool,
                      width: Dimens.threeHundred,
                      height: Dimens.hundredFifty,
                      fit: BoxFit.cover)
                ],
              ),
            ),
          ),
        ),
      );
}
