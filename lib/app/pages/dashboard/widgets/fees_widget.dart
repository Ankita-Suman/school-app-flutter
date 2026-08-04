import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/pages/dashboard/dashboard_controller.dart';

import '../../../../domain/models/fees_response.dart';
import '../../../widgets/dashed_widget.dart';
import '../../../widgets/gradient_button.dart';

class FeesDetailsScreen extends StatelessWidget {
  const FeesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight * 0.26; // 22% of screen height

    return Scaffold(
      body: Obx(() {
        // Get fee data
        final feeData = controller.feeData.value?.data;

        return Stack(
          children: [
            // ✅ Responsive SVG Background - FIXED
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

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Fixed Header Section (Non-scrollable)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.back();
                              //   },
                              //   child: SvgPicture.asset(
                              //       AssetConstants.icBackBg,
                              //       // height: 20,
                              //       // width: 20,
                              //   ),
                              // ),
                              const SizedBox(width: 8),
                              Text('Fees Details', style: Styles.whiteBold),
                            ]),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      feeData?.student?.firstName
                                              ?.substring(0, 1) ??
                                          'AS',
                                      style: Styles.whiteW70011,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      feeData?.student?.fullName ??
                                          'Student Name',
                                      style: Styles.whiteW70011,
                                    ),
                                    Text(
                                      'Roll No: ${feeData?.student?.rollNumber ?? 'N/A'}',
                                      style: Styles.whiteW40010,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 3 Containers Row - Total Due, Paid, Pending
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: Column(
                                    children: [
                                      Text(
                                        '₹${feeData?.cards?.totalDue ?? 0}',
                                        style: Styles.whiteExBold15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('TOTAL DUE',
                                          style: Styles.whiteW60009),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.titleGreenColors
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsValue.titleGreenColors
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: Column(
                                    children: [
                                      Text(
                                        '₹${feeData?.cards?.paid ?? 0}',
                                        style: Styles.whiteExBold15G,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Paid', style: Styles.whiteW60009),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.titleRedColors
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsValue.titleRedColors
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: Column(
                                    children: [
                                      Text(
                                        '₹${feeData?.cards?.pending ?? 0}',
                                        style: Styles.whiteExBold15R,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('PENDING',
                                          style: Styles.whiteW60009),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dynamic spacing
                      SizedBox(height: backgroundHeight * 0.12),
                    ],
                  ),

                  // Scrollable Content (Grand Total + Expandable List)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Grand Total Overview Section
                            Padding(
                              padding: Dimens.edgeInsets10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text('GRAND TOTAL OVERVIEW',
                                      style: Styles.darkBlackW70012),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: Text('AMOUNT',
                                              textAlign: TextAlign.center,
                                              style: Styles.darkBlackW60009)),
                                      Expanded(
                                          child: Text('DISCOUNT',
                                              textAlign: TextAlign.center,
                                              style: Styles.darkBlackW60009)),
                                      Expanded(
                                          child: Text('FINE',
                                              textAlign: TextAlign.center,
                                              style: Styles.darkBlackW60009)),
                                      Expanded(
                                          child: Text('PAID',
                                              textAlign: TextAlign.center,
                                              style: Styles.darkBlackW60009)),
                                      Expanded(
                                          child: Text('BALANCE',
                                              textAlign: TextAlign.center,
                                              style: Styles.darkBlackW60009)),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '₹${feeData?.grandTotal?.amount ?? 0}',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkBlcW70013,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '₹${feeData?.grandTotal?.discount ?? 0}',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkGreenW70013,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '₹${feeData?.grandTotal?.fine ?? 0}',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkOrangeW70013,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '₹${feeData?.grandTotal?.paid ?? 0}',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkGreenW70013,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '₹${feeData?.grandTotal?.balance ?? 0}',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkRedW70013,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Expandable List - Pass invoices data
                            if (feeData?.invoices != null &&
                                feeData!.invoices!.isNotEmpty)
                              ExpandableFeesList(
                                invoices: feeData.invoices!,
                              )
                            else
                              Container(
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No invoice data available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
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

// ExpandableFeesList with API data integration - No changes
class ExpandableFeesList extends StatefulWidget {
  final List<Invoice> invoices;

  const ExpandableFeesList({super.key, required this.invoices});

  @override
  State<ExpandableFeesList> createState() => _ExpandableFeesListState();
}

class _ExpandableFeesListState extends State<ExpandableFeesList> {
  int _expandedIndex = -1;

  String getMonthName(String invoicePeriod) {
    final Map<String, String> monthMap = {
      'M1': 'April 2025',
      'M2': 'May 2025',
      'M3': 'June 2025',
      'M4': 'July 2025',
      'M5': 'Aug 2025',
      'M6': 'Sep 2025',
      'M7': 'Oct 2025',
      'M8': 'Nov 2025',
      'M9': 'Dec 2025',
      'M10': 'Jan 2026',
      'M11': 'Feb 2026',
      'M12': 'March 2026',
    };
    return monthMap[invoicePeriod] ?? invoicePeriod;
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'PARTIAL':
        return Colors.orange;
      case 'PENDING':
        return Colors.red;
      case 'UPCOMING':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.invoices.length,
        itemBuilder: (context, index) {
          final invoice = widget.invoices[index];
          final isLastItem = index == widget.invoices.length - 1;
          final isExpanded = _expandedIndex == index;

          final totalNetAmount = invoice.netAmount ?? 0;
          final totalPaidAmount = invoice.paidAmount ?? 0;
          final totalPendingAmount = invoice.pendingAmount ?? 0;

          return Column(
            children: [
              Container(
                color: isExpanded ? ColorsValue.lightBgPinkClr : Colors.white,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_expandedIndex == index) {
                            _expandedIndex = -1;
                          } else {
                            _expandedIndex = index;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                        invoice.status ?? 'UPCOMING'),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  getMonthName(invoice.invoicePeriod ?? ''),
                                  style: Styles.darkBlcW70013,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${invoice.netAmount ?? 0}',
                                  style: Styles.darkGryW70012,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                            invoice.status ?? 'UPCOMING')
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: ColorsValue.lightOrangeColors,
                                        width: 1),
                                  ),
                                  child: Text(
                                    invoice.status ?? 'UPCOMING',
                                    style: Styles.darkOrangeW8009,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Column(
                        children: [
                          if (invoice.items != null)
                            ...invoice.items!.map((item) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: Dimens.edgeInsets15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.feeTitle ?? '',
                                            style: Styles.darkBlackW400),
                                        Text('₹${item.finalAmount ?? 0}',
                                            style: Styles.darkBlcW600),
                                      ],
                                    ),
                                  ),
                                  const DashedDivider(),
                                ],
                              );
                            }),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 15, left: 25, right: 25, bottom: 15),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Net Amount',
                                        style: Styles.darkBlkW400),
                                    Text('₹$totalNetAmount',
                                        style: Styles.darkBlcW70012),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(
                                      thickness: 1,
                                      color: ColorsValue.bordersColor),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Paid', style: Styles.darkBlkW400),
                                    Text('₹$totalPaidAmount',
                                        style: Styles.darkGreenW70012),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(
                                      thickness: 1,
                                      color: ColorsValue.bordersColor),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pending', style: Styles.darkBlkW400),
                                    Text('₹$totalPendingAmount',
                                        style: Styles.darkRedW70012),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      RouteManagement.goToPayment();
                                    },
                                    child: Container(
                                      height: 70,
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          GradientButton(
                                            onPressed: () {
                                              RouteManagement.goToPayment();
                                            },
                                            text:
                                                'Pay Now →', // Just add arrow in text
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        RouteManagement.goToInvoice(
                                            invoiceId: invoice.id ?? '');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors.blue.shade700),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AssetConstants.icView,
                                            height: 16,
                                            width: 16,
                                            colorFilter: ColorFilter.mode(
                                                Colors.blue.shade700,
                                                BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 6),
                                          Text('View',
                                              style: Styles.blueBold70010),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
              ),
              if (!isLastItem && !isExpanded)
                const Divider(
                    height: 1, thickness: 1, color: ColorsValue.bordersColor),
            ],
          );
        },
      ),
    );
  }
}
