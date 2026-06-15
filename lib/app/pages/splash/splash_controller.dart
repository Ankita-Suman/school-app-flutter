import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

// splash_controller.dart
class SplashController extends GetxController {
  bool _navigated = false;  // ✅ Add flag

  @override
  void onInit() {
    super.onInit();
    print("Splash Screen - Token: ");
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    // ✅ Prevent multiple navigation
    if (_navigated) return;

    try {
      var deviceRepository = Get.find<DeviceRepository>();
      String? token = await deviceRepository.getSecuredValue(DeviceConstants.token);

      print("Splash Screen - Token: ${token != null ? 'exists' : 'null'}");

      if (token != null && token.isNotEmpty) {
        _navigated = true;
        RouteManagement.goToHome();
      } else {
        _navigated = true;
        RouteManagement.goToLogin();
      }
    } catch (e) {
      _navigated = true;
      RouteManagement.goToLogin();
    }
  }
}