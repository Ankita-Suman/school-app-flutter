
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AddLeaveController extends GetxController {
  // Text Controllers
  final TextEditingController applyDateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

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

    // Add focus listeners
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

    // Form validation listeners
    applyDate.listen((_) => _validateForm());
    fromDate.listen((_) => _validateForm());
    toDate.listen((_) => _validateForm());
    reasonController.addListener(() => _validateForm());
    selectedFileName.listen((_) => _validateForm());
  }

  void _validateForm() {
    bool allFieldsFilled = applyDate.value.isNotEmpty &&
        fromDate.value.isNotEmpty &&
        toDate.value.isNotEmpty &&
        reasonController.text.isNotEmpty &&
        selectedFileName.value.isNotEmpty;

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
      print("Error picking file: $e");
      Get.snackbar(
        'Error',
        'Failed to pick file. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> selectApplyDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      applyDate.value = formattedDate;
      applyDateController.text = formattedDate;
    }
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
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      fromDate.value = formattedDate;
      fromDateController.text = formattedDate;
      if (toDate.value.isNotEmpty) {
        validateDateRange();
      }
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
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      toDate.value = formattedDate;
      toDateController.text = formattedDate;
      if (fromDate.value.isNotEmpty) {
        validateDateRange();
      }
      _validateForm();
    }
  }

  void validateDateRange() {
    if (fromDate.value.isNotEmpty && toDate.value.isNotEmpty) {
      List<String> fromParts = fromDate.value.split('/');
      List<String> toParts = toDate.value.split('/');

      DateTime fromDateTime = DateTime(
        int.parse(fromParts[2]),
        int.parse(fromParts[1]),
        int.parse(fromParts[0]),
      );
      DateTime toDateTime = DateTime(
        int.parse(toParts[2]),
        int.parse(toParts[1]),
        int.parse(toParts[0]),
      );

      if (toDateTime.isBefore(fromDateTime)) {
        dateRangeError.value = true;
        isFormValid.value = false;
        Get.snackbar(
          'Invalid Date Range',
          'To Date cannot be before From Date',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        toDate.value = '';
        toDateController.clear();
      } else {
        dateRangeError.value = false;
      }
    }
  }

  // ✅ Fixed Submit Leave
  void submitLeave(BuildContext context) {
    if (!isFormValid.value) {
      if (applyDate.value.isEmpty) {
        _showErrorSnackbar('Please select Apply Date');
      } else if (fromDate.value.isEmpty) {
        _showErrorSnackbar('Please select From Date');
      } else if (toDate.value.isEmpty) {
        _showErrorSnackbar('Please select To Date');
      } else if (reasonController.text.isEmpty) {
        _showErrorSnackbar('Please enter reason for leave');
      } else if (selectedFileName.value.isEmpty) {
        _showErrorSnackbar('Please upload a file');
      }
      return;
    }

    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      // Clear form
      applyDate.value = '';
      fromDate.value = '';
      toDate.value = '';
      dateRangeError.value = false;
      selectedFile.value = null;
      selectedFileName.value = '';
      selectedFileSize.value = '';
      reasonController.clear();

      // ✅ Navigate back FIRST
      Navigator.pop(context);

      // ✅ Then show success snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Success',
          'Leave applied successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      });
    });
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
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