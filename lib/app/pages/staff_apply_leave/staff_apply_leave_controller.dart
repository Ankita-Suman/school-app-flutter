// controllers/staff_apply_leave_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
// ⚠️ सुनिश्चित करें कि आपका StaffApplyLeavePresenter यहाँ इम्पोर्ट हो
import 'staff_apply_leave_presenter.dart';

class StaffApplyLeaveController extends GetxController {
  // ✅ Presenter इंजेक्ट किया गया
  StaffApplyLeaveController(this.applyLeavePresenter);

  final StaffApplyLeavePresenter applyLeavePresenter;

  // Text Controllers
  final TextEditingController applyDateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // ========== LEAVE TYPE ==========
  var selectedLeaveType = ''.obs;
  var isLeaveTypeFocused = false.obs;

  final List<String> leaveTypes = [
    'Casual Leave (CL)',
    'Sick Leave (SL)',
    'Earned Leave (EL)',
    'Paid Leave (PL)',
  ];

  // Observable variables
  var applyDate = ''.obs;
  var fromDate = ''.obs;
  var toDate = ''.obs;
  var isLoading = false.obs;
  var isFormValid = false.obs;
  var dateRangeError = false.obs;

  // File Upload variables
  var selectedFile = Rxn<File>();
  var selectedFileName = ''.obs;
  var selectedFileSize = ''.obs;

  // Focus Nodes
  final FocusNode applyDateFocusNode = FocusNode();
  final FocusNode fromDateFocusNode = FocusNode();
  final FocusNode toDateFocusNode = FocusNode();
  final FocusNode reasonFocusNode = FocusNode();

  // Focus States
  var isApplyDateFocused = false.obs;
  var isFromDateFocused = false.obs;
  var isToDateFocused = false.obs;
  var isReasonFocused = false.obs;

  @override
  void onInit() {
    super.onInit();

    applyDateFocusNode.addListener(() {
      isApplyDateFocused.value = applyDateFocusNode.hasFocus;
    });

    fromDateFocusNode.addListener(() {
      isFromDateFocused.value = fromDateFocusNode.hasFocus;
    });

    toDateFocusNode.addListener(() {
      isToDateFocused.value = toDateFocusNode.hasFocus;
    });

    reasonFocusNode.addListener(() {
      isReasonFocused.value = reasonFocusNode.hasFocus;
    });

    applyDate.listen((_) => _validateForm());
    fromDate.listen((_) => _validateForm());
    toDate.listen((_) => _validateForm());
    reasonController.addListener(() => _validateForm());
    selectedFileName.listen((_) => _validateForm());
    selectedLeaveType.listen((_) => _validateForm());
  }

  void _validateForm() {
    bool allFieldsFilled = selectedLeaveType.value.isNotEmpty &&
        fromDate.value.isNotEmpty &&
        toDate.value.isNotEmpty &&
        reasonController.text.isNotEmpty;
    // नोट: अगर फाइल अनिवार्य है तो यहाँ selectedFileName.value.isNotEmpty भी जोड़ें

    bool noDateError = !dateRangeError.value;

    isFormValid.value = allFieldsFilled && noDateError;
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        selectedFile.value = file;
        selectedFileName.value = result.files.single.name;

        int sizeInBytes = result.files.single.size;
        String formattedSize = _formatFileSize(sizeInBytes);
        selectedFileSize.value = formattedSize;

        Get.snackbar(
          'File Selected',
          '${selectedFileName.value}\nSize: $formattedSize',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, onPrimary: Colors.white, onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      fromDate.value = formattedDate;
      fromDateController.text = formattedDate;
      if (toDate.value.isNotEmpty) validateDateRange();
      _validateForm();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, onPrimary: Colors.white, onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      toDate.value = formattedDate;
      toDateController.text = formattedDate;
      if (fromDate.value.isNotEmpty) validateDateRange();
      _validateForm();
    }
  }

  void validateDateRange() {
    if (fromDate.value.isNotEmpty && toDate.value.isNotEmpty) {
      List<String> fromParts = fromDate.value.split('/');
      List<String> toParts = toDate.value.split('/');

      DateTime fromDateTime = DateTime(
          int.parse(fromParts[2]), int.parse(fromParts[1]), int.parse(fromParts[0]));
      DateTime toDateTime = DateTime(
          int.parse(toParts[2]), int.parse(toParts[1]), int.parse(toParts[0]));

      if (toDateTime.isBefore(fromDateTime)) {
        dateRangeError.value = true;
        isFormValid.value = false;
        Get.snackbar('Invalid Date Range', 'To Date cannot be before From Date',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        toDate.value = '';
        toDateController.clear();
      } else {
        dateRangeError.value = false;
      }
    }
  }

  // ✅ API फॉर्मेट में तारीख (YYYY-MM-DD)
  String _formatDateForApi(String dateStr) {
    if (dateStr.isEmpty) return '';
    List<String> parts = dateStr.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return dateStr;
  }

  // ✅ UI स्ट्रिंग को बैकएंड ईनम में बदलें
  String _getApiLeaveType(String uiType) {
    if (uiType.contains('Casual')) return 'CASUAL';
    if (uiType.contains('Sick')) return 'SICK';
    if (uiType.contains('Earned')) return 'EARNED';
    if (uiType.contains('Paid')) return 'PAID';
    return 'CASUAL'; // Default
  }

  // ✅ असली API कॉल जोड़ा गया
  Future<void> submitLeave(BuildContext context) async {
    if (!isFormValid.value) {
      Get.snackbar('Error', 'Please fill all required fields.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      String apiLeaveType = _getApiLeaveType(selectedLeaveType.value);
      String apiFromDate = _formatDateForApi(fromDate.value);
      String apiToDate = _formatDateForApi(toDate.value);

      debugPrint("════════════════════════════════════════════════");
      debugPrint("🚀 STAFF APPLY LEAVE API HIT 🚀");
      debugPrint("📄 Leave Type: $apiLeaveType");
      debugPrint("📅 From: $apiFromDate | To: $apiToDate");
      debugPrint("════════════════════════════════════════════════");

      // ⚠️ सुनिश्चित करें कि आपके StaffApplyLeavePresenter में यह मेथड हो
      var res = await applyLeavePresenter.submitStaffLeaveApplication(
        isLoading: false,
        token: token,
        branchId: branchId,
        leaveType: apiLeaveType,
        fromDate: apiFromDate,
        toDate: apiToDate,
        reason: reasonController.text,
        attachment: selectedFile.value,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', 'Leave request submitted successfully!',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);

        // Form साफ करें
        selectedLeaveType.value = '';
        fromDate.value = '';
        toDate.value = '';
        fromDateController.clear();
        toDateController.clear();
        reasonController.clear();
        selectedFile.value = null;
        selectedFileName.value = '';

        // वापस जाएं
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context);
      } else {
        Get.snackbar('Error', res?.message ?? 'Failed to submit request.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ STAFF APPLY LEAVE API ERROR: $e");
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    applyDateController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    applyDateFocusNode.dispose();
    fromDateFocusNode.dispose();
    toDateFocusNode.dispose();
    reasonFocusNode.dispose();
    super.onClose();
  }
}