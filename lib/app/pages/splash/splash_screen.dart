import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          // backgroundColor: Colors.white,
          body: GetBuilder<SplashController>(
            builder: (controller) =>
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  height: MediaQuery.of(context).size.height,
                  width: Dimens.twoHundredFifty,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AssetConstants.splash,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ),
      );
}
