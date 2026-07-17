// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/my_classes_response.dart';
import 'my_student_class_presenter.dart';

class MyStudentClassController extends GetxController {
  MyStudentClassController(this.myClassesPresenter);

  final MyStudentClassPresenter myClassesPresenter;

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
      print("📡📡📡 getMyClassData START - API HIT WITH LOADER 📡📡📡");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODM5Njc5OTYsImV4cCI6MTc4NDE0MDc5NiwibmJmIjoxNzgzOTY3OTk2LCJqdGkiOiJDNUE4YW1Gb0FqOTFEa0JCIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.vr39Y0QMHVdAC0gc0B3B3K-wyEp2NL3uAmaZHAL-1Ps';
      var branchId = '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a';

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoading.value = false;
        return;
      }

      var res = await myClassesPresenter.getMyClassData(
        isLoading: true,
        token: token.toString(),
        branchId: branchId?.toString() ?? '',
      );

      if (res != null && res.status == true && res.data != null) {
        teacherClassData.value = res;
        print("✅ My Classes loaded successfully");
        print("📚 Total Classes: ${res.data!.totalClasses}");

        if (res.data!.classes != null) {
          for (var classItem in res.data!.classes!) {
            print("  - ${classItem.className} ${classItem.sectionName}");
            print("    Subjects: ${classItem.subjectCount}");
          }
        }
      } else {
        print("❌ Failed to load classes: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getMyClassData: $e");
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

  @override
  void onClose() {
    super.onClose();
  }
}