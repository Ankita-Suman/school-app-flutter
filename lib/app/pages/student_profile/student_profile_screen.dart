import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'student_profile_controller.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late final StudentProfileController controller;
  int _selectedTab = 0; // 0: Overview, 1: Documents

  @override
  void initState() {
    super.initState();
    controller = Get.put(StudentProfileController(Get.find()));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber == '--') return;
    final String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanedNumber.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open dialer.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _copyToClipboard(String text) {
    if (text.isEmpty || text == '--') return;
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Number copied to clipboard',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        if (controller.isLoading) {
          return Stack(
            children: [
              _buildHeader(backgroundHeight),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                AssetConstants.icBlueBg,
                width: double.infinity,
                height: backgroundHeight,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: SvgPicture.asset(AssetConstants.icBackBg),
                            ),
                            const SizedBox(width: 8),
                            Text('Student Profile', style: Styles.whiteBold),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: controller.hasPhoto
                              ? ClipOval(
                            child: Image.network(
                              controller.photo,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar();
                              },
                            ),
                          )
                              : _buildDefaultAvatar(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.studentName.isNotEmpty
                              ? controller.studentName
                              : '-- --',
                          style: Styles.darkBlcW700,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Roll No. ${controller.rollNumber.isNotEmpty ? controller.rollNumber : '--'} • ${controller.admissionNumber.isNotEmpty ? 'Admission: ${controller.admissionNumber}' : ''}',
                          style: Styles.darkBlueW400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildTabButton('Overview', 0),
                          _buildTabButton('Documents', 1),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedTab == 0
                        ? _buildOverviewContent()
                        : _buildDocumentsContent(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(double backgroundHeight) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            AssetConstants.icBlueBg,
            width: double.infinity,
            height: backgroundHeight,
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(AssetConstants.icBackBg),
                ),
                const SizedBox(width: 8),
                Text('Student Profile', style: Styles.whiteBold),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== OVERVIEW CONTENT ==========
  Widget _buildOverviewContent() {
    final data = controller.profileData.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          // Basic Info
          _buildInfoCard(
            title: 'Basic Info',
            children: [
              _buildInfoRow('Date of Birth', data?.personal.dateOfBirth ?? '--'),
              _buildInfoRow('Blood Group', data?.personal.bloodGroup ?? '--'),
              _buildInfoRow('Gender', data?.personal.gender ?? '--'),
            ],
          ),
          const SizedBox(height: 12),

          // Parent Info
          _buildInfoCard(
            title: 'Parent Info',
            children: [
              _buildInfoRow("Father's Name", data?.parents.father.name ?? '--'),
              _buildInfoRow("Father's Contact", data?.parents.father.phone ?? '--', isContact: true),
              _buildInfoRow("Mother's Name", data?.parents.mother.name ?? '--'),
              _buildInfoRow("Mother's Contact", data?.parents.mother.phone ?? '--', isContact: true),
            ],
          ),
          const SizedBox(height: 12),

          // Academic Info
          _buildInfoCard(
            title: 'Academic Info',
            children: [
              _buildInfoRow('Class', data?.personal.classInfo.name ?? '--'),
              _buildInfoRow('Roll No.', data?.personal.rollNumber ?? '--'),
              _buildInfoRow('Admission No.', data?.personal.admissionNumber ?? '--'),
              _buildInfoRow('Email', '--'),
              _buildInfoRow('Address', data?.personal.address.permanent ?? '--'),
            ],
          ),
          const SizedBox(height: 12),

          // ========== SIBLINGS CARD (NEW) ==========
          _buildSiblingsCard(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ========== SIBLINGS CARD ==========
  Widget _buildSiblingsCard() {
    final siblings = controller.profileData.value?.personal.siblings ?? [];
    if (siblings.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, size: 18, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text('Siblings', style: Styles.darkBlcW70016),
            ],
          ),
          const SizedBox(height: 12),
          ...siblings.asMap().entries.map((entry) {
            final index = entry.key;
            final sibling = entry.value;
            return Column(
              children: [
                _buildSiblingRow(sibling),
                if (index < siblings.length - 1)
                  Divider(height: 1, color: Colors.grey.shade200),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // ========== SIBLING ROW ==========
  Widget _buildSiblingRow(dynamic sibling) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Icons.person_outline, size: 16, color: Colors.blue.shade700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sibling.fullName,
                  style: Styles.darkBlcW600.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${sibling.classInfo.name} • ${sibling.section.name} • Roll No. ${sibling.rollNumber}',
                  style: Styles.darkBlueW400.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== DOCUMENTS CONTENT ==========
  Widget _buildDocumentsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No documents uploaded yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ========== INFO CARD ==========
  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Styles.darkBlcW70016),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // ========== INFO ROW ==========
  Widget _buildInfoRow(
      String label,
      String value, {
        bool isContact = false,
        IconData? icon,
        Color? iconBgColor,
        Color? iconColor,
      }) {
    IconData getIcon(String label) {
      if (label.contains('Date') || label.contains('Birth')) return Icons.calendar_today_outlined;
      if (label.contains('Blood')) return Icons.favorite;
      if (label.contains("Father") || label.contains("Mother")) return Icons.person_outline;
      if (label.contains('Contact') || label.contains('Phone') || label.contains('Number'))
        return Icons.phone_outlined;
      if (label.contains('Email')) return Icons.email_outlined;
      if (label.contains('Address')) return Icons.location_on_outlined;
      if (label.contains('Class')) return Icons.school_outlined;
      if (label.contains('Roll')) return Icons.numbers_outlined;
      if (label.contains('Admission')) return Icons.assignment_outlined;
      if (label.contains('Gender')) return Icons.person_outline;
      return Icons.info_outline;
    }

    Color getBgColor(String label) {
      if (label.contains('Blood')) return Colors.red.shade50;
      return Colors.blue.shade50;
    }

    Color getIconColor(String label) {
      if (label.contains('Blood')) return Colors.red.shade700;
      return Colors.blue.shade700;
    }

    final iconData = icon ?? getIcon(label);
    final bgColor = iconBgColor ?? getBgColor(label);
    final fgColor = iconColor ?? getIconColor(label);
    final bool isContactField = isContact || label.contains('Contact') || label.contains('Phone');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(iconData, size: 16, color: fgColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Styles.darkBlueW400),
                const SizedBox(height: 2),
                isContactField && value.isNotEmpty && value != '--'
                    ? GestureDetector(
                  onTap: () => _makePhoneCall(value),
                  onLongPress: () => _copyToClipboard(value),
                  child: Text(
                    value,
                    style: Styles.darkBlcW600.copyWith(
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                    : Text(
                  value,
                  style: Styles.darkBlcW600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}