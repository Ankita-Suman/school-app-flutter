// screens/fees_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight * 0.32; // 28% of screen height

    return Scaffold(
      body: Stack(
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
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                AssetConstants.icBackBg,
                                // height: 20,
                                // width: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Payment', style: Styles.whiteBold),
                          ]),
                        ],
                      ),
                    ),

                    // Total Amount Payable Card (Centered)
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.014,
                          horizontal: screenWidth * 0.12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'TOTAL AMOUNT PAYABLE',
                              style: Styles.whiteW400,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs. 12,500',
                              style: Styles.whiteW800,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Term 2 Fee (2025-2026)',
                                style: Styles.whiteW40011Op,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dynamic spacing
                    SizedBox(height: backgroundHeight * 0.1),
                  ],
                ),

                // Scrollable Content - Payment Methods
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Payment Method Title
                          Text(
                            'Payment Method',
                            style: Styles.darkBlcW70014,
                          ),
                          const SizedBox(height: 12),

                          // Credit/Debit Card Section Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _buildPaymentMethodRow(
                              icon: AssetConstants.icVisa,
                              title: 'Axis Bank Debit Card',
                              subtitle: '************4215',
                              isSelected: _selectedPaymentMethod == 'card',
                              value: 'card',
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = 'card';
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // UPI Section Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedPaymentMethod = 'upi';
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            AssetConstants.icUpi,
                                            height: 28,
                                            width: 28,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pay via UPI',
                                                style: Styles.darkBlcW70013,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Google Pay, PhonePe, Paytm',
                                                style: Styles.darkBlueW400,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: 1.2,
                                          child: Radio(
                                            value: 'upi',
                                            groupValue: _selectedPaymentMethod,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPaymentMethod =
                                                    value.toString();
                                              });
                                            },
                                            activeColor: Colors.blue.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Add New Card Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _buildAddNewCardRow(),
                          ),

                          // Responsive bottom space
                          SizedBox(height: screenHeight * 0.12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Fixed Pay Now Button at Bottom
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
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentMethod == 'card') {
                      Get.snackbar('Payment', 'Paying with Card');
                    } else {
                      Get.snackbar('Payment', 'Paying with UPI');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Pay Now',
                    style: Styles.whiteBold15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow({
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Card Icon
            Center(
              child: SvgPicture.asset(
                icon,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),

            // Card Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.darkBlcW70013,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Styles.darkBlueW400,
                  ),
                ],
              ),
            ),
            // Radio Button
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: value,
                groupValue: _selectedPaymentMethod,
                onChanged: (selectedValue) {
                  setState(() {
                    _selectedPaymentMethod = selectedValue.toString();
                  });
                  onTap();
                },
                activeColor: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardRow() {
    return InkWell(
      onTap: () {
        // Handle add new card
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Add Card Icon
            Center(
              child: SvgPicture.asset(
                AssetConstants.icAddCard,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),

            // Add Card Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Card',
                    style: Styles.blueW70013,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Credit / Debit Card',
                    style: Styles.darkBlueW400,
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
