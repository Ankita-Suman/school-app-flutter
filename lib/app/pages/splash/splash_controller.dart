import 'package:school_app/app/app.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
     navigate();
  }
  void navigate() {
    Future.delayed(const Duration(seconds:8)).then((val) {
      RouteManagement.goToChooseOptions();
    });
  }
}
