import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<SplashController>(
            builder: (controller) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimens.threeHundred,
                    height: Dimens.twoHundredFifty,
                    child: const Image(
                      image: AssetImage(AssetConstants.appLogo),
                    ),
                  ),
                  SizedBox(
                    width: Dimens.threeHundred,
                    height: Dimens.hundredFifty,
                    child: const Image(
                      image: AssetImage(AssetConstants.imgSchool),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
}
