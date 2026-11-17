import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/app/pages/staff_announcements/staff_announcements_presenter.dart';
import '../../app.dart';
import 'staff_announcements_controller.dart';

class StaffAnnouncementsScreen extends StatelessWidget {
  const StaffAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StaffAnnouncementsController controller = Get.put(
      StaffAnnouncementsController(Get.find<StaffAnnouncementsPresenter>()),
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 100.0 : 130.0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Stack(
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
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset(AssetConstants.icBackBg),
                        ),
                        const SizedBox(width: 8),
                        Text('Staff Announcements', style: Styles.whiteBold),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // ✅ TabBar में onTap जोड़ा गया है
                          Builder(
                              builder: (context) {
                                final TabController tabController = DefaultTabController.of(context);
                                return TabBar(
                                  controller: tabController,
                                  onTap: (index) {
                                    // अगर Other टैब पर क्लिक किया (index 1)
                                    if (index == 1) {
                                      controller.fetchOtherAnnouncements();
                                    }
                                    // अगर My टैब पर क्लिक किया (index 0)
                                    else if (index == 0) {
                                      if(controller.myAnnouncements.isEmpty){
                                        controller.fetchMyAnnouncements();
                                      }
                                    }
                                  },
                                  labelColor: Colors.blue.shade700,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: Colors.blue.shade700,
                                  indicatorWeight: 3,
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: GoogleFonts.sora().fontFamily,
                                  ),
                                  tabs: const [
                                    Tab(text: 'My Announcements'),
                                    Tab(text: 'Other Announcements'),
                                  ],
                                );
                              }
                          ),

                          Expanded(
                            child: TabBarView(
                              children: [
                                // ✅ My Announcements Tab
                                Obx(() {
                                  if (controller.isLoadingMy.value) {
                                    return const Center(child: CircularProgressIndicator(color: Colors.blue));
                                  }
                                  return _buildAnnouncementList(
                                    controller.myAnnouncements,
                                    "No personal announcements found",
                                  );
                                }),
                                // ✅ Other Announcements Tab
                                Obx(() {
                                  if (controller.isLoadingOther.value) {
                                    return const Center(child: CircularProgressIndicator(color: Colors.blue));
                                  }
                                  return _buildAnnouncementList(
                                    controller.otherAnnouncements,
                                    "No other announcements found",
                                  );
                                }),
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
          ],
        ),
      ),
    );
  }

  // ✅ लिस्ट बिल्डर (dynamic का उपयोग किया गया है)
  Widget _buildAnnouncementList(List<dynamic> announcements, String emptyMessage) {
    if (announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontFamily: GoogleFonts.sora().fontFamily),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return _buildAnnouncementCard(announcements[index]);
      },
    );
  }

  // ✅ सिंगल कार्ड का डिज़ाइन (dynamic का उपयोग)
  Widget _buildAnnouncementCard(dynamic item) {
    Color cardColor = Colors.blue;
    IconData cardIcon = Icons.campaign;

    // Notice Type के हिसाब से रंग
    String noticeType = item.noticeType ?? 'NOTICE';
    if (noticeType == 'INDIVIDUAL') {
      cardColor = Colors.orange;
      cardIcon = Icons.person;
    } else if (noticeType == 'GROUP') {
      cardColor = Colors.blue;
      cardIcon = Icons.groups;
    }

    // डेट फॉर्मेट
    String dateStr = item.noticeDate ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 110,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(cardIcon, size: 18, color: cardColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          noticeType,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: cardColor),
                        ),
                      ),
                      Text(
                        dateStr,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: GoogleFonts.sora().fontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message ?? 'No description available.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                      fontFamily: GoogleFonts.sora().fontFamily,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}