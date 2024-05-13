import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';

late String? deviceToken;

/// Main function to initialize the app
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await GetStorage.init('appData');
    runApp(const MyApp());
  } catch (error) {
    Utility.printELog(error.toString());
  }
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? timer;

  Locale? locale;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ColorsValue.transparent,
        systemNavigationBarColor: Colors.black,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    super.initState();
  }

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
        locale: locale ?? const Locale('en'),
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




