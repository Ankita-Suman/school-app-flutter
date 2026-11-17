// controllers/teacher_dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/dashboard/widgets/dashboard_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/fees_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/homework_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/profile_widget.dart';
import 'package:school_app/app/pages/dashboard/widgets/more_widget.dart';
import 'package:school_app/domain/models/fees_response.dart';
import 'package:school_app/domain/models/announcement_model.dart';
import 'package:school_app/domain/models/payment_order_response.dart';
import 'package:school_app/domain/models/student_notice_response.dart';

import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/events_response.dart';
import '../../../domain/models/profile_response.dart';
import '../../navigators/routes_management.dart';
import '../../utils/utility.dart';
import 'dashboard_presenter.dart';

class DashboardController extends GetxController {
  DashboardController(this.dashboardPresenter);

  final DashboardPresenter dashboardPresenter;
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardHomeScreen(),
    const HomeWorkWidget(),
    const FeesDetailsScreen(),
    const ProfileWidget(),
    const MoreWidget(),
  ];

  var profileData = Rxn<ProfileData>();
  var feeData = Rxn<FeeResponseModel>();
  var announcementData = Rxn<AnnouncementResponse>();
  var eventsData = Rxn<EventsResponseModel>();

  var isLoadingEvents = false.obs;
  var isLoadingProfile = false.obs;
  var isLoadingFees = false.obs;
  var isLoadingHome = false.obs;
  var isLoadingAnnouncements = false.obs;
  var isCreatingPaymentOrder = false.obs;

  var hasMultipleChildren = false.obs;
  var currentStudentId = ''.obs;

  final GetStorage _storage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _initStudentId();
    _checkChildrenCount();
    loadHomeData();
  }

  Future<void> _initStudentId() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      String storedId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);

      if (storedId.isNotEmpty && storedId != 'null') {
        currentStudentId.value = storedId;
        return;
      }

      String jsonString = await deviceRepo.getSecuredValue(DeviceConstants.loginResponse);
      if (jsonString.isEmpty) return;

      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final data = jsonMap['data'] ?? jsonMap;
      final user = data['user'] ?? data;

      final directId = user['student_id']?.toString() ?? '';
      if (directId.isNotEmpty && directId != 'null') {
        currentStudentId.value = directId;
        await deviceRepo.saveValueSecurely(DeviceConstants.studentId, directId);
        return;
      }

      final children = user['children'];
      if (children is List && children.isNotEmpty) {
        final firstChildId = children.first['id']?.toString() ?? '';
        if (firstChildId.isNotEmpty) {
          currentStudentId.value = firstChildId;
          await deviceRepo.saveValueSecurely(DeviceConstants.studentId, firstChildId);
        }
      }
    } catch (e) {
      debugPrint("❌ _initStudentId error: $e");
    }
  }

  Future<void> _checkChildrenCount() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      String jsonString = await deviceRepo.getSecuredValue(DeviceConstants.loginResponse);

      if (jsonString.isEmpty) {
        hasMultipleChildren.value = false;
        return;
      }

      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final data = jsonMap['data'] ?? jsonMap;
      final user = data['user'] ?? data;
      final children = user['children'];

      if (children is List) {
        hasMultipleChildren.value = children.length > 1;
      } else {
        hasMultipleChildren.value = false;
      }
    } catch (e) {
      hasMultipleChildren.value = false;
    }
  }

  Future<void> loadHomeData() async {
    isLoadingHome.value = true;

    profileData.value = null;
    eventsData.value = null;
    announcementData.value = null;

    try {
      await Future.wait([
        _fetchProfileSilently(),
        _fetchEventsSilently(),
        _fetchAnnouncementsSilently(),
      ]);
    } catch (e) {
      debugPrint("❌ loadHomeData error: $e");
    } finally {
      isLoadingHome.value = false;
    }
  }

  Future<void> _fetchProfileSilently() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) return;

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true) {
        profileData.value = res.data;
      } else {
        profileData.value = null;
        // ❌ यहाँ से _handleSessionExpired हटा दिया गया है
      }
    } catch (e) {
      debugPrint("❌ _fetchProfileSilently error: $e");
    }
  }

  Future<void> _fetchEventsSilently() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) return;

      var res = await dashboardPresenter.getAllEvents(
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          eventsData.value = EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true, message: "Success", data: res.data as EventsData,
          );
        }
      } else {
        eventsData.value = null;
      }
    } catch (e) {
      debugPrint("❌ _fetchEventsSilently error: $e");
    }
  }

  Future<void> _fetchAnnouncementsSilently() async {
    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) return;

      var res = await dashboardPresenter.getStudentNoticesAPI(
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        studentId: studentId.toString(),
      );

      if (res != null) {
        _parseAndMapNotices(res);
      } else {
        announcementData.value = null;
      }
    } catch (e) {
      debugPrint("❌ _fetchAnnouncementsSilently error: $e");
    }
  }

  Future<void> getProfileDetailsWithLoader() async {
    try {
      isLoadingProfile.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) {
        isLoadingProfile.value = false;
        return;
      }

      var res = await dashboardPresenter.getProfileDetailsAPI(
        isLoading: false, token: token.toString(), branchId: branchId.toString(), studentId: studentId.toString(),
      );

      if (res != null && res.status == true) {
        profileData.value = res.data;
      } else {
        profileData.value = null;
      }
    } catch (e) {
      debugPrint("❌ getProfileDetailsWithLoader error: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> getFeesDetails({bool showLoader = true}) async {
    try {
      if (showLoader) isLoadingFees.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) {
        if (showLoader) isLoadingFees.value = false;
        return;
      }

      var res = await dashboardPresenter.getFeesDetailsAPI(
        isLoading: false, token: token.toString(), branchId: branchId.toString(), studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is FeeData) {
          feeData.value = FeeResponseModel(
            status: true, message: "Success", data: res.data as FeeData,
          );
        } else if (res.data is Map<String, dynamic>) {
          feeData.value = FeeResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is FeeResponseModel) {
          feeData.value = res.data as FeeResponseModel;
        }
      } else {
        feeData.value = null;
      }
    } catch (e) {
      debugPrint("❌ getFeesDetails error: $e");
    } finally {
      if (showLoader) isLoadingFees.value = false;
    }
  }

  Future<void> refreshFeesAfterPayment({String? invoiceId}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    await getFeesDetails(showLoader: false);

    if (invoiceId != null) {
      for (var attempt = 0; attempt < 2; attempt++) {
        if (!_isInvoiceStillPending(invoiceId)) break;
        await Future.delayed(const Duration(seconds: 2));
        await getFeesDetails(showLoader: false);
      }
    }
  }

  bool _isInvoiceStillPending(String invoiceId) {
    final invoices = feeData.value?.data?.invoices;
    if (invoices == null) return false;
    for (final inv in invoices) {
      if (inv.id == invoiceId) {
        return (inv.status ?? '').toUpperCase() != 'PAID';
      }
    }
    return false;
  }

  Future<PaymentOrderResponse?> createPaymentOrder({
    required String invoiceId,
    required double amount,
  }) async {
    try {
      isCreatingPaymentOrder.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      String studentId = currentStudentId.value;
      final feeStudentId = feeData.value?.data?.student?.id;
      if (feeStudentId != null && feeStudentId.toString().isNotEmpty) {
        studentId = feeStudentId.toString();
      }

      final sessionId = feeData.value?.data?.sessionId ?? '';

      if (token.isEmpty || branchId.isEmpty || studentId.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please login again.',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
        return null;
      }

      final res = await dashboardPresenter.createPaymentOrder(
        isLoading: false, token: token, branchId: branchId, studentId: studentId,
        invoiceIds: [invoiceId], amount: amount, sessionId: sessionId,
      );

      return res;
    } catch (e) {
      debugPrint("❌ createPaymentOrder error: $e");
      return null;
    } finally {
      isCreatingPaymentOrder.value = false;
    }
  }

  Future<void> getEventsDetails() async {
    try {
      isLoadingEvents.value = true;
      eventsData.value = null;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) {
        isLoadingEvents.value = false;
        return;
      }

      var res = await dashboardPresenter.getAllEvents(
        isLoading: false, token: token.toString(), branchId: branchId.toString(), studentId: studentId.toString(),
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is EventsResponseModel) {
          eventsData.value = res.data as EventsResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          eventsData.value = EventsResponseModel.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is EventsData) {
          eventsData.value = EventsResponseModel(
            status: true, message: "Success", data: res.data as EventsData,
          );
        }
      } else {
        eventsData.value = null;
      }
    } catch (e) {
      debugPrint("❌ getEventsDetails error: $e");
    } finally {
      isLoadingEvents.value = false;
    }
  }

  Future<void> getAnnouncementDetails() async {
    try {
      isLoadingAnnouncements.value = true;
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      if (currentStudentId.value.isEmpty) await _initStudentId();
      var studentId = currentStudentId.value;

      if (token.isEmpty || studentId.isEmpty) {
        isLoadingAnnouncements.value = false;
        return;
      }

      var res = await dashboardPresenter.getStudentNoticesAPI(
        isLoading: false, token: token.toString(), branchId: branchId.toString(), studentId: studentId.toString(),
      );

      if (res != null) {
        _parseAndMapNotices(res);
      } else {
        announcementData.value = null;
      }
    } catch (e) {
      debugPrint("❌ getAnnouncementDetails error: $e");
    } finally {
      isLoadingAnnouncements.value = false;
    }
  }

  void _parseAndMapNotices(dynamic res) {
    List<Announcement> mappedAnnouncements = [];
    try {
      StudentNoticeResponse? noticeResponse;
      if (res != null) {
        if (res is StudentNoticeResponse) {
          noticeResponse = res;
        } else if (res is Map<String, dynamic>) {
          noticeResponse = StudentNoticeResponse.fromJson(res);
        } else if (res is String) {
          noticeResponse = StudentNoticeResponse.fromJson(jsonDecode(res));
        }
      }

      if (noticeResponse != null && noticeResponse.status == true && noticeResponse.data != null) {
        for (var notice in noticeResponse.data!) {
          DateTime parsedDate;
          try {
            parsedDate = DateTime.parse(notice.noticeDate ?? '');
          } catch (e) {
            parsedDate = DateTime.now();
          }

          mappedAnnouncements.add(
            Announcement(
              id: notice.id ?? '',
              title: notice.title ?? 'No Title',
              description: notice.message ?? 'No Description',
              category: notice.noticeType ?? 'GENERAL',
              announcementDate: parsedDate,
            ),
          );
        }
      }
    } catch (parseError) {
      debugPrint("❌ Notice parse error: $parseError");
    }

    if (mappedAnnouncements.isNotEmpty) {
      mappedAnnouncements.sort((a, b) => b.announcementDate.compareTo(a.announcementDate));
      announcementData.value = AnnouncementResponse(status: true, message: "Success", data: mappedAnnouncements);
    } else {
      announcementData.value = AnnouncementResponse(status: true, message: "No data", data: []);
    }
  }

  void changeNavIndex(int index) {
    if (index == 1) {
      showComingSoonSnackbar();
      return;
    }
    if (index == 0) {
      selectedIndex.value = 0;
      update();
      loadHomeData();
      return;
    }
    if (index == 2) {
      isLoadingFees.value = true;
      feeData.value = null;
      selectedIndex.value = 2;
      update();
      getFeesDetails();
      return;
    }
    if (index == 3) {
      isLoadingProfile.value = true;
      profileData.value = null;
      selectedIndex.value = 3;
      update();
      getProfileDetailsWithLoader();
      return;
    }
    selectedIndex.value = index;
    update();
  }

  Future<void> switchStudent(String newStudentId) async {
    profileData.value = null;
    eventsData.value = null;
    feeData.value = null;
    announcementData.value = null;
    currentStudentId.value = newStudentId;
    var deviceRepo = Get.find<DeviceRepository>();
    await deviceRepo.saveValueSecurely(DeviceConstants.studentId, newStudentId);
    await loadHomeData();
  }

  void showComingSoonSnackbar() {
    Get.snackbar('Coming Soon', 'This feature will be available in the upcoming release.',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white,
        duration: const Duration(seconds: 2), margin: const EdgeInsets.all(10), borderRadius: 10,
        icon: const Icon(Icons.info_outline, color: Colors.white));
  }

  Widget getCurrentScreen() {
    return screens[selectedIndex.value];
  }

  Future<void> logoutAPI({required bool isLoading}) async {
    var deviceRepo = Get.find<DeviceRepository>();
    var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
    try {
      Utility.showLoader();
      try {
        var res = await dashboardPresenter.logoutAPI(isLoading: isLoading, token: token);
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

      await _storage.remove('profile_data');
      await _storage.remove('events_data');
      await _storage.remove('fees_data');

      currentStudentId.value = '';
      hasMultipleChildren.value = false;
    } catch (e) {
      debugPrint("Error in _clearAllStorageData: $e");
    }
  }

  double get totalDueAmount => (feeData.value?.data?.cards?.totalDue ?? 0).toDouble();

  int get pendingInvoiceCount {
    final invoices = feeData.value?.data?.invoices ?? [];
    return invoices.where((inv) {
      final status = (inv.status ?? '').toUpperCase();
      return status == 'PENDING' || status == 'PARTIAL';
    }).length;
  }

  bool get canPayNow => totalDueAmount > 0 && !isCreatingPaymentOrder.value;

  @override
  void onClose() {
    debugPrint("🔴🔴🔴 DASHBOARD CONTROLLER onClose CALLED 🔴🔴🔴");
    super.onClose();
  }
}