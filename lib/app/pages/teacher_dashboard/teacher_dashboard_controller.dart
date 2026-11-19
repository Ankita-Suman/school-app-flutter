// pages/teacher_dashboard/teacher_dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/dashboard/widgets/fees_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/homework_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/profile_widget.dart';
import 'package:school_app/app/pages/teacher_dashboard/widgets/staff_profile_widget.dart';
import 'package:school_app/app/pages/teacher_dashboard/widgets/teacher_dashboard_widget.dart';
import 'package:school_app/domain/models/staff_profile_response.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
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

  var isInitialLoading = true.obs;

  final GetStorage _storage = GetStorage();

  // ============================================================
  // GETTERS (सारे गेटर्स पहले जैसे ही रहेंगे)
  // ============================================================

  bool get hasPhoto =>
      staffProfileData.value?.data?.staff?.photo != null &&
          staffProfileData.value!.data!.staff!.photo!.isNotEmpty;

  String get photo {
    final rawPhoto = staffProfileData.value?.data?.staff?.photo ?? '';
    if (rawPhoto.isEmpty) return '';
    if (rawPhoto.startsWith('http')) return rawPhoto;
    return 'https://decentgroupofschools.com/$rawPhoto';
  }

  String get staffName => staffProfileData.value?.data?.staff?.fullName ?? '--';
  String get employeeId => staffProfileData.value?.data?.staff?.staffId ?? '--';
  String get role => staffProfileData.value?.data?.staff?.designation ?? '--';
  String get prefix => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.prefix ?? '--';
  String get firstName => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.firstName ?? '--';
  String get middleName => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.middleName ?? '--';
  String get lastName => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.lastName ?? '--';
  String get gender => staffProfileData.value?.data?.staff?.genderDisplay ?? '--';
  String get dateOfBirth => staffProfileData.value?.data?.staff?.formattedDateOfBirth ?? '--';
  String get motherTongue => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.motherTongue ?? '--';
  String get nationality => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.nationality ?? '--';
  String get religion => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.religion ?? '--';
  String get maritalStatus => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.maritalStatus ?? '--';
  String get spouseName => '--';
  String get motherName => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.motherName ?? '--';
  String get email => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.email ?? '--';
  String get contact => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.contact ?? '--';
  String get emergencyContact => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.emergencyContact ?? '--';
  String get currentAddress => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.currentAddress ?? '--';
  String get permanentAddress => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.permanentAddress ?? '--';
  String get dateOfJoining => staffProfileData.value?.data?.staff?.formattedJoiningDate ?? '--';
  String get qualification => staffProfileData.value?.data?.staff?.basicInfo?.professionalInfo?.qualification ?? '--';
  String get workExperience => staffProfileData.value?.data?.staff?.basicInfo?.professionalInfo?.workExperience ?? '--';
  String get epfNumber => staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.epfNumber ?? '--';
  String get basicSalary => staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.basicSalary ?? '--';
  String get contractType => staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.contractType ?? '--';
  String get workShift => staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.workShift ?? '--';
  String get workLocation => staffProfileData.value?.data?.staff?.otherDetails?.employmentDetails?.workLocation ?? '--';
  int get paidLeaves => staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.paidLeaves ?? 0;
  int get halfLeaves => staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.halfLeaves ?? 0;
  int get fullDayLeaves => staffProfileData.value?.data?.staff?.otherDetails?.leaveConfiguration?.fullDayLeaves ?? 0;
  String get accountTitle => staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.accountTitle ?? '--';
  String get accountNumber => staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.accountNumber ?? '--';
  String get bankName => staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.bankName ?? '--';
  String get ifscCode => staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.ifscCode ?? '--';
  String get branchName => staffProfileData.value?.data?.staff?.otherDetails?.bankAccountInformation?.bankBranchName ?? '--';
  String get facebookUrl => staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.facebookUrl ?? '--';
  String get twitterUrl => staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.twitterUrl ?? '--';
  String get linkedInUrl => staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.linkedinUrl ?? '--';
  String get instagramUrl => staffProfileData.value?.data?.staff?.otherDetails?.socialMediaProfiles?.instagramUrl ?? '--';
  String get fatherName => staffProfileData.value?.data?.staff?.basicInfo?.personalDetails?.fatherName ?? '--';
  String get fatherContact => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.contact ?? '--';
  String get motherContact => staffProfileData.value?.data?.staff?.basicInfo?.contactInfo?.contact ?? '--';

  String get resumeFileName {
    final doc = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.resume;
    if (doc != null && doc.isNotEmpty) return doc.split('/').last;
    return 'No file chosen';
  }

  String get joiningLetterFileName {
    final doc = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.joiningLetter;
    if (doc != null && doc.isNotEmpty) return doc.split('/').last;
    return 'No file chosen';
  }

  String get otherDocumentsFileName {
    final docs = staffProfileData.value?.data?.staff?.otherDetails?.documentUploads?.otherDocuments;
    if (docs != null && docs.isNotEmpty) return '${docs.length} file(s)';
    return 'No file chosen';
  }

  void resetPassword() => showComingSoonSnackbar();
  void uploadResume() => showComingSoonSnackbar();
  void uploadJoiningLetter() => showComingSoonSnackbar();
  void uploadOtherDocuments() => showComingSoonSnackbar();

  // ============================================================
  // LIFECYCLE & CACHE
  // ============================================================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await getStaffProfileData();
    await fetchTeacherDashboardData();
    isInitialLoading.value = false;
    update();
  }

  void loadCachedData() {
    try {
      String? dashboardJson = _storage.read('teacher_dashboard_data');
      if (dashboardJson != null && dashboardJson.isNotEmpty) {
        final Map<String, dynamic> dashboardMap = jsonDecode(dashboardJson);
        teacherDashboardData.value = TeacherDashboardResponse.fromJson(dashboardMap);
      }
    } catch (e) {
      debugPrint("❌ Error loading cached data: $e");
    }
  }

  void saveTeacherDashboardToCache(TeacherDashboardResponse data) {
    try {
      _storage.write('teacher_dashboard_data', jsonEncode(data.toJson()));
    } catch (e) {
      debugPrint("❌ Error saving teacher dashboard to cache: $e");
    }
  }

  // ============================================================
  // FETCH DATA
  // ============================================================
  Future<void> fetchTeacherDashboardData() async {
    try {
      isLoading.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoading.value = false;
        return;
      }

      var res = await dashboardPresenter.getTeacherDashboardAPI(
        isLoading: false, token: token, branchId: branchId,
      );

      if (res != null && res.status == true && res.data != null) {
        teacherDashboardData.value = res;
        saveTeacherDashboardToCache(res);
      } else {
        teacherDashboardData.value = null;
      }
    } catch (e) {
      debugPrint("❌ Dashboard fetch error: $e");
      teacherDashboardData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStaffProfileData() async {
    try {
      isLoading.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (token.isEmpty || branchId.isEmpty) {
        isLoading.value = false;
        return;
      }

      var res = await dashboardPresenter.getStaffProfileData(
        isLoading: false, token: token, branchId: branchId,
      );

      if (res != null && res.status == true && res.data != null) {
        staffProfileData.value = res;
      } else {
        staffProfileData.value = null;
      }
    } catch (e) {
      debugPrint("❌ Staff profile fetch error: $e");
      staffProfileData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UI GETTERS & NAVIGATION
  // ============================================================
  TeacherInfo? get teacherInfo => teacherDashboardData.value?.data?.teacher;
  List<DashboardCard>? get dashboardCards => teacherDashboardData.value?.data?.dashboardCards;
  DashboardCard? getCardByType(DashboardCardType type) => teacherDashboardData.value?.data?.getCardByType(type);
  List<DashboardCard> get timetableCards => teacherDashboardData.value?.data?.timetableCards ?? [];
  List<DashboardCard> get reviewCards => teacherDashboardData.value?.data?.reviewCards ?? [];
  List<DashboardCard> get announcementCards => teacherDashboardData.value?.data?.announcementCards ?? [];
  List<DashboardCard> get meetingCards => teacherDashboardData.value?.data?.meetingCards ?? [];
  bool get isDataLoaded => teacherDashboardData.value != null;

  void changeTab(int index) {
    if (index == 1 || index == 2 || index == 3) {
      showComingSoonSnackbar();
      return;
    }

    if (index == 0) {
      isInitialLoading.value = true;
      teacherDashboardData.value = null;
      selectedIndex.value = index;
      update();

      fetchTeacherDashboardData().then((_) {
        isInitialLoading.value = false;
        update();
      });
      return;
    }

    if (index == 4) {
      isInitialLoading.value = true;
      staffProfileData.value = null;
      selectedIndex.value = index;
      update();

      getStaffProfileData().then((_) {
        isInitialLoading.value = false;
        update();
      });
      return;
    }

    selectedIndex.value = index;
    update();
  }

  void showComingSoonSnackbar() {
    Get.snackbar('Coming Soon', 'This feature will be available in the upcoming release.',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white,
        duration: const Duration(seconds: 2), margin: const EdgeInsets.all(10), borderRadius: 10,
        icon: const Icon(Icons.info_outline, color: Colors.white));
  }

  void changeNavIndex(int index) => changeTab(index);

  Widget getCurrentScreen() => screens[selectedIndex.value];

  Future<void> refreshData() async => await fetchTeacherDashboardData();

  // ============================================================
  // LOGOUT & CLEAR DATA
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
        debugPrint("Logout API error: $apiError");
      }
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToVerifyBranchCode();
      update();
    } catch (e) {
      await _clearAllStorageData();
      Utility.closeLoader();
      RouteManagement.goToVerifyBranchCode();
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
      staffProfileData.value = null;
      isInitialLoading.value = true;
    } catch (e) {
      debugPrint("Error in _clearAllStorageData: $e");
    }
  }
}