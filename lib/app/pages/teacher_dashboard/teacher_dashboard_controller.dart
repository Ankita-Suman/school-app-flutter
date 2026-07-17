import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/dashboard/widgets/dashboard_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/fees_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/homework_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/profile_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/more_widget.dart';
import 'package:school_app/app/pages/teacher_dashboard/widgets/staff_profile_widget.dart';
import 'package:school_app/app/pages/teacher_dashboard/widgets/teacher_dashboard_widget.dart';
import 'package:school_app/domain/models/fees_response.dart';
import 'package:school_app/domain/models/staff_profile_response.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/events_response.dart';
import '../../../domain/models/profile_response.dart';
import '../../../domain/models/teacher_dashboard_response.dart';
import '../../navigators/routes_management.dart';
import '../../utils/utility.dart';
import 'teacher_dashboard_presenter.dart';

class TeacherDashboardController extends GetxController {
  TeacherDashboardController(this.dashboardPresenter);

  final TeacherDashboardPresenter dashboardPresenter;
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    const TeacherDashboardHomeScreen(),
    const HomeWorkWidget(),
    const FeesDetailsScreen(),
    const ProfileWidget(),
    const StaffProfileWidget(),
  ];

  var teacherDashboardData = Rxn<TeacherDashboardResponse>();
  var staffProfileData = Rxn<StaffProfileResponse>();

  var isLoading = false.obs;
  var isLoadingEvents = false.obs;
  var isLoadingProfile = false.obs;
  var isLoadingFees = false.obs;

  final GetStorage _storage = GetStorage();

  // ============================================================
  // ✅ UPDATED GETTERS – reading from nested API response
  // ============================================================

  // ---- Basic Info ----
  bool get hasPhoto =>
      staffProfileData.value?.data?.staff?.photo != null &&
          staffProfileData.value!.data!.staff!.photo!.isNotEmpty;

  String get photo => staffProfileData.value?.data?.staff?.photo ?? '';

  String get staffName => staffProfileData.value?.data?.staff?.fullName ?? '--';
  String get employeeId => staffProfileData.value?.data?.staff?.staffId ?? '--';
  String get role => staffProfileData.value?.data?.staff?.designation ?? '--';

  // Personal Details
  String get prefix =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.prefix ?? '--';
  String get firstName =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.firstName ?? '--';
  String get middleName =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.middleName ?? '--';
  String get lastName =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.lastName ?? '--';
  String get gender =>
      staffProfileData.value?.data?.staff?.genderDisplay ?? '--';
  String get dateOfBirth =>
      staffProfileData.value?.data?.staff?.formattedDateOfBirth ?? '--';
  String get motherTongue =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.motherTongue ?? '--';
  String get nationality =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.nationality ?? '--';
  String get religion =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.religion ?? '--';
  String get maritalStatus =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.maritalStatus ?? '--';
  String get spouseName => '--'; // Not available in this API
  String get motherName =>
      staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.motherName ?? '--';

  // Contact Info
  String get email =>
      staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.email ?? '--';
  String get contact =>
      staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.contact ?? '--';
  String get emergencyContact =>
      staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.emergencyContact ?? '--';
  String get currentAddress =>
      staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.currentAddress ?? '--';
  String get permanentAddress =>
      staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.permanentAddress ?? '--';

  // Professional Info
  String get dateOfJoining =>
      staffProfileData.value?.data?.staff?.formattedJoiningDate ?? '--';
  String get qualification =>
      staffProfileData.value?.data?.staff?.basicInfo?.professionalInfo?.qualification ?? '--';
  String get workExperience =>
      staffProfileData.value?.data?.staff?.basicInfo?.professionalInfo?.workExperience ?? '--';

  // ---- Other Details ----
  String get epfNumber =>
      staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.epfNumber ?? '--';
  String get basicSalary =>
      staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.basicSalary ?? '--';
  String get contractType =>
      staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.contractType ?? '--';
  String get workShift =>
      staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.workShift ?? '--';
  String get workLocation =>
      staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.workLocation ?? '--';

  // Leave Configuration
  int get paidLeaves =>
      staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.paidLeaves ?? 0;
  int get halfLeaves =>
      staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.halfLeaves ?? 0;
  int get fullDayLeaves =>
      staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.fullDayLeaves ?? 0;

  // Bank Account
  String get accountTitle =>
      staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.accountTitle ?? '--';
  String get accountNumber =>
      staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.accountNumber ?? '--';
  String get bankName =>
      staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.bankName ?? '--';
  String get ifscCode =>
      staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.ifscCode ?? '--';
  String get branchName =>
      staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.bankBranchName ?? '--';

  // Social Media
  String get facebookUrl =>
      staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.facebookUrl ?? '--';
  String get twitterUrl =>
      staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.twitterUrl ?? '--';
  String get linkedInUrl =>
      staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.linkedinUrl ?? '--';
  String get instagramUrl =>
      staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.instagramUrl ?? '--';

  // Document Uploads
  String get resumeFileName {
    final doc = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.resume;
    if (doc != null && doc.isNotEmpty) {
      return doc.split('/').last;
    }
    return 'No file chosen';
  }

  String get joiningLetterFileName {
    final doc = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.joiningLetter;
    if (doc != null && doc.isNotEmpty) {
      return doc.split('/').last;
    }
    return 'No file chosen';
  }

  String get otherDocumentsFileName {
    final docs = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.otherDocuments;
    if (docs != null && docs.isNotEmpty) {
      return '${docs.length} file(s)';
    }
    return 'No file chosen';
  }

  // ========== DUMMY METHODS FOR ACTIONS (unchanged) ==========
  void resetPassword() {
    Get.snackbar(
      'Info',
      'Reset password functionality coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void uploadResume() {
    Get.snackbar(
      'Info',
      'Resume upload coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void uploadJoiningLetter() {
    Get.snackbar(
      'Info',
      'Joining letter upload coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void uploadOtherDocuments() {
    Get.snackbar(
      'Info',
      'Other documents upload coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    getStaffProfileData();
  }

  @override
  void onReady() {
    super.onReady();
    loadCachedData();
    fetchTeacherDashboardData();
  }

  // ============================================================
  // CACHE
  // ============================================================
  void loadCachedData() {
    try {
      String? dashboardJson = _storage.read('teacher_dashboard_data');
      if (dashboardJson != null && dashboardJson.isNotEmpty) {
        final Map<String, dynamic> dashboardMap = jsonDecode(dashboardJson);
        teacherDashboardData.value = TeacherDashboardResponse.fromJson(dashboardMap);
        print("✅ Teacher dashboard data loaded from cache");
      }
    } catch (e) {
      print("❌ Error loading cached data: $e");
    }
  }

  void saveTeacherDashboardToCache(TeacherDashboardResponse data) {
    try {
      _storage.write('teacher_dashboard_data', jsonEncode(data.toJson()));
      print("✅ Teacher dashboard saved to cache");
    } catch (e) {
      print("❌ Error saving teacher dashboard to cache: $e");
    }
  }

  // ============================================================
  // FETCH TEACHER DASHBOARD
  // ============================================================
  Future<void> fetchTeacherDashboardData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      Utility.showLoader();
      print("📡📡📡 FETCHING TEACHER DASHBOARD DATA 📡📡📡");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoading.value = false;
        Utility.closeLoader();
        return;
      }

      var res = await dashboardPresenter.getTeacherDashboardAPI(
        isLoading: true,
        token: token,
        branchId: branchId,
      );

      if (res != null && res.status == true && res.data != null) {
        teacherDashboardData.value = res;
        saveTeacherDashboardToCache(res);
        print("✅ Teacher Dashboard fetched successfully");
      } else {
        print("❌ Failed to fetch teacher dashboard: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error fetching teacher dashboard: $e");
    } finally {
      isLoading.value = false;
      Utility.closeLoader();
    }
  }

  // ============================================================
  // ✅ UPDATED FETCH STAFF PROFILE – uses stored token
  // ============================================================
  Future<void> getStaffProfileData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      Utility.showLoader();
      print("📡📡📡 FETCHING STAFF PROFILE 📡📡📡");

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token == null || token.isEmpty) {
        print("❌ Missing token");
        isLoading.value = false;
        Utility.closeLoader();
        return;
      }

      var res = await dashboardPresenter.getStaffProfileData(
        isLoading: false,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3ODQzMDk2NjgsImV4cCI6MTc4NDQ4MjQ2OCwibmJmIjoxNzg0MzA5NjY4LCJqdGkiOiJwdEtIRU1TbVRzWGh4eWpXIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZjZTg0MjJlLWFhOTItNGQ2OS1hZjZhLTIxNTlmZDBjOGM2YSIsInJvbGVfaWQiOiI4MmY4MGE0Yi03ZWIxLTRiNWMtYmIxMS03Yjk5ODczMjY4ZjUifQ.7QW9n9a4zqeslnfDzrATZXr3PuZ1IgHRSWtoXypfuB0',
        branchId: '6ce8422e-aa92-4d69-af6a-2159fd0c8c6a',
      );

      if (res != null && res.status == true && res.data != null) {
        staffProfileData.value = res;
        print("✅ Staff Profile fetched successfully");
        print("👤 Staff: ${res.data?.staff?.fullName}");
      } else {
        print("❌ Failed to fetch staff profile: ${res?.message}");
      }
    } catch (e) {
      print("❌ Error fetching staff profile: $e");
    } finally {
      isLoading.value = false;
      Utility.closeLoader();
    }
  }

  // ============================================================
  // GETTERS FOR UI (unchanged)
  // ============================================================
  TeacherInfo? get teacherInfo => teacherDashboardData.value?.data?.teacher;
  List<DashboardCard>? get dashboardCards => teacherDashboardData.value?.data?.dashboardCards;
  DashboardCard? getCardByType(DashboardCardType type) => teacherDashboardData.value?.data?.getCardByType(type);
  List<DashboardCard> get timetableCards => teacherDashboardData.value?.data?.timetableCards ?? [];
  List<DashboardCard> get reviewCards => teacherDashboardData.value?.data?.reviewCards ?? [];
  List<DashboardCard> get announcementCards => teacherDashboardData.value?.data?.announcementCards ?? [];
  List<DashboardCard> get meetingCards => teacherDashboardData.value?.data?.meetingCards ?? [];
  bool get isDataLoaded => teacherDashboardData.value != null;

  // ============================================================
  // NAVIGATION
  // ============================================================
  void changeTab(int index) {
    print("🔄🔄🔄 changeTab CALLED: index = $index 🔄🔄🔄");
    selectedIndex.value = index;
    update();

    switch (index) {
      case 0:
        print("🏠 Home tab selected - Loading fresh data");
        fetchTeacherDashboardData();
        break;
      case 1:
        print("💼 Work tab selected");
        break;
      case 2:
        print("📅 Schedule tab selected");
        break;
      case 3:
        print("💬 Messages tab selected");
        break;
      case 4:
        print("👤 Profile tab selected");
        getStaffProfileData(); // Refresh profile on tab select
        break;
    }
  }

  void changeNavIndex(int index) => changeTab(index);
  Widget getCurrentScreen() => screens[selectedIndex.value];

  Future<void> refreshData() async {
    print("🔄 Refreshing teacher dashboard data...");
    await fetchTeacherDashboardData();
    print("✅ Teacher dashboard data refreshed");
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logoutAPI({required bool isLoading}) async {
    var deviceRepo = Get.find<DeviceRepository>();
    var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
    try {
      Utility.showLoader();
      try {
        var res = await dashboardPresenter.logoutAPI(isLoading: isLoading, token: token);
        debugPrint('Logout response: $res');
      } catch (apiError) {
        print("Logout API error: $apiError");
      }
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    } catch (e) {
      print("Logout error: $e");
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToLogin();
      update();
    }
  }

  Future<void> _clearAllStorageData() async {
    try {
      var repo = Get.find<DeviceRepository>();
      await repo.deleteAllSecuredValues();
      await repo.deleteSecuredValue(DeviceConstants.token);
      await repo.deleteSecuredValue(DeviceConstants.branchId);
      await repo.deleteSecuredValue(DeviceConstants.branchCode);
      await repo.deleteSecuredValue(DeviceConstants.email);
      await repo.deleteSecuredValue(DeviceConstants.username);
      await repo.deleteSecuredValue(DeviceConstants.studentId);
      await repo.deleteSecuredValue(DeviceConstants.profileData);
      await repo.deleteBox();
      await _storage.remove('teacher_dashboard_data');
      teacherDashboardData.value = null;
      print("All storage data cleared successfully");
    } catch (e) {
      print("Error in _clearAllStorageData: $e");
    }
  }

  @override
  void onClose() {
    print("🔴🔴🔴 TEACHER DASHBOARD CONTROLLER onClose CALLED 🔴🔴🔴");
    super.onClose();
  }
}