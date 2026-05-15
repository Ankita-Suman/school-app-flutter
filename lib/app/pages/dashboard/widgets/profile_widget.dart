import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app.dart';
import '../dashboard_controller.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<DashboardController>(
        builder: (controller) =>Scaffold(
      backgroundColor: ColorsValue.navBgColors,
      body: SafeArea(
        child: Column(
          children: [
            // ========== FIXED HEADER SECTION (Non-scrollable) ==========
            Stack(
              children: [
                // SVG Background Image
                SvgPicture.asset(
                  AssetConstants.icBlueBg,
                  width: MediaQuery.of(context).size.width,
                  height: 330,
                  fit: BoxFit.cover,
                ),
                // Content on top of SVG
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  AssetConstants.icBackBg,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(StringConstants.studentProfile,
                                  style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Obx(() => Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.blue.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: controller.profileData.value?.personal?.photo != null
                                            ? Image.network(
                                          controller.profileData.value!.personal!.photo!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              AssetConstants.userImage,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            );
                                          },
                                        )
                                            : Image.asset(
                                          AssetConstants.userImage,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                          AssetConstants.iccEdit,
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.profileData.value?.personal?.name ?? 'Olivier Thomas',
                                      style: Styles.whiteBold,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Class ${controller.profileData.value?.personal?.classInfo?.name ?? '1'} – ${controller.profileData.value?.personal?.section?.name ?? 'A'} - Session ${controller.profileData.value?.other?.academic?.session ?? '2025 – 26'}',
                                      style: Styles.whiteW400,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Adm. No. ${controller.profileData.value?.personal?.admissionNumber ?? '18001'}',
                                            style: Styles.whiteW40011,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Roll. No. ${controller.profileData.value?.personal?.rollNumber ?? '18001'}',
                                            style: Styles.whiteW40011,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Divider(
                                thickness: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('QR CODE',
                                        style: Styles.whiteW60010),
                                    const SizedBox(height: 5),
                                    SvgPicture.asset(
                                      AssetConstants.icQr,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 40),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('CREDIT SCORE',
                                        style: Styles.whiteW60010),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AssetConstants.progressBar,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.contain,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${controller.profileData.value?.other?.grade?.averagePercentage ?? 0}',
                                                style: Styles.whiteExBold,
                                              ),
                                              Text('/100',
                                                  style: Styles.whiteW40009),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ========== SCROLLABLE TABS SECTION ==========
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    // Fixed Tab Bar
                    Container(
                      color: ColorsValue.navBgColors,
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child:  TabBar(
                              tabs: const [
                                Tab(text: 'Personal'),
                                Tab(text: 'Parents'),
                                Tab(text: 'Other'),
                              ],
                              labelColor: ColorsValue.navIconColor,
                              unselectedLabelColor: Colors.grey,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: Styles.darkBlueW700,
                              unselectedLabelStyle: Styles.darkBlackW700,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    // Scrollable TabBarView
                    const Expanded(
                      child: TabBarView(
                        children: [
                          PersonalTab(),
                          ParentsTab(),
                          OtherTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        ));
  }
}

// ========== PERSONAL TAB ==========
class PersonalTab extends StatelessWidget {
  const PersonalTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final personal = controller.profileData.value?.personal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Print ID Card Section
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsValue.cardBorderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetConstants.icPrint,
                  height: 10,
                  width: 10,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Text('Print ID Card', style: Styles.darkBlueW700),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Personal Details Container
          _buildDetailsContainer(
            title: 'PERSONAL DETAILS',
            index: 0,
            children: [
              _buildDetailRow('Date of Birth', _formatDate(personal?.dateOfBirth),),
              _buildDetailRow('Gender', personal?.gender ?? '-'),
              _buildDetailRow('Category', /*personal?.gender*/ /*??*/ '-'),
              _buildDetailRow('Blood Group', personal?.bloodGroup ?? '-'),
              _buildDetailRow('Religion', personal?.religion ?? '-'),
              _buildDetailRow('Height/Weight', '4.5 · 40 kg'),
            ],
          ),

          const SizedBox(height: 10),

          // Contact Info Container
          _buildDetailsContainer(
            title: 'CONTACT INFO',
            index: 1,
            children: [
              _buildDetailRow('Mobile', personal?.contact?.email ?? '-'),
              _buildDetailRow('Email', personal?.contact?.email ?? '-'),
            ],
          ),

          const SizedBox(height: 10),

          // Address Container - Fixed for multi-line
          _buildAddressContainer(
            title: 'ADDRESS',
            index: 2,
            currentAddress: personal?.address?.current ?? '-',
            permanentAddress: personal?.address?.permanent ?? '-',
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day} ${_getMonth(parsedDate.month)} ${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildDetailsContainer({
    required String title,
    required List<Widget> children,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsValue.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsValue.cardBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    index == 0 ? AssetConstants.icDm : index == 1
                        ? AssetConstants.icCall
                        : AssetConstants.icAdd,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: Styles.darkBlueW700),
                ],
              ),
            ),
          ),
          ...children.map((child) => Column(
            children: [
              child,
              if (child != children.last)
                const Divider(height: 1, thickness: 1, color: ColorsValue.cardBorderColor),
            ],
          )),
        ],
      ),
    );
  }

  // ✅ New method for Address with multi-line support
  Widget _buildAddressContainer({
    required String title,
    required int index,
    required String currentAddress,
    required String permanentAddress,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsValue.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsValue.cardBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetConstants.icAdd,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: Styles.darkBlueW700),
                ],
              ),
            ),
          ),
          // Current Address Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'Current',
                    style: Styles.darkGryW500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentAddress,
                    style: Styles.darkBlkW500,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: ColorsValue.cardBorderColor),
          // Permanent Address Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'Permanent',
                    style: Styles.darkGryW500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    permanentAddress,
                    style: Styles.darkBlkW500,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Styles.darkGryW500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Styles.darkBlkW500,
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== PARENTS TAB ==========
class ParentsTab extends StatelessWidget {
  const ParentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final parents = controller.profileData.value?.parents;

    return SingleChildScrollView(  // ✅ Add this wrapper
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Father Card
          _buildParentCard(
            initials: _getInitials(parents?.father?.name ?? ''),
            name: parents?.father?.name ?? '-',
            occupation: parents?.father?.occupation ?? '-',
            relation: 'FATHER',
            phoneNumber: parents?.father?.phone ?? '-',
            index: 0,
          ),
          const SizedBox(height: 16),
          // Mother Card
          _buildParentCard(
            initials: _getInitials(parents?.mother?.name ?? ''),
            name: parents?.mother?.name ?? '-',
            occupation: parents?.mother?.occupation ?? '-',
            relation: 'MOTHER',
            phoneNumber: parents?.mother?.phone ?? '-',
            index: 1,
          ),
          // Guardian Card
          _buildParentCard(
            initials: _getInitials(parents?.guardian?.name ?? ''),
            name: parents?.guardian?.name ?? '-',
            occupation: parents?.guardian?.occupation ?? '-',
            relation: parents?.guardian?.relation ?? 'GUARDIAN',
            phoneNumber: parents?.guardian?.phone ?? '-',
            index: 2,
          ),
        ],
      ),
    );
  }

  // Rest of the methods remain exactly the same...
  String _getInitials(String name) {
    if (name.isEmpty || name == '-') return 'NA';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.substring(0, 2).toUpperCase();
  }

  Widget _buildParentCard({
    required String initials,
    required String name,
    required String occupation,
    required String relation,
    required String phoneNumber,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsValue.cardBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? ColorsValue.bgBlueColors
                        : index == 1
                        ? ColorsValue.txtPinkClrs
                        : ColorsValue.txtGrClrs,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: Styles.whiteExBold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relation,
                        style: index == 0
                            ? Styles.darkBlueW700Spacing
                            : index == 1
                            ? Styles.darkPinkW70010
                            : Styles.darkGrW700,
                      ),
                      Text(
                        name,
                        style: Styles.darkBlcW700,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        occupation,
                        style: index == 0
                            ? Styles.darkBlueW600
                            : index == 1
                            ? Styles.darkPinkW600
                            : Styles.darkGrW600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetConstants.icCl,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phoneNumber,
                        style: Styles.darkBlkW500,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phone Number',
                        style: Styles.darkGryW400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetConstants.icAdd,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        occupation,
                        style: Styles.darkBlkW500,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Occupation',
                        style: Styles.darkGryW400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== OTHER TAB ==========
class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final other = controller.profileData.value?.other;
    final personal = controller.profileData.value?.personal;

    return SingleChildScrollView(  // ✅ Add this wrapper
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              _buildStatCard(
                index: 0,
                svgIcon: AssetConstants.icDmm,
                value: '${other?.attendance?.percentage ?? 0}%',
                label: 'Attendance',
                iconColor: Colors.green.shade600,
                valueColor: Colors.green.shade700,
                labelColor: Colors.green.shade600,
                bgColor: Colors.green.shade50,
              ),
              _buildStatCard(
                index: 1,
                svgIcon: AssetConstants.icStar,
                value: other?.grade?.grade ?? 'N/A',
                label: 'Last Result',
                iconColor: Colors.orange.shade600,
                valueColor: ColorsValue.txtGreenClrs,
                labelColor: Colors.orange.shade600,
                bgColor: Colors.orange.shade50,
              ),
              _buildStatCard(
                index: 2,
                svgIcon: AssetConstants.icHeart,
                value: '5/5',
                label: 'Behaviour',
                iconColor: Colors.purple.shade600,
                valueColor: ColorsValue.lightBorderOrangeColor,
                labelColor: Colors.purple.shade600,
                bgColor: Colors.purple.shade50,
              ),
              _buildStatCard(
                index: 3,
                svgIcon: AssetConstants.icHwork,
                value: other?.library?.isMember == true ? 'Yes' : 'No',
                label: 'Library Member',
                iconColor: Colors.red.shade600,
                valueColor: ColorsValue.lightPurpleClrs,
                labelColor: Colors.red.shade600,
                bgColor: Colors.red.shade50,
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildDetailsContainer(
            title: 'ACADEMIC INFO',
            index: 0,
            children: [
              _buildDetailRow('Class & Section', '${other?.academic?.classInfo ?? personal?.classInfo?.name ?? '-'} - ${other?.academic?.section ?? personal?.section?.name ?? '-'}'),
              _buildDetailRow('Roll Number', personal?.rollNumber ?? '-'),
              _buildDetailRow('Admission No.', personal?.admissionNumber ?? '-'),
              _buildDetailRow('Session', other?.academic?.session ?? '-'),
              _buildDetailRow('Admission Type', other?.academic?.admissionType ?? '-'),
            ],
          ),

          const SizedBox(height: 12),

          _buildDetailsContainer(
            title: 'TRANSPORT',
            index: 2,
            children: [
              _buildDetailRow('Transport Registered', other?.transport?.isRegistered == true ? 'Yes' : 'No'),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Rest of the methods remain exactly the same...
  Widget _buildStatCard({
    required int index,
    required String svgIcon,
    required String value,
    required String label,
    required Color iconColor,
    required Color valueColor,
    required Color labelColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(svgIcon),
          const SizedBox(height: 12),
          index == 0
              ? Text(value, style: Styles.darkBlcW70020)
              : Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.sora().fontFamily,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContainer({
    required String title,
    required List<Widget> children,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsValue.cardBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset(
                      index == 0
                          ? AssetConstants.icAca
                          : index == 1
                          ? AssetConstants.icHrt
                          : AssetConstants.icTrans,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Styles.darkBlueW700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: children.asMap().entries.map((entry) {
              int index = entry.key;
              Widget child = entry.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  if (index != children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: ColorsValue.cardBorderColor,
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Styles.darkGryW500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: Styles.darkBlkW500,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}