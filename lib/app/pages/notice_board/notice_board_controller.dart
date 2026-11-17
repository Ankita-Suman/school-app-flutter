// controllers/notice_board_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/domain/models/announcement_model.dart';

import '../dashboard/dashboard_controller.dart';

class NoticeBoardController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // ✅ RxString — Obx ke andar yahi use hoga
  var searchText = ''.obs;
  var allAnnouncements = <Announcement>[].obs;
  var filteredAnnouncements = <Announcement>[].obs;

  // ✅ Loader state जोड़ा गया है
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAnnouncements();
    searchController.addListener(_applySearch);
  }

  void _loadAnnouncements() async {
    isLoading.value = true;

    // ✅ अगर Dashboard अभी भी API से Announcements लोड कर रहा है, तो उसका इंतज़ार करें
    if (Get.isRegistered<DashboardController>()) {
      final dashboard = Get.find<DashboardController>();
      if (dashboard.isLoadingAnnouncements.value) {
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return dashboard.isLoadingAnnouncements.value;
        });
      }
    }

    List<Announcement> data = [];

    if (Get.isRegistered<DashboardController>()) {
      final dashboard = Get.find<DashboardController>();
      data = dashboard.announcementData.value?.data ?? [];
    }

    // ✅ डेटा को इस तरह सॉर्ट करें कि सबसे नई एनाउंसमेंट सबसे ऊपर आए।
    data.sort((a, b) => b.announcementDate.compareTo(a.announcementDate));

    allAnnouncements.value = data;
    filteredAnnouncements.value = data;

    // छोटा सा डिले ताकि UI पर लोडर अच्छे से दिखे
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
  }

  void _applySearch() {
    final q = searchController.text.trim().toLowerCase();
    searchText.value = q;

    if (q.isEmpty) {
      filteredAnnouncements.value = allAnnouncements;
    } else {
      filteredAnnouncements.value = allAnnouncements.where((a) {
        return a.title.toLowerCase().contains(q) ||
            a.description.toLowerCase().contains(q) ||
            a.category.toLowerCase().contains(q);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}