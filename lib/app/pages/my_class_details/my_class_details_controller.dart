// pages/login/my_class_details_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/class_details_response.dart';
import 'my_class_details_presenter.dart';

class MyClassDetailsController extends GetxController {
  MyClassDetailsController(this.myClassesDetailsPresenter);

  final MyClassDetailsPresenter myClassesDetailsPresenter;
  var selectedTab = 0.obs;

  var isLoading = false.obs;
  var classDetailsData = Rxn<ClassDetailsResponse>();

  // ✅ Variables to store class and section IDs from route
  String classId = '';
  String sectionId = '';

  // ✅ Static timetable times
  final List<String> timetableTimes = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    _getRouteArguments();
    getMyClassDetailsData();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;

      if (args != null) {
        classId = args['classId'] as String? ?? '';
        sectionId = args['sectionId'] as String? ?? '';

        print("📚 Class ID: $classId");
        print("📚 Section ID: $sectionId");
      } else {
        print("❌ No arguments received");
      }
    } catch (e) {
      print("❌ Error getting route arguments: $e");
    }
  }

  // ========== FETCH CLASS DETAILS ==========
  Future<void> getMyClassDetailsData() async {
    if (classId.isEmpty || sectionId.isEmpty) {
      print("❌ Class ID or Section ID is empty");
      isLoading.value = false;
      return;
    }

    try {
      print("📡📡📡 getMyClassDetailsData START - API HIT WITH LOADER 📡📡📡");
      print("📚 Class ID: $classId");
      print("📚 Section ID: $sectionId");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoading.value = false;
        return;
      }

      var res = await myClassesDetailsPresenter.getMyClassDetailsData(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODM3ODM2NzIsImV4cCI6MTc4Mzk1NjQ3MiwibmJmIjoxNzgzNzgzNjcyLCJqdGkiOiJmcmdjQ1JyVW1Oc0ZmSHZUIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.vlrlrI1f0Oj_OG7e-sC2H3dJjOAuFIOLj_7iIJu1cv0',
        branchId: '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a',
        classId: classId,
        sectionId: sectionId,
      );

      if (res != null && res.status == true && res.data != null) {
        classDetailsData.value = res;
        print("✅ Class Details loaded successfully");
        print("📚 Class: ${res.data!.classInfo?.className} - ${res.data!.classInfo?.sectionName}");
        print("📚 Total Students: ${res.data!.classStrength?.totalStudents ?? 0}");
        print("📚 Subjects: ${res.data!.subjectNames.join(', ')}");
      } else {
        print("❌ Failed to load class details: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error in getMyClassDetailsData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTER METHODS FOR UI ==========

  String get className => classDetailsData.value?.data?.classInfo?.className ?? '';
  String get sectionName => classDetailsData.value?.data?.classInfo?.sectionName ?? '';
  String get fullClassName => classDetailsData.value?.data?.fullClassName ?? '';
  int get totalStudents => classDetailsData.value?.data?.totalStudents ?? 0;
  List<SubjectAllocation>? get subjects => classDetailsData.value?.data?.subjectAllocation;
  ClassStrength? get classStrength => classDetailsData.value?.data?.classStrength;

  // ✅ Get timetable with static times
  List<Map<String, String>> get timetableWithTimes {
    final subjectList = subjects ?? [];
    final List<Map<String, String>> result = [];

    for (int i = 0; i < timetableTimes.length && i < subjectList.length; i++) {
      result.add({
        'time': timetableTimes[i],
        'subject': subjectList[i].subject,
        'teacher': subjectList[i].teacherName,
      });
    }

    // Agar subjects kam hain toh remaining times show "Free"
    if (subjectList.length < timetableTimes.length) {
      for (int i = subjectList.length; i < timetableTimes.length; i++) {
        result.add({
          'time': timetableTimes[i],
          'subject': 'Free',
          'teacher': '',
        });
      }
    }

    return result;
  }

  // Get student count by gender (if available)
  int get boysCount => classStrength?.boys ?? 0;
  int get girlsCount => classStrength?.girls ?? 0;

  // ✅ Get subject allocation list
  List<SubjectAllocation> get subjectAllocationList => subjects ?? [];

  @override
  void onClose() {
    super.onClose();
  }
}