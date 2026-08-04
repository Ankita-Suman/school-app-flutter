// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/my_classes_response.dart';
import 'my_classes_presenter.dart';

class MyClassesController extends GetxController {
  MyClassesController(this.myClassesPresenter);

  final MyClassesPresenter myClassesPresenter;

  var isLoading = false.obs;
  var teacherClassData = Rxn<TeacherClassesResponse>();

  @override
  void onInit() {
    super.onInit();
    getMyClassData();
  }

  Future<void> getMyClassData() async {
    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var res = await myClassesPresenter.getMyClassData(
        isLoading: true,
        token: token, // ✅ dynamic
        branchId: branchId, // ✅ dynamic
      );

      if (res != null && res.status == true && res.data != null) {
        teacherClassData.value = res;
        if (res.data!.classes != null) {
          for (var classItem in res.data!.classes!) {
            debugPrint("  - ${classItem.className} ${classItem.sectionName}");
          }
        }
      } else {
        Get.snackbar(
          'Error',
          res?.message ?? 'Failed to load classes.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while loading classes.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTER METHODS FOR UI ==========

  List<ClassItem>? get classList => teacherClassData.value?.data?.classes;

  int get totalClasses => teacherClassData.value?.data?.totalClasses ?? 0;

  bool get hasData => classList != null && classList!.isNotEmpty;

  bool get isLoadingData => isLoading.value;

  // Get class by index with null safety
  ClassItem? getClassAtIndex(int index) {
    if (classList != null && index < classList!.length) {
      return classList![index];
    }
    return null;
  }
}