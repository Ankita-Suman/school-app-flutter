import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'data/helpers/connect_helper.dart';
import 'data/repositories/data_repositories.dart';
import 'device/repositories/device_repositories.dart';
import 'domain/repositories/repository.dart';
import 'domain/usecases/auth_use_cases.dart';

late String? deviceToken;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // ✅ FULL SCREEN MODE - Hides navigation bar completely
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // Empty list = no navigation bar, no status bar
    );

    // ✅ Set status bar and navigation bar styles
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    await Hive.initFlutter();
    await initServices();
    await GetStorage.init();

    Get.put(DeviceRepository());

    runApp(const MyApp());
  } catch (error) {
    Utility.printELog(error.toString());
  }
}

Future<void> initServices() async {
  Get.put(
    AuthUseCases(
      Get.put(
        Repository(
          Get.put(
            DeviceRepository(),
            permanent: true,
          ),
          Get.put(
            DataRepository(
              Get.put(
                ConnectHelper(),
                permanent: true,
              ),
            ),
            permanent: true,
          ),
        ),
        permanent: true,
      ),
    ),
    permanent: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => GetMaterialApp(
        title: 'School App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        supportedLocales: TranslationsFile.listOfLocales,
        locale: const Locale('en'),
        getPages: AppPages.pages,
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.white,
        ),
        initialRoute: AppPages.initial,
        translations: TranslationsFile(),
      ),
    );
  }
}