// pages/login/my_children_list_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';

class MyChildrenListController extends GetxController {
  var isLoading = false.obs;
  var childrenList = <ChildData>[].obs;
  var searchQuery = ''.obs;

  String classId = '';
  String sectionId = '';

  @override
  void onReady() {
    super.onReady();
    _getRouteArguments();
    _loadChildrenFromStorage();
  }

  // ========== GET ROUTE ARGUMENTS ==========
  void _getRouteArguments() {
    try {
      final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        classId = args['classId'] as String? ?? '';
        sectionId = args['sectionId'] as String? ?? '';
      }
    } catch (e) {
      debugPrint("❌ Error getting route arguments: $e");
    }
  }

  // ================================================================
  // ✅ LOAD CHILDREN FROM LOGIN RESPONSE
  // FIX: children 'data.user.children' mein hai, 'data.children' mein nahi
  // ================================================================
  Future<void> _loadChildrenFromStorage() async {
    try {
      isLoading.value = true;

      var deviceRepo = Get.find<DeviceRepository>();
      String jsonString = await deviceRepo
          .getSecuredValue(DeviceConstants.loginResponse);

      debugPrint("📦 Login response for children: $jsonString");

      if (jsonString.isEmpty) {
        debugPrint("❌ Login response empty");
        isLoading.value = false;
        return;
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final data = jsonMap['data'] ?? jsonMap;

      // ✅ FIX: 'children' user ke ANDAR hai
      final user = data['user'] ?? data;
      final childrenRaw = user['children'];

      debugPrint("👶 Children raw: $childrenRaw");

      if (childrenRaw is List) {
        childrenList.value = childrenRaw
            .map((e) => ChildData.fromJson(e as Map<String, dynamic>))
            .toList();

        debugPrint("✅ Loaded ${childrenList.length} children");
        for (var child in childrenList) {
          debugPrint("  - ${child.name} (${child.className} - ${child.sectionName})");
        }
      } else {
        debugPrint("❌ 'children' key not found or not a list");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ _loadChildrenFromStorage error: $e");
      debugPrint("$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  // ========== GETTERS ==========
  List<ChildData> get filteredChildren {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return childrenList;

    return childrenList.where((child) {
      return child.name.toLowerCase().contains(query) ||
          child.rollNumber.toLowerCase().contains(query) ||
          child.admissionNumber.toLowerCase().contains(query);
    }).toList();
  }

  int get totalChildren => childrenList.length;
  bool get isLoadingData => isLoading.value;
  bool get hasData => childrenList.isNotEmpty;

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}

// ================================================================
// ✅ ChildData MODEL — Fixed for full_name + nested class/section
// ================================================================
class ChildData {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  final String admissionNumber;
  final String rollNumber;
  final String? photo;
  final String className;
  final String sectionName;
  final String? dateOfBirth;
  final String? gender;

  ChildData({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.admissionNumber,
    required this.rollNumber,
    this.photo,
    required this.className,
    required this.sectionName,
    this.dateOfBirth,
    this.gender,
  });

  factory ChildData.fromJson(Map<String, dynamic> json) {
    // class — could be object or string
    String className = '';
    String sectionName = '';

    if (json['class'] is Map) {
      className = json['class']['name']?.toString() ?? '';
    } else {
      className = json['class']?.toString() ??
          json['class_name']?.toString() ?? '';
    }

    if (json['section'] is Map) {
      sectionName = json['section']['name']?.toString() ?? '';
    } else {
      sectionName = json['section']?.toString() ??
          json['section_name']?.toString() ?? '';
    }

    return ChildData(
      id: json['id']?.toString() ?? '',
      // ✅ FIX: 'full_name' pehle try karo, phir 'name'
      name: json['full_name']?.toString()
          ?? json['name']?.toString()
          ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      admissionNumber: json['admission_number']?.toString() ?? '',
      rollNumber: json['roll_number']?.toString() ?? '',
      photo: json['photo']?.toString(),
      className: className,
      sectionName: sectionName,
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
    );
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;

  String get fullClassName =>
      className.isNotEmpty && sectionName.isNotEmpty
          ? '$className - $sectionName'
          : className.isNotEmpty
          ? className
          : sectionName;
}