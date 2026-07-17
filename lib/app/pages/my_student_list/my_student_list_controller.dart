// pages/login/my_student_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/student_list_response.dart';
import 'my_student_list_presenter.dart';

class MyStudentListController extends GetxController {
  MyStudentListController(this.myStudentListPresenter);

  final MyStudentListPresenter myStudentListPresenter;

  var isLoading = false.obs;
  var studentData = Rxn<StudentsResponse>();

  // Store class and section IDs
  String classId = '';
  String sectionId = '';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _getRouteArguments();
    getMyStudentData();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        classId = args['classId'] as String? ?? '';
        sectionId = args['sectionId'] as String? ?? '';
        print("? Class ID: $classId");
        print("? Section ID: $sectionId");
      }
    } catch (e) {
      print("? Error getting route arguments: $e");
    }
  }

  // ========== FETCH STUDENT DATA ==========
  Future<void> getMyStudentData() async {
    try {
      isLoading.value = true;
      print("??? getMyStudentData START - API HIT WITH LOADER ???");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODM5Njc5OTYsImV4cCI6MTc4NDE0MDc5NiwibmJmIjoxNzgzOTY3OTk2LCJqdGkiOiJDNUE4YW1Gb0FqOTFEa0JCIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.vr39Y0QMHVdAC0gc0B3B3K-wyEp2NL3uAmaZHAL-1Ps';
      var branchId = '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a';

      if (token.isEmpty) {
        print("? Missing token");
        isLoading.value = false;
        return;
      }

      var res = await myStudentListPresenter.getAllStudentList(
        isLoading: false,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );

      if (res != null && res.status == true && res.data != null) {
        studentData.value = res;
        print("? Student list loaded successfully");
        print("? Total Students: ${res.data!.totalStudentCount}");

        if (res.data!.students != null && res.data!.students!.isNotEmpty) {
          for (var student in res.data!.students!) {
            print("  - ${student.studentName} (Roll: ${student.rollNumber})");
          }
        }
      } else {
        print("? Failed to load student list: ${res?.message}");
      }
    } catch (e) {
      print("? Error in getMyStudentData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTER METHODS ==========

  // ? Student list
  List<StudentInfi>? get students => studentData.value?.data?.students;

  // ? Total students count (calculated from list length in the model)
  int get totalStudents => studentData.value?.data?.totalStudentCount ?? 0;

  // ? Class name - first student ke class info se (backend me top-level class_info nahi aata)
  String get className =>
      (students != null && students!.isNotEmpty) ? students!.first.className : '';

  // ? Section name - first student ke section info se
  String get sectionName =>
      (students != null && students!.isNotEmpty) ? students!.first.sectionName : '';

  // ? Full class name
  String get fullClassName =>
      (students != null && students!.isNotEmpty) ? students!.first.fullClassName : '';

  // ? Loading state
  bool get isLoadingData => isLoading.value;

  // ? Check if data exists
  bool get hasData =>
      studentData.value?.data?.students != null &&
          studentData.value!.data!.students!.isNotEmpty;

  @override
  void onClose() {
    super.onClose();
  }
}