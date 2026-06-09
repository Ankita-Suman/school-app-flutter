import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    print("Splash Screen - Token: ");
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      var deviceRepository = Get.find<DeviceRepository>();

      // Check if token exists
      String? token = await deviceRepository.getSecuredValue(DeviceConstants.token);

      print("Splash Screen - Token: ${token != null ? 'exists' : 'null'}");

      // If token exists and is not empty, user is logged in
      if (token != null && token.isNotEmpty) {
        RouteManagement.goToHome();
      } else {
        RouteManagement.goToLogin();
      }
    } catch (e) {
      // If error occurs, navigate to login screen
     RouteManagement.goToLogin();
    }
  }
}