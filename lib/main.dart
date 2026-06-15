import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_app/domain/usecases/home_usecases.dart';
import 'app/app.dart';
import 'app/pages/dashboard/dashboard_presenter.dart';
import 'app/pages/login/login_presenter.dart';
import 'data/helpers/connect_helper.dart';
import 'data/repositories/data_repositories.dart';
import 'device/repositories/device_repositories.dart';
import 'domain/repositories/repository.dart';
import 'domain/usecases/auth_use_cases.dart';
import 'domain/usecases/login_usecases.dart';

late String? deviceToken;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    await Hive.initFlutter();
    await initServices();
    await GetStorage.init();

    runApp(const MyApp());
  } catch (error) {
    Utility.printELog(error.toString());
  }
}

Future<void> initServices() async {
  // Register DeviceRepository first
  Get.put(DeviceRepository(), permanent: true);

  Get.put(
    AuthUseCases(
      Get.put(
        Repository(
          Get.find<DeviceRepository>(),  // ✅ Use existing, don't create new
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
  // ✅ Register all UseCases and Presenters
  final repository = Get.find<Repository>();

  // ✅ Safe registration - Check if already exists
  if (!Get.isRegistered<HomeUseCases>()) {
    Get.put(HomeUseCases(repository), permanent: true);
  }

  if (!Get.isRegistered<LoginUseCases>()) {
    Get.put(LoginUseCases(repository), permanent: true);
  }

  if (!Get.isRegistered<LoginPresenter>()) {
    Get.put(LoginPresenter(Get.find<LoginUseCases>()), permanent: true);
  }

  if (!Get.isRegistered<DashboardPresenter>()) {
    Get.put(DashboardPresenter(Get.find<HomeUseCases>()), permanent: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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