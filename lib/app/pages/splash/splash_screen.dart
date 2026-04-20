import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetConstants.splash),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        );
      },
    );
  }
}
