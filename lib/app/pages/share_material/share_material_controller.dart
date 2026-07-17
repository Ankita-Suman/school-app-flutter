// share_material_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class ShareMaterialController extends GetxController {
  // Text Controllers
  final TextEditingController classController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Focus Nodes
  final FocusNode classFocusNode = FocusNode();
  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  // Observable
  var selectedFileName = ''.obs;
  var selectedFile = Rxn<File>();

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'pptx', 'mp4'],
      );

      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        selectedFileName.value = result.files.single.name;
        Get.snackbar(
          'File Selected',
          selectedFileName.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void shareMaterial() {
    if (classController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter Class');
      return;
    }
    if (subjectController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter Subject');
      return;
    }
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter Material Title');
      return;
    }
    if (selectedFileName.value.isEmpty) {
      Get.snackbar('Error', 'Please upload a file');
      return;
    }

    Get.snackbar(
      'Success',
      'Material shared successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    classController.dispose();
    subjectController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    classFocusNode.dispose();
    subjectFocusNode.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.onClose();
  }
}