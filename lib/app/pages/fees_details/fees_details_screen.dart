// screens/fees_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/dashed_widget.dart';

class FeesDetailsScreen extends StatelessWidget {
  const FeesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG Background with specific height
          SvgPicture.asset(
            AssetConstants.icBlueBg,
            width: MediaQuery.of(context).size.width,
            height: 210,
            fit: BoxFit.fill,
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Fixed Header Section (Non-scrollable)
                Column(
                  children: [
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                AssetConstants.icBackBg,
                              ),
                            ),
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
                                  child: Text('AS', style: Styles.whiteW70011),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Arjun Sharma',
                                      style: Styles.whiteW70011),
                                  Text('Class 9-A', style: Styles.whiteW40010),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 3 Containers Row
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
                                    Text('₹22,560',
                                        style: Styles.whiteExBold15),
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
                                    Text('₹5,080',
                                        style: Styles.whiteExBold15G),
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
                                color:
                                    ColorsValue.titleRedColors.withOpacity(0.1),
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
                                    Text('₹17,480',
                                        style: Styles.whiteExBold15R),
                                    const SizedBox(height: 4),
                                    Text('PENDING', style: Styles.whiteW60009),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // Scrollable Content (Grand Total + Expandable List)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Grand Total Overview Section
                        Padding(
                          padding: Dimens.edgeInsets15,
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
                                        child: Text('₹22,560',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkBlcW70013)),
                                    Expanded(
                                        child: Text('₹0',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkGreenW70013)),
                                    Expanded(
                                        child: Text('₹0',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkOrangeW70013)),
                                    Expanded(
                                        child: Text('₹5,080',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkGreenW70013)),
                                    Expanded(
                                        child: Text('₹17,480',
                                            textAlign: TextAlign.center,
                                            style: Styles.darkRedW70013)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Expandable List
                        const ExpandableFeesList(),

                        const SizedBox(height: 20),
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
}

// Alternative using Flutter's built-in ExpansionTile (Without Header)
// Complete ExpandableFeesList with Pink Background when expanded
class ExpandableFeesList extends StatefulWidget {
  const ExpandableFeesList({super.key});

  @override
  State<ExpandableFeesList> createState() => _ExpandableFeesListState();
}

class _ExpandableFeesListState extends State<ExpandableFeesList> {
  int _expandedIndex = -1;

  final List<Map<String, dynamic>> _feeItems = [
    {
      'month': 'April 2025',
      'amount': '₹5,080',
      'status': 'PARTIAL',
      'statusColor': Colors.orange,
    },
    {
      'month': 'May 2025',
      'amount': '₹1,480',
      'status': 'PENDING',
      'statusColor': Colors.red,
    },
    {
      'month': 'June 2025',
      'amount': '₹1,480',
      'status': 'UPCOMING',
      'statusColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        itemCount: _feeItems.length,
        itemBuilder: (context, index) {
          final item = _feeItems[index];
          final isLastItem = index == _feeItems.length - 1;
          final isExpanded = _expandedIndex == index;

          return Column(
            children: [
              // Main Container - Background changes based on expand state
              Container(
                color: isExpanded ? Colors.pink.shade50 : Colors.white,
                child: Column(
                  children: [
                    // Main Row
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
                                    color: item['statusColor'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(item['month'],
                                    style: Styles.darkBlcW70013),
                              ],
                            ),
                            Row(
                              children: [
                                Text(item['amount'],
                                    style: Styles.darkGryW70012),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item['statusColor'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ColorsValue.lightOrangeColors,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(item['status'],
                                      style: Styles.darkOrangeW8009),
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

                    // Expanded Content - Shows only when expanded
                    if (isExpanded)
                      Column(
                        children: [
                          // Annual Charges
                          Padding(
                            padding: Dimens.edgeInsets15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Annual Charges',
                                    style: Styles.darkBlackW400),
                                Text('₹3,600', style: Styles.darkBlcW600),
                              ],
                            ),
                          ),

                          const DashedDivider(),

                          // Monthly Fee
                          Padding(
                            padding: Dimens.edgeInsets15_10_15_0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly Fee',
                                    style: Styles.darkBlackW400),
                                Text('₹1,480', style: Styles.darkBlcW600),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Net Amount
                          Container(
                            padding: const EdgeInsets.only(
                                top: 15, left: 25, right: 25, bottom: 15),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              //borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Net Amount',
                                        style: Styles.darkBlkW400),
                                    Text('₹5,080', style: Styles.darkBlcW70012),
                                  ],
                                ),
                                Padding(
                                    padding: Dimens.edgeInsets0_5_0_5,
                                    child: const Divider(
                                      thickness: 1,
                                      color: ColorsValue.bordersColor,
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Paid', style: Styles.darkBlkW400),
                                    Text('₹3,600',
                                        style: Styles.darkGreenW70012),
                                  ],
                                ),
                                Padding(
                                    padding: Dimens.edgeInsets0_5_0_5,
                                    child: const Divider(
                                      thickness: 1,
                                      color: ColorsValue.bordersColor,
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pending', style: Styles.darkBlkW400),
                                    Text('₹1,480', style: Styles.darkRedW70012),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Buttons Row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // ✅ Added for vertical center
                              children: [
                                // Pay Now Button - Full width, SVG background
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 70,
                                      // ✅ Fixed height
                                      alignment: Alignment.center,
                                      // ✅ Center content
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AssetConstants.icBtn,
                                            width: double.infinity,
                                            height: 70,
                                            fit: BoxFit.fill,
                                          ),
                                          const Text(
                                            'Pay Now →',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // View Button - Less width, SVG icon + text
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    // ✅ Same height as Pay Now button
                                    alignment: Alignment.center,
                                    // ✅ Center content
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors.blue.shade700),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
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
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'View',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
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

                          const SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
              ),

              // Divider between items (except last)
              if (!isLastItem && !isExpanded)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorsValue.bordersColor,
                ),
            ],
          );
        },
      ),
    );
  }
}
