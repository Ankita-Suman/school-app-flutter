import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class ApplyLeaveScreen extends StatelessWidget {
  ApplyLeaveScreen({super.key});

  final RxList<Map<String, dynamic>> leaveList = RxList<Map<String, dynamic>>([
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
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Fixed background height based on screen size
    final backgroundHeight = screenHeight < 700 ? 150.0 : 170.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                Column(
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
                                child: SvgPicture.asset(
                                    AssetConstants.icBackBg,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Apply Leave', style: Styles.whiteBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildYourAppliedLeavesWidget(),
                    const SizedBox(height: 40),
                  ],
                ),
                Expanded(
                  child: Obx(
                        () => leaveList.isEmpty
                        ? _buildNoDataFoundWidget()
                        : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: leaveList.length,
                      itemBuilder: (context, index) {
                        return _buildLeaveCard(leaveList[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouteManagement.goToAddLeave();
        },
        backgroundColor: ColorsValue.navIconColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildYourAppliedLeavesWidget() {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Applied Leaves!', style: Styles.whiteBold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataFoundWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ColorsValue.cardBorderSkyClr,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              width: 100,
              height: 100,
              AssetConstants.noDataFound,
            ),
          ),
          const SizedBox(height: 16),
          Text('No Data Found!', style: Styles.darkOrangeW70016),
          const SizedBox(height: 6),
          Text(
            'You haven\'t applied for any leaves yet.',
            style: Styles.darkBlackW40014,
          ),
          const SizedBox(height: 2),
          Text(
            'Click the + button below to apply.',
            style: Styles.darkBlackW40014,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> leaveData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorsValue.cardBorderSkyClr,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Apply Date - ${leaveData['applyDate']}',
                      style: Styles.greenW70012,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Edit clicked for ${leaveData['applyDate']}');
                        },
                        child: Icon(Icons.edit_outlined, size: 16, color: Colors.green),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          print('Delete clicked for ${leaveData['applyDate']}');
                          _showDeleteConfirmationDialog(leaveData);
                        },
                        child: Icon(Icons.delete_outline, size: 16, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: ColorsValue.blueColorss.withOpacity(0.3)),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text('From Date', style: Styles.darkGryW600),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: leaveData['status'] == 'Approved'
                              ? Colors.green
                              : leaveData['status'] == 'Pending'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          leaveData['status'] ?? 'Pending',
                          style: Styles.whiteW70009,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text('To Date', style: Styles.darkGryW600),
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
                  const SizedBox(height: 8),
                  Divider(height: 1, thickness: 1, color: Colors.grey),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text('Reason', style: Styles.darkGryW600),
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

  void _showDeleteConfirmationDialog(Map<String, dynamic> leaveData) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Leave', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this leave application?', style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
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
                duration: const Duration(seconds: 2),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}