import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app.dart';
import '../dashboard_controller.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    });

    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.navBgColors,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetConstants.icBlueBg,
                    width: screenWidth,
                    height: 360,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.blue.shade300,
                                              width: 2,
                                            ),
                                          ),
                                          child: _buildAvatar(controller),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                AssetConstants.iccEdit,
                                                height: 18,
                                                width: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.profileData.value
                                                    ?.personal.name ??
                                                'Olivier Thomas',
                                            style: Styles.whiteBold
                                                .copyWith(fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Class ${controller.profileData.value?.personal.classInfo.name ?? '1'} – ${controller.profileData.value?.personal.section.name ?? 'A'} - Session ${controller.profileData.value?.other.academic.session ?? '2025 – 26'}',
                                            style: Styles.whiteW400
                                                .copyWith(fontSize: 12),
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Adm. No. ${controller.profileData.value?.personal.admissionNumber ?? '18001'}',
                                                  style: Styles.whiteW40011
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Roll. No. ${controller.profileData.value?.personal.rollNumber ?? '18001'}',
                                                  style: Styles.whiteW40011
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('QR CODE',
                                            style: Styles.whiteW60010
                                                .copyWith(fontSize: 10)),
                                        const SizedBox(height: 5),
                                        SvgPicture.asset(
                                          AssetConstants.icQr,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 40),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('CREDIT SCORE',
                                            style: Styles.whiteW60010
                                                .copyWith(fontSize: 10)),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                AssetConstants.progressBar,
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.contain,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${controller.profileData.value?.other.grade.averagePercentage ?? 0}',
                                                    style: Styles.whiteExBold
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                  Text('/100',
                                                      style: Styles.whiteW40009
                                                          .copyWith(
                                                              fontSize: 10)),
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
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: TabBar(
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
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Avatar Widget with Image/Initials logic
  Widget _buildAvatar(DashboardController controller) {
    String? photoUrl = controller.profileData.value?.personal.photo;
    String? fullName = controller.profileData.value?.personal.name;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar(fullName);
          },
        ),
      );
    }

    return _buildInitialsAvatar(fullName);
  }

  Widget _buildInitialsAvatar(String? fullName) {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        color: ColorsValue.bgColors,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(fullName),
          style: Styles.whiteBold.copyWith(fontSize: 22),
        ),
      ),
    );
  }

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'AS';

    List<String> parts = fullName.trim().split(' ');

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    String first = parts[0][0].toUpperCase();
    String last = parts[parts.length - 1][0].toUpperCase();
    return '$first$last';
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
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                const SizedBox(width: 6),
                Text('Print ID Card', style: Styles.darkBlueW700),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailsContainer(
            title: 'PERSONAL DETAILS',
            index: 0,
            children: [
              _buildDetailRow(
                  'Date of Birth', _formatDate(personal?.dateOfBirth)),
              _buildDetailRow('Gender', personal?.gender ?? '-'),
              _buildDetailRow('Category', '-'),
              _buildDetailRow('Blood Group', personal?.bloodGroup ?? '-'),
              _buildDetailRow('Religion', personal?.religion ?? '-'),
              _buildDetailRow('Height/Weight', '4.5 · 40 kg'),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailsContainer(
            title: 'CONTACT INFO',
            index: 1,
            children: [
              _buildDetailRow('Mobile', personal?.contact.email ?? '-'),
              _buildDetailRow('Email', personal?.contact.email ?? '-'),
            ],
          ),
          const SizedBox(height: 10),
          _buildAddressContainer(
            title: 'ADDRESS',
            index: 2,
            currentAddress: personal?.address.current ?? '-',
            permanentAddress: personal?.address.permanent ?? '-',
          ),
          const SizedBox(height: 20),
          _buildLogoutContainer(controller),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildLogoutContainer(DashboardController controller) {
    return GestureDetector(
      onTap: () {
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
                  Get.back();
                  controller.logoutAPI(isLoading: true);
                },
                child:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorsValue.cardBorderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.red.shade700,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'LOGOUT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
                fontFamily: GoogleFonts.sora().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
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
                    index == 0
                        ? AssetConstants.icDm
                        : index == 1
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
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorsValue.cardBorderColor),
                ],
              )),
        ],
      ),
    );
  }

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
          const Divider(
              height: 1, thickness: 1, color: ColorsValue.cardBorderColor),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildParentCard(
            initials: _getInitials(parents?.father.name ?? ''),
            name: parents?.father.name ?? '-',
            occupation: parents?.father.occupation ?? '-',
            relation: 'FATHER',
            phoneNumber: parents?.father.phone ?? '-',
            index: 0,
          ),
          const SizedBox(height: 16),
          _buildParentCard(
            initials: _getInitials(parents?.mother.name ?? ''),
            name: parents?.mother.name ?? '-',
            occupation: parents?.mother.occupation ?? '-',
            relation: 'MOTHER',
            phoneNumber: parents?.mother.phone ?? '-',
            index: 1,
          ),
          _buildParentCard(
            initials: _getInitials(parents?.guardian.name ?? ''),
            name: parents?.guardian.name ?? '-',
            occupation: parents?.guardian.occupation ?? '-',
            relation: parents?.guardian.relation ?? 'GUARDIAN',
            phoneNumber: parents?.guardian.phone ?? '-',
            index: 2,
          ),
        ],
      ),
    );
  }

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

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallPhone = screenWidth < 360;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Stats Cards Grid - Smaller height boxes
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
              childAspectRatio:
                  1.6, // ✅ Much shorter boxes (more width, less height)
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildStatCard(
                    svgIcon: AssetConstants.icDmm,
                    value: '${other?.attendance.percentage ?? 0}%',
                    label: 'Attendance',
                    valueColor: Colors.green.shade700,
                    isSmallPhone: isSmallPhone,
                  );
                case 1:
                  return _buildStatCard(
                    svgIcon: AssetConstants.icStar,
                    value: other?.grade.grade ?? 'N/A',
                    label: 'Last Result',
                    valueColor: ColorsValue.txtGreenClrs,
                    isSmallPhone: isSmallPhone,
                  );
                case 2:
                  return _buildStatCard(
                    svgIcon: AssetConstants.icHeart,
                    value: '5/5',
                    label: 'Behaviour',
                    valueColor: ColorsValue.lightBorderOrangeColor,
                    isSmallPhone: isSmallPhone,
                  );
                case 3:
                  return _buildStatCard(
                    svgIcon: AssetConstants.icHwork,
                    value: other?.library.isMember == true ? 'Yes' : 'No',
                    label: 'Library Member',
                    valueColor: ColorsValue.lightPurpleClrs,
                    isSmallPhone: isSmallPhone,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),

          const SizedBox(height: 12),

          _buildDetailsContainer(
            title: 'ACADEMIC INFO',
            index: 0,
            children: [
              _buildDetailRow('Class & Section',
                  '${other?.academic.classInfo ?? personal?.classInfo.name ?? '-'} - ${other?.academic.section ?? personal?.section.name ?? '-'}'),
              _buildDetailRow('Roll Number', personal?.rollNumber ?? '-'),
              _buildDetailRow(
                  'Admission No.', personal?.admissionNumber ?? '-'),
              _buildDetailRow('Session', other?.academic.session ?? '-'),
              _buildDetailRow(
                  'Admission Type', other?.academic.admissionType ?? '-'),
            ],
          ),

          const SizedBox(height: 10),

          _buildDetailsContainer(
            title: 'TRANSPORT',
            index: 2,
            children: [
              _buildDetailRow('Transport Registered',
                  other?.transport.isRegistered == true ? 'Yes' : 'No'),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ✅ Stat Card - Same icon/text size, smaller box height
  Widget _buildStatCard({
    required String svgIcon,
    required String value,
    required String label,
    required Color valueColor,
    required bool isSmallPhone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      // ✅ Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(svgIcon, height: 28, width: 28), // ✅ Same icon size
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.sora().fontFamily,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: SvgPicture.asset(
                      index == 0
                          ? AssetConstants.icAca
                          : index == 1
                              ? AssetConstants.icHrt
                              : AssetConstants.icTrans,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: Styles.darkBlueW700.copyWith(fontSize: 11),
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
              int idx = entry.key;
              Widget child = entry.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  if (idx != children.length - 1)
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorsValue.cardBorderColor),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Styles.darkGryW500.copyWith(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: Styles.darkBlkW500.copyWith(fontSize: 11),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
