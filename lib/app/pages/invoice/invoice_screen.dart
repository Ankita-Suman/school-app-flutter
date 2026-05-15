// app/pages/invoice/invoice_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/invoice_response.dart';
import '../../app.dart';
import 'invoice_controller.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.put(InvoiceController(Get.find()));

    return Scaffold(
      body: Obx(() {// Loading state
        // Error state
        if (controller.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final invoice = controller.invoiceData.value?.data;
        if (invoice == null) {
          return const Center(child: Text('No data available'));
        }

        return Stack(
          children: [
            // SVG Background with full width and static height
            SizedBox(
              width: double.infinity,
              height: 180,
              child: SvgPicture.asset(
                AssetConstants.icBlueBg,
                width: double.infinity,
                height: 180,
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
                      const SizedBox(height: 25),

                      // Header Section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: SvgPicture.asset(AssetConstants.icBackBg),
                                ),
                                const SizedBox(width: 8),
                                Text('Invoice', style: Styles.whiteBold),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      invoice.student?.name?.substring(0, 1) ?? 'S',
                                      style: Styles.whiteW70011,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      invoice.student?.name ?? 'Student Name',
                                      style: Styles.whiteW70011,
                                    ),
                                    Text(
                                      '${invoice.student?.className ?? 'Class'} ${invoice.student?.section ?? ''}',
                                      style: Styles.whiteW40010,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Invoice Details Row
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Invoice No.', style: Styles.whiteW40010),
                                const SizedBox(height: 4),
                                Text(
                                  invoice.invoice?.invoiceNumber ?? 'N/A',
                                  style: Styles.whiteBold15,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Generated On', style: Styles.whiteW40010),
                                const SizedBox(height: 4),
                                Text(
                                  invoice.invoice?.invoiceDate ?? 'N/A',
                                  style: Styles.whiteW50011,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: invoice.invoice?.status?.toUpperCase() == 'PAID'
                                    ? Colors.green
                                    : invoice.invoice?.status?.toUpperCase() == 'PARTIAL'
                                    ? Colors.orange
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                invoice.invoice?.status ?? 'UNKNOWN',
                                style: Styles.whiteW80010,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // White/Light Grey Background Container for scrollable area
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: InvoiceCard(invoice: invoice),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final InvoiceData invoice;
  const InvoiceCard({super.key, required this.invoice});

  String getMonthName(String period) {
    final Map<String, String> monthMap = {
      'M1': 'April', 'M2': 'May', 'M3': 'June', 'M4': 'July',
      'M5': 'August', 'M6': 'September', 'M7': 'October',
      'M8': 'November', 'M9': 'December', 'M10': 'January',
      'M11': 'February', 'M12': 'March',
    };
    return monthMap[period] ?? period;
  }

  @override
  Widget build(BuildContext context) {
    final netAmount = invoice.summary?.netAmount ?? 0;
    final paidAmount = invoice.summary?.paidAmount ?? 0;
    final pendingAmount = invoice.summary?.pendingAmount ?? 0;
    final feeItems = invoice.feeItems ?? [];
    final paymentHistory = invoice.paymentHistory ?? [];

    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: BILLED TO (Left) and Month (Right)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BILLED TO', style: Styles.darkBlkW70010),
                    const SizedBox(height: 8),
                    Text(
                      invoice.student?.name ?? 'Student Name',
                      style: Styles.darkBlcW70014,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${invoice.student?.className ?? 'Class'} ${invoice.student?.section ?? ''} · Roll No. ${invoice.student?.rollNumber ?? 'N/A'}',
                      style: Styles.darkBlkW400,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      invoice.student?.admissionNumber ?? 'N/A',
                      style: Styles.darkBlkW400,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorsValue.navSelectColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorsValue.bgSkyColors,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        getMonthName(invoice.invoice?.invoicePeriod ?? ''),
                        style: Styles.blueW70013,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().year} · Session ${invoice.student?.session ?? '2026-27'}',
                        style: Styles.darkBlkW40010,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Light Blue Container for Description and Amount Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DESCRIPTION', style: Styles.darkBlueW70010),
                Text('AMOUNT', style: Styles.darkBlueW70010),
              ],
            ),
          ),

          const Divider(
            thickness: 1,
            color: ColorsValue.bgSkyColors,
            height: 0,
          ),

          // Dynamic Fee Items from API
          ...feeItems.map((item) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.feeTitle ?? '', style: Styles.darkBlcW50012),
                    Text('₹${item.finalAmount ?? 0}', style: Styles.darkBlcW600),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade200,
                height: 0,
              ),
            ],
          )),

          const Divider(
            thickness: 2,
            color: ColorsValue.lightBorderBlueColor,
            height: 0,
          ),

          // Net Amount Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              color: ColorsValue.navSelectColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Amount', style: Styles.darkBlueW70013),
                Text('₹$netAmount', style: Styles.darkBlueW80015),
              ],
            ),
          ),

          // Amount Paid Container
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsValue.lightBgPinkClr,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount Paid', style: Styles.darkBlkW400),
                      Text('₹$paidAmount', style: Styles.darkGreenW70012),
                    ],
                  ),
                ),
                 Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Balance Pending', style: Styles.darkBlkW400),
                      Text('₹$pendingAmount', style: Styles.darkRedW70012),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Receipt History Card
          ReceiptHistoryCard(paymentHistory: paymentHistory),

          // Warning Container
          if (invoice.warning != null && invoice.warning!.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: ColorsValue.lightBgOrangeClrss,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsValue.lightOrangeClrss,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Styles.darkOrangeW400,
                        children: [
                          const TextSpan(text: '⚠️ '),
                          TextSpan(
                            text: invoice.warning ?? '',
                            style: Styles.darkOrangeW400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class ReceiptHistoryCard extends StatelessWidget {
  final List<PaymentHistory> paymentHistory;
  const ReceiptHistoryCard({super.key, required this.paymentHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Light Pink Header Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: ColorsValue.lightBgPinkClr,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Recpt No.',
                    style: Styles.darkBlkW400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date',
                    style: Styles.darkBlkW400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Collected',
                    style: Styles.darkBlkW400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Mode',
                    style: Styles.darkBlkW400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Action',
                    style: Styles.darkBlkW400,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // ListView with White Background
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: paymentHistory.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No payment history')),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentHistory.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                final receipt = paymentHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          receipt.receiptNumber ?? 'N/A',
                          style: Styles.darkBlkW600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          receipt.collectionDate ?? 'N/A',
                          style: Styles.darkBlkW600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '₹${receipt.amountCollected ?? 0}',
                          style: Styles.darkBlkW600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          receipt.collectionMode ?? 'N/A',
                          style: Styles.darkBlkW600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Download receipt action
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              AssetConstants.download,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}