import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

class SplashController extends GetxController {
  bool _navigated = false;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_navigated) return;

    try {
      var deviceRepository = Get.find<DeviceRepository>();

      String? token = await deviceRepository.getSecuredValue(DeviceConstants.token);
      print("🔍 Splash token: $token");

      // ✅ सिर्फ यह चेक करें कि टोकन मौजूद है या नहीं।
      // लोकल एक्सपायरी चेक हटा दिया गया है।
      if (token.isNotEmpty) {
        _navigated = true;

        String? role = await deviceRepository.getSecuredValue(DeviceConstants.userRole);
        print("🔍 Splash stored role: $role");

        String roleLower = (role ?? '').toLowerCase();

        if (roleLower == 'student') {
          RouteManagement.goToHome();
        } else if (roleLower == 'staff' || roleLower == 'teacher') {
          RouteManagement.goToTeacherDashboard();
        } else if (roleLower == 'parent') {
          RouteManagement.goToParentDashboard();
        } else {
          RouteManagement.goToVerifyBranchCode();
        }
      } else {
        _navigated = true;
        RouteManagement.goToVerifyBranchCode();
      }
    } catch (e) {
      print("❌ Splash error: $e");
      _navigated = true;
      RouteManagement.goToVerifyBranchCode();
    }
  }
}