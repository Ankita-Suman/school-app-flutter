import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import 'apply_leave_presenter.dart';

class ApplyLeaveController extends GetxController {
  ApplyLeaveController(this.applyLeavePresenter);

  final ApplyLeavePresenter applyLeavePresenter;

  var isLoading = false.obs;
  var isSubmitting = false.obs;

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final reasonController = TextEditingController();

  var fromDateDisplay = ''.obs;
  var toDateDisplay = ''.obs;

  var selectedLeaveType = 'CASUAL'.obs;

  final List<Map<String, String>> leaveTypes = [
    {'value': 'CASUAL', 'label': 'Casual Leave (CL)'},
    {'value': 'SICK', 'label': 'Sick Leave (SL)'},
    {'value': 'EARNED', 'label': 'Earned Leave (EL)'},
  ];

  var selectedFile = Rxn<File>();
  var fileName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    fromDateController.text = _formatDate(now);
    toDateController.text = _formatDate(now);
    fromDateDisplay.value = _formatDisplayDate(now);
    toDateDisplay.value = _formatDisplayDate(now);
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _formatDisplayDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  void setFromDate(DateTime date) {
    fromDateController.text = _formatDate(date);
    fromDateDisplay.value = _formatDisplayDate(date);
  }

  void setToDate(DateTime date) {
    toDateController.text = _formatDate(date);
    toDateDisplay.value = _formatDisplayDate(date);
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );
      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        fileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void removeFile() {
    selectedFile.value = null;
    fileName.value = '';
  }

  Future<void> submitLeaveApplication({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    if (leaveType.isEmpty || fromDate.isEmpty || toDate.isEmpty || reason.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isSubmitting.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var res = await applyLeavePresenter.submitLeaveApplication(
        isLoading: false,
        token: token,
        branchId: branchId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachment: selectedFile.value,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', 'Leave application submitted successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        clearForm();
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(closeOverlays: true);
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to submit leave application.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    fromDateController.clear();
    toDateController.clear();
    reasonController.clear();
    selectedLeaveType.value = 'CASUAL';
    removeFile();
    final now = DateTime.now();
    fromDateDisplay.value = _formatDisplayDate(now);
    toDateDisplay.value = _formatDisplayDate(now);
  }

  @override
  void onClose() {
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}