import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class StudentFeeListScreen extends StatefulWidget {
  const StudentFeeListScreen({super.key});

  @override
  State<StudentFeeListScreen> createState() => _StudentFeeListScreenState();
}

class _StudentFeeListScreenState extends State<StudentFeeListScreen> {
  // ========== FILTER STATE ==========
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Paid', 'Unpaid', 'Partial'];

  // ========== STUDENT FEE DATA ==========
  final List<Map<String, dynamic>> studentFeeList = [
    {
      'name': 'Aarav Sharma',
      'roll': '101',
      'status': 'Paid',
      'amount': '₹15,000',
      'amountPaid': '₹15,000',
    },
    {
      'name': 'Isha Singh',
      'roll': '102',
      'status': 'Unpaid',
      'amount': '₹15,000',
      'amountPaid': '₹0',
    },
    {
      'name': 'Rohan Patel',
      'roll': '103',
      'status': 'Partial',
      'amount': '₹15,000',
      'amountPaid': '₹7,500',
    },
    {
      'name': 'Priya Mehta',
      'roll': '104',
      'status': 'Paid',
      'amount': '₹15,000',
      'amountPaid': '₹15,000',
    },
    {
      'name': 'Arjun Kumar',
      'roll': '105',
      'status': 'Unpaid',
      'amount': '₹15,000',
      'amountPaid': '₹0',
    },
    {
      'name': 'Sneha Reddy',
      'roll': '106',
      'status': 'Partial',
      'amount': '₹15,000',
      'amountPaid': '₹5,000',
    },
  ];

  // ========== GET FILTERED LIST ==========
  List<Map<String, dynamic>> get filteredList {
    if (selectedFilter == 'All') {
      return studentFeeList;
    }
    return studentFeeList
        .where((student) => student['status'] == selectedFilter)
        .toList();
  }

  // ========== GET STATUS COUNT ==========
  int getStatusCount(String status) {
    return studentFeeList.where((s) => s['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
          // ========== HEADER BACKGROUND ==========
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

          // ========== MAIN CONTENT ==========
          SafeArea(
            child: Column(
              children: [
                // ========== HEADER ==========
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
                          Text('Strudent Fee List', style: Styles.whiteBold),
                        ],
                      ),
                      // ========== FILTER DROPDOWN ==========
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 20,
                            ),
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items: filterOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: Styles.whiteBold14600,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFilter = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== CLASS & TERM CARD ==========
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade50,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.06),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // ========== ROW 1: Class & Students ==========
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Class',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Class VI - A',
                                          style: Styles.darkBlcW70013,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Vertical Divider
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Term',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Term(Apr-Sep)',
                                          style: Styles.darkBlcW70013,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ========== STUDENT LIST TITLE ==========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Student List (VI - A)',
                              style: Styles.darkBlcW700,
                            ),
                            Text(
                              '${filteredList.length} Students',
                              style: Styles.skyBlueW60012,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ========== STUDENT LIST ==========
                        Column(
                          children: filteredList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final student = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: _buildStudentRow(
                                name: student['name'] as String? ?? '',
                                roll: student['roll'] as String? ?? '',
                                status: student['status'] as String? ?? '',
                                amount: student['amount'] as String? ?? '',
                                amountPaid:
                                    student['amountPaid'] as String? ?? '',
                              ),
                            );
                          }).toList(),
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

  // ========== BUILD STUDENT ROW ==========
  Widget _buildStudentRow({
    required String name,
    required String roll,
    required String status,
    required String amount,
    required String amountPaid,
  }) {
    // Get initial from name
    String initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';

    // Get color based on initial
    Color getColor(String initial) {
      final colors = [
        Colors.blue,
        Colors.orange,
        Colors.green,
        Colors.purple,
        Colors.red,
        Colors.teal,
        Colors.pink,
        Colors.indigo,
      ];
      int index = initial.codeUnitAt(0) % colors.length;
      return colors[index];
    }

    Color avatarColor = getColor(initial);

    // Get status color
    Color getStatusColor(String status) {
      switch (status) {
        case 'Paid':
          return Colors.green;
        case 'Unpaid':
          return Colors.red;
        case 'Partial':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    Color statusColor = getStatusColor(status);

    // Get status icon
    IconData getStatusIcon(String status) {
      switch (status) {
        case 'Paid':
          return Icons.check_circle;
        case 'Unpaid':
          return Icons.cancel;
        case 'Partial':
          return Icons.hourglass_top;
        default:
          return Icons.help;
      }
    }

    return Column(
      children: [
        // ========== FIRST ROW: Avatar, Name, Roll, Status ==========
        Row(
          children: [
            // ========== INITIAL AVATAR ==========
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ========== STUDENT NAME & ROLL ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Styles.darkBlcW70013,
                  ),
                  Text(
                    'Roll: $roll',
                    style: Styles.darkBlueW400,
                  ),
                ],
              ),
            ),

            // ========== STATUS BADGE ==========
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getStatusIcon(status),
                    size: 12,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ========== DIVIDER ==========
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Divider(
            color: Colors.grey.shade200,
            height: 1,
            thickness: 1,
          ),
        ),

        // ========== SECOND ROW: Amount Left, Amount Right ==========
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side label
            Text(
              status == 'Paid'
                  ? 'Amount Paid'
                  : status == 'Unpaid'
                      ? 'Total Dues'
                      : 'Amount Paid',
              style: Styles.darkBlueW40010,
            ),
            // Right side amount
            Text(
              status == 'Paid'
                  ? amount
                  : status == 'Unpaid'
                      ? amount
                      : amountPaid,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: status == 'Paid'
                    ? Colors.green.shade700
                    : status == 'Unpaid'
                        ? Colors.red.shade700
                        : Colors.orange.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
