import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/my_classmates_response.dart';
import 'my_classmates_presenter.dart';

class MyClassmatesController extends GetxController {
  MyClassmatesController(this.presenter);

  final MyClassmatesPresenter presenter;

  // Loading & Data State
  var isLoading = false.obs;

  // ✅ Classmate की लिस्ट
  var classmatesList = <Classmate>[].obs;

  // Dynamic Variables
  var token = ''.obs;
  var branchId = ''.obs;
  var studentId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserDataAndFetchClassmates();
  }

  Future<void> _getUserDataAndFetchClassmates() async {
    try {
      isLoading.value = true;
      var deviceRepo = Get.find<DeviceRepository>();

      // 1. Token और Branch ID निकालें
      token.value = await deviceRepo.getSecuredValue(DeviceConstants.token);
      branchId.value = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      // 2. पहले SharedPreferences से studentId चेक करें (Student Login या Parent द्वारा स्विच किया गया)
      String storedId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (storedId.isNotEmpty && storedId != 'null') {
        studentId.value = storedId;
      } else {
        // 3. अगर SharedPreferences खाली है (जैसे Parent के पहली बार लॉगिन पर), तो LoginResponse से निकालें
        String loginResponseStr = await deviceRepo.getSecuredValue(DeviceConstants.loginResponse);
        if (loginResponseStr.isNotEmpty) {
          final Map<String, dynamic> jsonMap = jsonDecode(loginResponseStr);
          final data = jsonMap['data'] ?? jsonMap;

          // 'auth' के अंदर default_student_id चेक करें
          final auth = data['auth'];
          if (auth != null && auth['default_student_id'] != null) {
            studentId.value = auth['default_student_id'].toString();

            // ✅ इसे SharedPreferences में भी सेव कर दें ताकि आगे काम आए
            await deviceRepo.saveValueSecurely(DeviceConstants.studentId, studentId.value);
          } else {
            // Fallback: 'user' के अंदर student_id या children चेक करें
            final user = data['user'] ?? data;
            final directId = user['student_id']?.toString() ?? '';
            if (directId.isNotEmpty && directId != 'null') {
              studentId.value = directId;
            } else {
              final children = user['children'];
              if (children is List && children.isNotEmpty) {
                studentId.value = children.first['id']?.toString() ?? '';
              }
            }
          }
        }
      }

      // 4. सुरक्षा जाँच: अगर डेटा मिसिंग है तो एरर दिखाएं
      if (token.value.isEmpty || branchId.value.isEmpty || studentId.value.isEmpty) {
        isLoading.value = false;
        Get.snackbar('Error', 'User data missing. Please login again.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      await fetchClassmates();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load session data.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchClassmates() async {
    if (token.value.isEmpty) return;

    try {
      isLoading.value = true;

      // Presenter के माध्यम से API कॉल
      var res = await presenter.getClassmatesAPI(
        isLoading: false,
        token: token.value,
        branchId: branchId.value,
        studentId: studentId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        classmatesList.value = res.data!.classmates ?? [];
      } else {
        classmatesList.clear();
        Get.snackbar('Info', res?.message ?? 'No classmates found.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      classmatesList.clear();
      Get.snackbar('Error', 'Something went wrong while fetching classmates.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}