import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/document_response.dart';
import 'student_documents_presenter.dart'; // ✅ अपना सही पाथ डालें

class StudentDocumentsController extends GetxController {
StudentDocumentsController(this.presenter);


final StudentDocumentsPresenter presenter;

  // Loading & Data State
  var isLoading = false.obs;
  var documentsList = <DocumentItem>[].obs;

  // Dynamic Variables
  var token = ''.obs;
  var branchId = ''.obs;
  var studentId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserDataAndFetchDocuments();
  }

  Future<void> _getUserDataAndFetchDocuments() async {
    try {
      isLoading.value = true;
      var deviceRepo = Get.find<DeviceRepository>();

      // SharedPreferences से डेटा निकालें
      token.value = await deviceRepo.getSecuredValue(DeviceConstants.token);
      branchId.value = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      // ⚠️ यहाँ DeviceConstants.studentId इस्तेमाल करें (जैसा आपके प्रोजेक्ट में हो)
      studentId.value = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (token.value.isEmpty || branchId.value.isEmpty || studentId.value.isEmpty) {
        isLoading.value = false;
        Get.snackbar('Error', 'User data missing. Please login again.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      await fetchDocuments();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load session data.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchDocuments() async {
    if (token.value.isEmpty) return;

    try {
      isLoading.value = true;

      var res = await presenter.getStudentDocumentsAPI(
        isLoading: false,
        token: token.value,
        branchId: branchId.value,
        studentId: studentId.value,
      );

      if (res != null && res.status == true && res.data != null) {
        documentsList.value = res.data!;
      } else {
        documentsList.clear();
        Get.snackbar('Info', res?.message ?? 'No documents found.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      documentsList.clear();
      Get.snackbar('Error', 'Something went wrong while fetching documents.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}