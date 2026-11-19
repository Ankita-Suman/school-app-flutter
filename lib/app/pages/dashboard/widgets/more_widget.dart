import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../app.dart';
import '../dashboard.dart';

class MoreWidget extends StatelessWidget {
  const MoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.blue.shade700,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
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
                    height: 250,
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
                              const SizedBox(width: 5),
                              Text('Other Options', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
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
                                        style: Styles.whiteBold,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Class ${controller.profileData.value?.personal.classInfo.name ?? '1'} – ${controller.profileData.value?.personal.section.name ?? 'A'} - Session ${controller.profileData.value?.other.academic.session ?? '2025 – 26'}',
                                        style: Styles.whiteW400,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 10),
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
                                              style: Styles.whiteW40011,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                child: const SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      CombinedGridWidget(),
                      SizedBox(height: 20),
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

  // ✅ Avatar Widget with Image/Initials logic and Loader
  Widget _buildAvatar(DashboardController controller) {
    String? photoUrl = controller.profileData.value?.personal.photo;
    String? fullName = controller.profileData.value?.personal.name;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      // ✅ 1. Base URL जोड़ें अगर API से सिर्फ 'uploads/...' आ रहा है
      if (!photoUrl.startsWith('http')) {
        const String baseUrl = 'https://decentgroupofschools.com/';
        photoUrl = '$baseUrl$photoUrl';
      }

      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          // ✅ 2. जब तक इमेज लोड न हो, लोडर दिखाएं
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 70,
              height: 70,
              color: Colors.white.withOpacity(0.2), // हल्का बैकग्राउंड
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
          // ✅ 3. अगर इमेज लोड होने में एरर आए तो इनिशियल्स दिखाएं
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

// ==========================================
// ✅ UPDATED CombinedGridWidget
// ==========================================
class CombinedGridWidget extends StatelessWidget {
  const CombinedGridWidget({super.key});

  // ✅ यहाँ 'icon' में String (SVG पाथ) और IconData (Vector) दोनों को सपोर्ट किया गया है
  final List<Map<String, dynamic>> allMenuItems = const [
    {'icon': AssetConstants.icWork, 'label': 'Home Work'},
    {'icon': AssetConstants.icLsn, 'label': 'Lesson Plan'},
    {'icon': AssetConstants.icPc, 'label': 'Online Exam'},
    {'icon': AssetConstants.icDown, 'label': 'Downloads'},
    {'icon': AssetConstants.icZoom, 'label': 'Zoom Classes'},
    {'icon': AssetConstants.icTime, 'label': 'Time Table'},
    {'icon': AssetConstants.icCourse, 'label': 'Course Status'},
    {'icon': AssetConstants.icAttan, 'label': 'Attendance'},
    {'icon': AssetConstants.icExams, 'label': 'Examinations'},
    {'icon': AssetConstants.icTimeline, 'label': 'Timeline'},
    {'icon': AssetConstants.icDoc, 'label': 'My Documents'},
    {'icon': Icons.people_alt, 'label': 'My Classmates'}, // ✅ नया जोड़ा गया (Index 11)
    {'icon': Icons.account_balance_wallet, 'label': 'Fees'}, // ✅ Index 12
    {'icon': AssetConstants.icApply, 'label': 'Apply Leave'}, // ✅ Index 13
    {'icon': Icons.alt_route, 'label': 'Routes'},
    {'icon': AssetConstants.icTo, 'label': 'To Do List'},
    {'icon': AssetConstants.icLib, 'label': 'Library'},
    {'icon': AssetConstants.icRate, 'label': 'Reviews'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All Features', style: Styles.darkBlkW70014),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: allMenuItems.length,
            itemBuilder: (context, index) {
              final item = allMenuItems[index];
              return _buildMenuItem(
                iconData: item['icon'],
                label: item['label'] as String,
                index: index,
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required dynamic iconData,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 4:
            RouteManagement.goToZoomLiveClasses();
            break;
          case 7:
            RouteManagement.goToAttendanceRecord();
            break;
          case 10:
            RouteManagement.goToStudentDocuments();
            break;
          case 11: // ✅ My Classmates का क्लिक एक्शन
          // ⚠️ सुनिश्चित करें कि RouteManagement में goToMyClassmates नाम का मेथड हो
            RouteManagement.goToMyClassmate();
            break;
          case 12: // ✅ Index 12 पर शिफ्ट हो गया
            RouteManagement.goToFeesDetails();
            break;
          case 13: // ✅ Index 13 पर शिफ्ट हो गया
            RouteManagement.goToApplyLeave();
            break;
          default:
            Get.snackbar('Info', 'Coming Soon');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: ColorsValue.cardBorderSkyClr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsValue.cardBorderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconData is String
                ? SvgPicture.asset(iconData, height: 28, width: 28, fit: BoxFit.contain)
                : Icon(iconData as IconData, size: 28, color: Colors.blue.shade700),

            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: Styles.darkBlkW600013
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}