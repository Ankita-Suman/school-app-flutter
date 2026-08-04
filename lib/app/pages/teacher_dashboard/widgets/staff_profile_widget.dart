import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app.dart';
import '../teacher_dashboard_controller.dart';

class StaffProfileWidget extends StatefulWidget {
  const StaffProfileWidget({super.key});

  @override
  State<StaffProfileWidget> createState() => _StaffProfileWidgetState();
}

class _StaffProfileWidgetState extends State<StaffProfileWidget> {
  late final TeacherDashboardController controller;

  int _selectedTab = 0; // 0: Basic Information, 1: Other Details

  @override
  void initState() {
    super.initState();
    controller = Get.find<TeacherDashboardController>();
  }

  // ========== MAKE PHONE CALL ==========
  void _makePhoneCall(String phoneNumber) async {
    // Clean the number: keep only digits and '+'
    final String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanedNumber.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('Error', 'Could not open dialer.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        if (controller.isLoading == true) {
          return Stack(
            children: [
              _buildHeader(backgroundHeight),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Stack(
          children: [
            // Header background
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            Text('Staff Profile', style: Styles.whiteBold),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Profile card
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
                              errorBuilder: (_, __, ___) =>
                                  _buildDefaultAvatar(),
                            ),
                          )
                              : _buildDefaultAvatar(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.staffName.isNotEmpty
                              ? controller.staffName
                              : '-- --',
                          style: Styles.darkBlcW700,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Employee ID: ${controller.employeeId.isNotEmpty ? controller.employeeId : '--'} • ${controller.role.isNotEmpty ? controller.role : ''}',
                          style: Styles.darkBlueW400,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tabs
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
                          _buildTabButton('Basic Information', 0),
                          _buildTabButton('Other Details', 1),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content
                  Expanded(
                    child: _selectedTab == 0
                        ? _buildBasicInformationContent()
                        : _buildOtherDetailsContent(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ========== HEADER ==========
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
                Text('Staff Profile', style: Styles.whiteBold),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ========== DEFAULT AVATAR ==========
  Widget _buildDefaultAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.blue.shade700,
      ),
    );
  }

  // ========== TAB BUTTON ==========
  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                  isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
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

  // ========== BASIC INFORMATION CONTENT ==========
  Widget _buildBasicInformationContent() {
    // Build full name from parts
    final String fullName = [
      controller.prefix != '--' && controller.prefix.isNotEmpty
          ? controller.prefix
          : '',
      controller.firstName != '--' && controller.firstName.isNotEmpty
          ? controller.firstName
          : '',
      controller.middleName != '--' && controller.middleName.isNotEmpty
          ? controller.middleName
          : '',
      controller.lastName != '--' && controller.lastName.isNotEmpty
          ? controller.lastName
          : '',
    ].where((s) => s.isNotEmpty).join(' ');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          // ---------- ROLE DETAILS ----------
          _buildInfoCard(
            title: 'Role Details',
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Staff Type', style: Styles.darkBlueW400),
                        const SizedBox(height: 4),
                        Text(
                          'TEACHING',
                          style: Styles.darkBlcW600,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Staff Role', style: Styles.darkBlueW400),
                        const SizedBox(height: 4),
                        Text(
                          'TEACHER',
                          style: Styles.darkBlcW600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ---------- PERSONAL DETAILS ----------
          _buildInfoCard(
            title: 'Personal Details',
            children: [
              _buildInfoRow('Name', fullName),
              _buildInfoRow('Gender', controller.gender),
              _buildInfoRow('Date Of Birth', controller.dateOfBirth),
              _buildInfoRow('Mother Tongue', controller.motherTongue),
              _buildInfoRow('Nationality', controller.nationality),
              _buildInfoRow('Religion', controller.religion),
              _buildInfoRow('Marital Status', controller.maritalStatus),
              _buildInfoRow('Spouse Name', controller.spouseName),
              // ---------- FAMILY DETAILS (added) ----------
              _buildInfoRow('Father Name', controller.fatherName ?? '--'),
              _buildInfoRow('Father Contact', controller.fatherContact ?? '--'),
              _buildInfoRow('Mother Name', controller.motherName),
              _buildInfoRow('Mother Contact', controller.motherContact ?? '--'),
              // ---------- SIBLING INFO (added) ----------
              // if (controller.siblings != null && controller.siblings!.isNotEmpty)
              //   ..._buildSiblingRows(),
              // // if no siblings, show a placeholder
              // if (controller.siblings == null || controller.siblings!.isEmpty)
              //   _buildInfoRow('Siblings', 'No siblings added'),
            ],
          ),

          // ---------- CONTACT INFO ----------
          _buildInfoCard(
            title: 'Contact Info',
            children: [
              _buildInfoRow('Email', controller.email),
              _buildInfoRow('Contact', controller.contact),
              _buildInfoRow('Emergency Contact', controller.emergencyContact),
              _buildInfoRow('Current Address', controller.currentAddress),
              _buildInfoRow('Permanent Address', controller.permanentAddress),
            ],
          ),

          // ---------- PROFESSIONAL INFO ----------
          _buildInfoCard(
            title: 'Professional Info',
            children: [
              _buildInfoRow('Date Of Joining', controller.dateOfJoining),
              _buildInfoRow('Qualification', controller.qualification),
              _buildInfoRow('Work Experience', controller.workExperience),
            ],
          ),

          // ---------- ACTION BUTTONS ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildOutlinedActionButton(
                    label: 'Reset Password',
                    icon: Icons.lock_reset,
                    onPressed: () => RouteManagement.goToStaffResetPassword(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOutlinedActionButton(
                    label: 'Logout',
                    icon: Icons.logout,
                    onPressed: _showLogoutDialog,
                    isDestructive: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ========== BUILD SIBLING ROWS ==========
  // List<Widget> _buildSiblingRows() {
  //   List<Widget> rows = [];
  //   final siblings = controller.siblings!;
  //   for (int i = 0; i < siblings.length; i++) {
  //     final sibling = siblings[i];
  //     // Use sibling.name, sibling.contact, sibling.address
  //     final name = sibling['name'] ?? '--';
  //     final contact = sibling['contact'] ?? '--';
  //     final address = sibling['address'] ?? '--';
  //     rows.add(
  //       Padding(
  //         padding: const EdgeInsets.only(top: 8),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Sibling ${i + 1}',
  //               style: Styles.darkBlcW600.copyWith(
  //                 fontSize: 14,
  //                 color: Colors.blue.shade700,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             _buildInfoRow('  Name', name),
  //             _buildInfoRow('  Contact', contact),
  //             _buildInfoRow('  Address', address),
  //             if (i != siblings.length - 1) const Divider(height: 16),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //   return rows;
  // }

  // ========== OTHER DETAILS CONTENT ==========
  Widget _buildOtherDetailsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          // ---------- EMPLOYMENT DETAILS ----------
          _buildInfoCard(
            title: 'Employment Details',
            children: [
              _buildInfoRow('EPF Number', controller.epfNumber),
              _buildInfoRow('Basic Salary', controller.basicSalary),
              _buildInfoRow('Contract Type', controller.contractType),
              _buildInfoRow('Work Shift', controller.workShift),
              _buildInfoRow('Work Location', controller.workLocation),
            ],
          ),

          // ---------- LEAVE CONFIGURATION ----------
          _buildInfoCard(
            title: 'Leave Configuration',
            children: [
              _buildInfoRow('Paid Leaves', controller.paidLeaves.toString()),
              _buildInfoRow('Half Leaves', controller.halfLeaves.toString()),
              _buildInfoRow(
                  'Full Day Leaves', controller.fullDayLeaves.toString()),
            ],
          ),

          // ---------- BANK ACCOUNT ----------
          _buildInfoCard(
            title: 'Bank Account Information',
            children: [
              _buildInfoRow('Account Title', controller.accountTitle),
              _buildInfoRow('Account Number', controller.accountNumber),
              _buildInfoRow('Bank Name', controller.bankName),
              _buildInfoRow('IFSC Code', controller.ifscCode),
              _buildInfoRow('Branch Name', controller.branchName),
            ],
          ),

          // ---------- SOCIAL MEDIA ----------
          _buildInfoCard(
            title: 'Social Media Profiles',
            children: [
              _buildSocialRow('Facebook URL', controller.facebookUrl),
              _buildSocialRow('Twitter URL', controller.twitterUrl),
              _buildSocialRow('LinkedIn URL', controller.linkedInUrl),
              _buildSocialRow('Instagram URL', controller.instagramUrl),
            ],
          ),

          // ---------- DOCUMENT UPLOADS ----------
          _buildInfoCard(
            title: 'Document Uploads',
            children: [
              _buildDocumentRow(
                label: 'Resume (PDF, DOC)',
                fileName: controller.resumeFileName,
                onTap: () => controller.uploadResume(),
              ),
              _buildDocumentRow(
                label: 'Joining Letter',
                fileName: controller.joiningLetterFileName,
                onTap: () => controller.uploadJoiningLetter(),
              ),
              _buildDocumentRow(
                label: 'Other Documents',
                fileName: controller.otherDocumentsFileName,
                onTap: () => controller.uploadOtherDocuments(),
                isMultiple: true,
              ),
            ],
          ),

          const SizedBox(height: 20),
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
  Widget _buildInfoRow(String label, String value,
      {IconData? icon, Color? iconBgColor, Color? iconColor}) {
    IconData getIcon(String label) {
      if (label.contains('Date') ||
          label.contains('Birth') ||
          label.contains('Joining')) {
        return Icons.calendar_today_outlined;
      } else if (label.contains('Email')) {
        return Icons.email_outlined;
      } else if (label.contains('Contact') ||
          label.contains('Phone') ||
          label.contains('Emergency')) {
        return Icons.phone_outlined;
      } else if (label.contains('Address')) {
        return Icons.location_on_outlined;
      } else if (label.contains('Prefix') ||
          label.contains('Name') ||
          label.contains('Spouse') ||
          label.contains('Mother') ||
          label.contains('Father') ||
          label.contains('Sibling')) {
        return Icons.person_outline;
      } else if (label.contains('Gender')) {
        return Icons.wc;
      } else if (label.contains('Marital')) {
        return Icons.favorite_border;
      } else if (label.contains('Nationality') ||
          label.contains('Religion') ||
          label.contains('Tongue')) {
        return Icons.language;
      } else if (label.contains('Qualification') ||
          label.contains('Experience')) {
        return Icons.school_outlined;
      } else if (label.contains('EPF') ||
          label.contains('Salary') ||
          label.contains('Contract') ||
          label.contains('Shift') ||
          label.contains('Location')) {
        return Icons.work_outline;
      } else if (label.contains('Leave') ||
          label.contains('Paid') ||
          label.contains('Half') ||
          label.contains('Full')) {
        return Icons.calendar_month;
      } else if (label.contains('Account') ||
          label.contains('Bank') ||
          label.contains('IFSC') ||
          label.contains('Branch')) {
        return Icons.account_balance_outlined;
      }
      return Icons.info_outline;
    }

    Color getBgColor(String label) {
      if (label.contains('Email')) return Colors.blue.shade50;
      if (label.contains('Contact') || label.contains('Phone')) {
        return Colors.green.shade50;
      }
      if (label.contains('Address')) return Colors.orange.shade50;
      if (label.contains('Marital') || label.contains('Spouse') ||
          label.contains('Father') || label.contains('Mother') ||
          label.contains('Sibling')) {
        return Colors.pink.shade50;
      }
      if (label.contains('Nationality') || label.contains('Religion')) {
        return Colors.purple.shade50;
      }
      if (label.contains('Leave')) return Colors.teal.shade50;
      if (label.contains('Bank') || label.contains('Account')) {
        return Colors.indigo.shade50;
      }
      return Colors.blue.shade50;
    }

    Color getIconColor(String label) {
      if (label.contains('Email')) return Colors.blue.shade700;
      if (label.contains('Contact') || label.contains('Phone')) {
        return Colors.green.shade700;
      }
      if (label.contains('Address')) return Colors.orange.shade700;
      if (label.contains('Marital') || label.contains('Spouse') ||
          label.contains('Father') || label.contains('Mother') ||
          label.contains('Sibling')) {
        return Colors.pink.shade700;
      }
      if (label.contains('Nationality') || label.contains('Religion')) {
        return Colors.purple.shade700;
      }
      if (label.contains('Leave')) return Colors.teal.shade700;
      if (label.contains('Bank') || label.contains('Account')) {
        return Colors.indigo.shade700;
      }
      return Colors.blue.shade700;
    }

    final iconData = icon ?? getIcon(label);
    final bgColor = iconBgColor ?? getBgColor(label);
    final fgColor = iconColor ?? getIconColor(label);

    // Check if this is a contact field
    final bool isContactField = label.contains('Contact') ||
        label.contains('Phone') ||
        label.contains('Emergency');

    // Trim leading spaces for sibling rows
    final displayLabel = label.trim();

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
                Text(displayLabel, style: Styles.darkBlueW400),
                const SizedBox(height: 2),
                // If contact field and value is valid, make it clickable
                (isContactField && value.isNotEmpty && value != '--')
                    ? GestureDetector(
                  onTap: () => _makePhoneCall(value),
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

  // ========== SOCIAL ROW ==========
  Widget _buildSocialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Styles.darkBlueW400),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '--',
              style: Styles.darkBlcW600,
            ),
          ),
        ],
      ),
    );
  }

  // ========== DOCUMENT ROW ==========
  Widget _buildDocumentRow({
    required String label,
    required String fileName,
    required VoidCallback onTap,
    bool isMultiple = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.darkBlueW400.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  fileName.isNotEmpty ? fileName : 'No file chosen',
                  style: TextStyle(
                    fontSize: 13,
                    color: fileName.isNotEmpty
                        ? Colors.green.shade700
                        : Colors.grey.shade500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.blue.shade700),
                onPressed: onTap,
                tooltip: isMultiple ? 'Upload multiple files' : 'Upload file',
              ),
            ],
          ),
          if (isMultiple)
            Text(
              'Multiple files allowed',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
        ],
      ),
    );
  }

  // ========== OUTLINED ACTION BUTTON ==========
  Widget _buildOutlinedActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDestructive ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDestructive ? Colors.red.shade300 : Colors.blue.shade300,
          width: 1.5,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red.shade700 : Colors.blue.shade700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor:
          isDestructive ? Colors.red.shade700 : Colors.blue.shade700,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          minimumSize: const Size(0, 40),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.logoutAPI(isLoading: true);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}