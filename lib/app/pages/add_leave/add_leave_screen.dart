import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'add_leave_controller.dart';

class AddLeaveScreen extends StatelessWidget {
  const AddLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddLeaveController controller = Get.put(AddLeaveController());

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
                  ],
                ),
                SizedBox(height: isTablet ? 40 : 30),

                // Add Leave Form with Flexible
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Apply Date Field
                        Padding(
                          padding: EdgeInsets.all(isTablet ? 20 : 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('APPLY DATE', style: Styles.darkGryW700),
                              SizedBox(height: isTablet ? 8 : 5),
                              Obx(
                                    () => Container(
                                  decoration: BoxDecoration(
                                    color: controller.isApplyDateFocused.value
                                        ? Colors.white
                                        : (controller.applyDate.value.isNotEmpty
                                        ? Colors.blue.shade50
                                        : Colors.grey.shade50),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: (controller.isApplyDateFocused.value || controller.applyDate.value.isNotEmpty)
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade300,
                                      width: (controller.isApplyDateFocused.value || controller.applyDate.value.isNotEmpty) ? 1.5 : 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => controller.selectApplyDate(context),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 15 : 10, vertical: isTablet ? 16 : 12),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: isTablet ? 22 : 18,
                                            color: (controller.isApplyDateFocused.value || controller.applyDate.value.isNotEmpty)
                                                ? Colors.blue.shade700
                                                : Colors.grey.shade500,
                                          ),
                                          SizedBox(width: isTablet ? 12 : 8),
                                          Obx(() => Text(
                                            controller.applyDate.value.isEmpty ? 'Select Date' : controller.applyDate.value,
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                              fontWeight: FontWeight.w500,
                                              color: controller.applyDate.value.isEmpty ? Colors.grey : Colors.black87,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // From Date and To Date in Row
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isTablet ? 20 : 16,
                              isTablet ? 12 : 8,
                              isTablet ? 20 : 16,
                              isTablet ? 20 : 16
                          ),
                          child: Row(
                            children: [
                              // From Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('FROM DATE', style: Styles.darkGryW600),
                                    SizedBox(height: isTablet ? 6 : 4),
                                    Obx(
                                          () => GestureDetector(
                                        onTap: () {
                                          controller.fromDateFocusNode.requestFocus();
                                          controller.selectFromDate(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12, horizontal: isTablet ? 12 : 8),
                                          decoration: BoxDecoration(
                                            color: controller.isFromDateFocused.value
                                                ? Colors.white
                                                : (controller.fromDate.value.isNotEmpty
                                                ? Colors.blue.shade50
                                                : Colors.grey.shade50),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: (controller.isFromDateFocused.value || controller.fromDate.value.isNotEmpty)
                                                  ? Colors.blue.shade700
                                                  : Colors.grey.shade300,
                                              width: (controller.isFromDateFocused.value || controller.fromDate.value.isNotEmpty) ? 1.5 : 1,
                                            ),
                                          ),
                                          child: Obx(() => Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: isTablet ? 22 : 18,
                                                color: (controller.isFromDateFocused.value || controller.fromDate.value.isNotEmpty)
                                                    ? Colors.blue.shade700
                                                    : Colors.grey.shade500,
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Text(
                                                controller.fromDate.value.isEmpty ? 'From Date' : controller.fromDate.value,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 16 : 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: controller.fromDate.value.isEmpty ? Colors.grey : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: isTablet ? 24 : 16),
                              // To Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TO DATE', style: Styles.darkGryW600),
                                    SizedBox(height: isTablet ? 6 : 4),
                                    Obx(
                                          () => GestureDetector(
                                        onTap: () {
                                          controller.toDateFocusNode.requestFocus();
                                          controller.selectToDate(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12, horizontal: isTablet ? 12 : 8),
                                          decoration: BoxDecoration(
                                            color: controller.isToDateFocused.value
                                                ? Colors.white
                                                : (controller.toDate.value.isNotEmpty
                                                ? Colors.blue.shade50
                                                : Colors.grey.shade50),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: (controller.isToDateFocused.value || controller.toDate.value.isNotEmpty)
                                                  ? Colors.blue.shade700
                                                  : Colors.grey.shade300,
                                              width: (controller.isToDateFocused.value || controller.toDate.value.isNotEmpty) ? 1.5 : 1,
                                            ),
                                          ),
                                          child: Obx(() => Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: isTablet ? 22 : 18,
                                                color: (controller.isToDateFocused.value || controller.toDate.value.isNotEmpty)
                                                    ? Colors.blue.shade700
                                                    : Colors.grey.shade500,
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Text(
                                                controller.toDate.value.isEmpty ? 'To Date' : controller.toDate.value,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 16 : 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: controller.toDate.value.isEmpty ? Colors.grey : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Reason Field
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isTablet ? 20 : 16,
                              isTablet ? 12 : 8,
                              isTablet ? 20 : 16,
                              isTablet ? 20 : 16
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('REASON FOR LEAVE', style: Styles.darkGryW600),
                              SizedBox(height: isTablet ? 6 : 4),
                              Obx(
                                    () => TextField(
                                  controller: controller.reasonController,
                                  focusNode: controller.reasonFocusNode,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  onSubmitted: (_) {
                                    controller.reasonFocusNode.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter reason for leave',
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: isTablet ? 14 : 12),
                                    filled: true,
                                    fillColor: controller.isReasonFocused.value
                                        ? Colors.white
                                        : (controller.reasonController.text.isNotEmpty
                                        ? Colors.blue.shade50
                                        : Colors.grey.shade50),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller.isReasonFocused.value || controller.reasonController.text.isNotEmpty
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade300,
                                        width: (controller.isReasonFocused.value || controller.reasonController.text.isNotEmpty) ? 1.5 : 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: controller.isReasonFocused.value || controller.reasonController.text.isNotEmpty
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade300,
                                        width: (controller.isReasonFocused.value || controller.reasonController.text.isNotEmpty) ? 1.5 : 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                                    ),
                                    contentPadding: EdgeInsets.all(isTablet ? 16 : 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ File Upload Section - Responsive
                        _buildFileUploadSection(controller, isTablet, isSmallPhone,context),

                        SizedBox(height: isTablet ? 32 : 24),

                        // Submit Button - Responsive
                        Obx(
                              () => Opacity(
                            opacity: controller.isFormValid.value ? 1.0 : 0.5,
                            child: SizedBox(
                              width: double.infinity,
                              height: isTablet ? 60 : 50,
                              child: GradientButton(
                                onPressed: controller.isFormValid.value && !controller.isLoading.value
                                    ? () {
                                  FocusScope.of(context).unfocus();
                                  controller.submitLeave(context);
                                }
                                    : () {},
                                text: controller.isLoading.value ? 'Submitting...' : 'Submit Leave',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 40 : 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Responsive File Upload Section with Square Dot Border
// ✅ Responsive File Upload Section with Square Dot Border - FIXED
  Widget _buildFileUploadSection(AddLeaveController controller, bool isTablet, bool isSmallPhone, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
          isTablet ? 20 : 16,
          isTablet ? 12 : 8,
          isTablet ? 20 : 16,
          isTablet ? 20 : 16
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
        color: Colors.blue.shade200,
        strokeWidth: isTablet ? 2 : 1.5,
        dashPattern: isTablet ? [10, 8] : [8, 6],
        child: Container(
          padding: EdgeInsets.all(isTablet ? 30 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SVG Image
                SvgPicture.asset(
                  AssetConstants.icUpload,
                  height: isTablet ? 70 : 50,
                  width: isTablet ? 70 : 50,
                ),
                SizedBox(height: isTablet ? 16 : 12),

                // Text
                Text(
                  'Select File to Upload',
                  style: Styles.darkBlackW40012,
                ),
                SizedBox(height: isTablet ? 12 : 8),

                // ✅ File name display - FIXED with Expanded
                Obx(() => controller.selectedFileName.value.isNotEmpty
                    ? Container(
                  constraints: BoxConstraints(
                    maxWidth: (isTablet ? 500 : MediaQuery.of(context).size.width - (isTablet ? 140 : 100)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12, vertical: isTablet ? 8 : 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: isTablet ? 20 : 16, color: Colors.green.shade600),
                      SizedBox(width: isTablet ? 12 : 8),
                      Flexible(
                        child: Text(
                          controller.selectedFileName.value,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.green.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
                ),
                SizedBox(height: isTablet ? 16 : 12),

                // Choose File Button - Responsive
                ElevatedButton.icon(
                  onPressed: () => controller.pickFile(),
                  icon: Icon(Icons.cloud_upload, size: isTablet ? 22 : 18),
                  label: Text(
                    'Choose File',
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsValue.blcColors,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 30 : 20,
                      vertical: isTablet ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildYourAppliedLeavesWidget(bool isTablet, bool isSmallPhone) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Leave from here!', style: Styles.whiteBold),
            ],
          ),
        ],
      ),
    );
  }
}