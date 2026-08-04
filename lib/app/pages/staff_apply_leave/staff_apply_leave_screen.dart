import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'staff_apply_leave_controller.dart';

class StaffApplyLeaveScreen extends StatelessWidget {
  const StaffApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StaffApplyLeaveController controller =
        Get.put(StaffApplyLeaveController());

    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Fixed background height based on screen size
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;
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
                    // ✅ Fixed spacing
                    const SizedBox(height: 20),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeaveTypeDropdown(controller),
                        //_buildApplyDateField(controller, context),
                        _buildDateRangeFields(controller, context),
                        _buildReasonField(controller),
                        _buildFileUploadSection(controller, context),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildSubmitButton(controller, context),
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD LEAVE TYPE DROPDOWN ==========
  Widget _buildLeaveTypeDropdown(StaffApplyLeaveController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Leave Type', style: Styles.darkGryW700),
          const SizedBox(height: 5),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: controller.isLeaveTypeFocused.value
                    ? Colors.white
                    : (controller.selectedLeaveType.value.isNotEmpty
                        ? Colors.blue.shade50
                        : Colors.grey.shade50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (controller.isLeaveTypeFocused.value ||
                          controller.selectedLeaveType.value.isNotEmpty)
                      ? Colors.blue.shade700
                      : Colors.grey.shade300,
                  width: (controller.isLeaveTypeFocused.value ||
                          controller.selectedLeaveType.value.isNotEmpty)
                      ? 1.5
                      : 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedLeaveType.value.isNotEmpty
                      ? controller.selectedLeaveType.value
                      : null,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: Text(
                      'Select Leave Type',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: controller.selectedLeaveType.value.isNotEmpty
                          ? Colors.blue.shade700
                          : Colors.grey.shade500,
                      size: 24,
                    ),
                  ),
                  items: controller.leaveTypes.map((String leaveType) {
                    return DropdownMenuItem<String>(
                      value: leaveType,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Text(
                          leaveType,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedLeaveType.value = newValue;
                      controller.isLeaveTypeFocused.value = true;
                    }
                  },
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFields(
      StaffApplyLeaveController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From Date', style: Styles.darkGryW600),
                const SizedBox(height: 4),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.fromDateFocusNode.requestFocus();
                      controller.selectFromDate(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: controller.isFromDateFocused.value
                            ? Colors.white
                            : (controller.fromDate.value.isNotEmpty
                                ? Colors.blue.shade50
                                : Colors.grey.shade50),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (controller.isFromDateFocused.value ||
                                  controller.fromDate.value.isNotEmpty)
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                          width: (controller.isFromDateFocused.value ||
                                  controller.fromDate.value.isNotEmpty)
                              ? 1.5
                              : 1,
                        ),
                      ),
                      child: Obx(() => Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: (controller.isFromDateFocused.value ||
                                        controller.fromDate.value.isNotEmpty)
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.fromDate.value.isEmpty
                                    ? 'mm/dd/yyy'
                                    : controller.fromDate.value,
                                style: TextStyle(
                                  color: controller.fromDate.value.isEmpty
                                      ? Colors.grey
                                          .shade400 // 🔥 Light Grey when empty
                                      : Colors
                                          .black87, // 🔥 Black when selected
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To Date', style: Styles.darkGryW600),
                const SizedBox(height: 4),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.toDateFocusNode.requestFocus();
                      controller.selectToDate(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: controller.isToDateFocused.value
                            ? Colors.white
                            : (controller.toDate.value.isNotEmpty
                                ? Colors.blue.shade50
                                : Colors.grey.shade50),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (controller.isToDateFocused.value ||
                                  controller.toDate.value.isNotEmpty)
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                          width: (controller.isToDateFocused.value ||
                                  controller.toDate.value.isNotEmpty)
                              ? 1.5
                              : 1,
                        ),
                      ),
                      child: Obx(() => Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: (controller.isToDateFocused.value ||
                                        controller.toDate.value.isNotEmpty)
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.toDate.value.isEmpty
                                    ? 'mm/dd/yyy'
                                    : controller.toDate.value,
                                style: TextStyle(
                                  color: controller.toDate.value.isEmpty
                                      ? Colors.grey
                                          .shade400 // 🔥 Light Grey when empty
                                      : Colors
                                          .black87, // 🔥 Black when selected
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
    );
  }

  Widget _buildReasonField(StaffApplyLeaveController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason for Leave', style: Styles.darkGryW600),
          const SizedBox(height: 4),
          Obx(
            () => TextField(
              controller: controller.reasonController,
              focusNode: controller.reasonFocusNode,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              onSubmitted: (_) {
                controller.reasonFocusNode.unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                filled: true,
                fillColor: controller.isReasonFocused.value
                    ? Colors.white
                    : (controller.reasonController.text.isNotEmpty
                        ? Colors.blue.shade50
                        : Colors.grey.shade50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: controller.isReasonFocused.value ||
                            controller.reasonController.text.isNotEmpty
                        ? Colors.blue.shade700
                        : Colors.grey.shade300,
                    width: (controller.isReasonFocused.value ||
                            controller.reasonController.text.isNotEmpty)
                        ? 1.5
                        : 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: controller.isReasonFocused.value ||
                            controller.reasonController.text.isNotEmpty
                        ? Colors.blue.shade700
                        : Colors.grey.shade300,
                    width: (controller.isReasonFocused.value ||
                            controller.reasonController.text.isNotEmpty)
                        ? 1.5
                        : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadSection(
      StaffApplyLeaveController controller, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attachment (Optional)', style: Styles.darkGryW600),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.blue.shade200,
                strokeWidth: 1.5,
                dashPattern: const [8, 6],
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AssetConstants.icUpload,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Document',
                          style: Styles.darkBlackW40012,
                        ),
                        const SizedBox(height: 6),
                        Obx(() => controller.selectedFileName.value.isNotEmpty
                            ? Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 80,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle,
                                        size: 16, color: Colors.green.shade600),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        controller.selectedFileName.value,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => controller.pickFile(),
                          icon: const Icon(Icons.cloud_upload, size: 18),
                          label: const Text(
                            'Choose File',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsValue.blcColors,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSubmitButton(
      StaffApplyLeaveController controller, BuildContext context) {
    return Obx(
      () => Opacity(
        opacity: controller.isFormValid.value ? 1.0 : 0.5,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: GradientButton(
            onPressed:
                controller.isFormValid.value && !controller.isLoading.value
                    ? () {
                        FocusScope.of(context).unfocus();
                        controller.submitLeave(context);
                      }
                    : () {},
            text:
                controller.isLoading.value ? 'Submitting...' : 'Submit Request',
          ),
        ),
      ),
    );
  }
}
