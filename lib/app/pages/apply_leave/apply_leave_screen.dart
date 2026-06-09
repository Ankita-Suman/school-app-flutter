import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class ApplyLeaveScreen extends StatelessWidget {
  ApplyLeaveScreen({super.key});

  // Sample leave data - Jab data hoga tab ye show hoga
  final RxList<Map<String, dynamic>> leaveList = RxList<Map<String, dynamic>>([
    //Comment out this data to see "No Data Found" UI
    {
      'applyDate': '05/06/2026',
      'fromDate': '05/06/2026',
      'toDate': '05/08/2026',
      'reason': 'urgent leaves',
      'status': 'Pending',
    },
  ]);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Responsive SVG Background
          SizedBox(
            width: screenWidth,
            height: isTablet ? 180 : (isSmallPhone ? 130 : 150),
            child: SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: screenWidth,
              height: isTablet ? 180 : (isSmallPhone ? 130 : 150),
              fit: BoxFit.fill,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Fixed Header Section
                Column(
                  children: [
                    SizedBox(height: isTablet ? 20 : 15),
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: SvgPicture.asset(
                                  AssetConstants.icBackBg,
                                  // width: isTablet ? 28 : 24,
                                  // height: isTablet ? 28 : 24,
                                ),
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              Text('Apply Leave', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 5),

                    // Your Applied Leaves Widget
                    _buildYourAppliedLeavesWidget(isTablet, isSmallPhone),

                    SizedBox(height: isTablet ? 50 : 40),
                  ],
                ),

                // Leave List or No Data Found
                Expanded(
                  child: Obx(
                        () => leaveList.isEmpty
                        ? _buildNoDataFoundWidget(isTablet, isSmallPhone)
                        : ListView.builder(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      itemCount: leaveList.length,
                      itemBuilder: (context, index) {
                        return _buildLeaveCard(leaveList[index], isTablet, isSmallPhone);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Add Button - Floating Action Button - Responsive
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouteManagement.goToAddLeave();
        },
        backgroundColor: ColorsValue.navIconColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: isTablet ? 32 : 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Your Applied Leaves Widget - Responsive
  Widget _buildYourAppliedLeavesWidget(bool isTablet, bool isSmallPhone) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Applied Leaves!',
                style: Styles.whiteBold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // No Data Found Widget - Responsive
  Widget _buildNoDataFoundWidget(bool isTablet, bool isSmallPhone) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // No Data Icon
          Container(
            width: isTablet ? 140 : 100,
            height: isTablet ? 140 : 100,
            decoration: BoxDecoration(
              color: ColorsValue.cardBorderSkyClr,
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            ),
            child: SvgPicture.asset(
              width: isTablet ? 170 : 130,
              height: isTablet ? 170 : 130,
              AssetConstants.noDataFound,
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),
          // No Data Found Text
          Text(
            'No Data Found!',
            style: Styles.darkOrangeW70016,
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'You haven\'t applied for any leaves yet.',
            style: Styles.darkBlackW40014,
          ),
          SizedBox(height: isTablet ? 5 : 3),
          Text(
            'Click the + button below to apply.',
            style: Styles.darkBlackW40014,
          ),
        ],
      ),
    );
  }

  // Leave Card Widget - Responsive with original styles
  Widget _buildLeaveCard(Map<String, dynamic> leaveData, bool isTablet, bool isSmallPhone) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: ColorsValue.cardBorderSkyClr,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Apply Date with Edit and Delete Icons
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Apply Date Text
                  Expanded(
                    child: Text(
                      'Apply Date - ${leaveData['applyDate']}',
                      style: Styles.greenW70012,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Edit and Delete Icons
                  Row(
                    children: [
                      // Edit Icon
                      GestureDetector(
                        onTap: () {
                          print('Edit clicked for ${leaveData['applyDate']}');
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          size: isTablet ? 22 : 18,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      // Delete Icon
                      GestureDetector(
                        onTap: () {
                          print('Delete clicked for ${leaveData['applyDate']}');
                          _showDeleteConfirmationDialog(leaveData);
                        },
                        child: Icon(
                          Icons.delete_outline,
                          size: isTablet ? 22 : 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),

            // Content Section - From Date, To Date, Reason
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // From Date Row with Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // From Date Text
                      Flexible(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isTablet ? 100 : 80,
                              child: Text(
                                'From Date',
                                style: Styles.darkGryW600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                leaveData['fromDate'],
                                style: Styles.darkBlkW70013,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status Container
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 12,
                          vertical: isTablet ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: leaveData['status'] == 'Approved'
                              ? Colors.green
                              : leaveData['status'] == 'Pending'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          leaveData['status'] ?? 'Pending',
                          style: Styles.whiteW70009,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),

                  // To Date Row
                  Row(
                    children: [
                      SizedBox(
                        width: isTablet ? 100 : 80,
                        child: Text(
                          'To Date',
                          style: Styles.darkGryW600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          leaveData['toDate'],
                          style: Styles.darkBlkW70013,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),

                  // Divider
                  Divider(height: 1, thickness: 1, color: Colors.grey),
                  SizedBox(height: isTablet ? 16 : 12),

                  // Reason Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: isTablet ? 100 : 80,
                        child: Text(
                          'Reason',
                          style: Styles.darkGryW600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          leaveData['reason'],
                          style: Styles.darkBlkW70013,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete Confirmation Dialog - Responsive
  void _showDeleteConfirmationDialog(Map<String, dynamic> leaveData) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Leave',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this leave application?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Deleted',
                'Leave application deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}