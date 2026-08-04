import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import 'apply_leave_controller.dart';

class ApplyLeaveScreen extends StatelessWidget {
  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplyLeaveController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 100.0 : 130.0;

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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(AssetConstants.icBackBg),
                      ),
                      const SizedBox(width: 8),
                      Text('Apply Leave', style: Styles.whiteBold),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Leave Type
                        Text('Leave Type', style: Styles.darkGryW600),
                        const SizedBox(height: 6),
                        Obx(
                              () => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.selectedLeaveType.value.isNotEmpty
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: controller.selectedLeaveType.value,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: GoogleFonts.sora().fontFamily,
                              ),
                              items: controller.leaveTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type['value'],
                                  child: Text(
                                    type['label']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: GoogleFonts.sora().fontFamily,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectedLeaveType.value = value;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // From & To Date
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('From Date', style: Styles.darkGryW600),
                                  const SizedBox(height: 6),
                                  _buildDateField(
                                    controller: controller.fromDateController,
                                    hint: 'mm/dd/yyyy',
                                    context: context,
                                    displayValue: controller.fromDateDisplay,
                                    onDateSelected: controller.setFromDate,
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
                                  const SizedBox(height: 6),
                                  _buildDateField(
                                    controller: controller.toDateController,
                                    hint: 'mm/dd/yyyy',
                                    context: context,
                                    displayValue: controller.toDateDisplay,
                                    onDateSelected: controller.setToDate,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Reason
                        Text('Reason for Leave', style: Styles.darkGryW600),
                        const SizedBox(height: 6),
                        ValueListenableBuilder(
                          valueListenable: controller.reasonController,
                          builder: (context, TextEditingValue value, child) {
                            final bool hasText = value.text.trim().isNotEmpty;
                            return TextField(
                              controller: controller.reasonController,
                              maxLines: 3,
                              maxLength: 200,
                              style: TextStyle(
                                fontFamily: GoogleFonts.sora().fontFamily,
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter reason...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: hasText ? Colors.blue : Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: hasText ? Colors.blue : Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.blue),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        // Attachment
                        Text('Attachment (Optional)', style: Styles.darkGryW600),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => controller.pickFile(),
                          child: Obx(
                                () => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: controller.fileName.value.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetConstants.icUpload,
                                    height: 48,
                                    width: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Tap to Upload Document',
                                      style: Styles.darkBlcW400,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  Text('PDF, JPG, PNG',
                                      style: Styles.darkBlueW400,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 12),
                                  if (controller.fileName.value.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle,
                                              size: 16,
                                              color: Colors.green.shade600),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              controller.fileName.value,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                                fontFamily:
                                                GoogleFonts.sora().fontFamily,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: controller.removeFile,
                                            child: Icon(Icons.close,
                                                size: 18,
                                                color: Colors.red.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button – NOW WITH LOADING STATE
                        Obx(
                              () {
                            final bool isValid = _isFormValid(controller);
                            final bool isSubmitting = controller.isSubmitting.value;
                            return AbsorbPointer(
                              absorbing: !isValid || isSubmitting,
                              child: Opacity(
                                opacity: (isValid && !isSubmitting) ? 1.0 : 0.5,
                                child: GradientButton(
                                  onPressed: (isValid && !isSubmitting)
                                      ? () {
                                    controller.submitLeaveApplication(
                                      leaveType: controller.selectedLeaveType.value,
                                      fromDate: controller.fromDateController.text,
                                      toDate: controller.toDateController.text,
                                      reason: controller.reasonController.text,
                                    );
                                  }
                                      : () {},
                                  text: isSubmitting ? 'Submitting...' : 'Submit Leave',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
    required BuildContext context,
    required RxString displayValue,
    required Function(DateTime) onDateSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) onDateSelected(date);
      },
      child: Obx(
            () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: displayValue.value.isNotEmpty ? Colors.blue : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  displayValue.value.isEmpty ? hint : displayValue.value,
                  style: TextStyle(
                    fontFamily: GoogleFonts.sora().fontFamily,
                    color: displayValue.value.isEmpty
                        ? Colors.grey.shade400
                        : Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFormValid(ApplyLeaveController controller) {
    return controller.selectedLeaveType.value.isNotEmpty &&
        controller.fromDateController.text.isNotEmpty &&
        controller.toDateController.text.isNotEmpty &&
        controller.reasonController.text.trim().isNotEmpty;
  }
}